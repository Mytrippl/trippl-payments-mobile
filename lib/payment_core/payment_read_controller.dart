import 'dart:async';
import '../trippl_payments_mobile.dart';

abstract interface class PaymentReadProvider {
  Future<PaymentReadPage> read(PaymentReadRequest request);
}

class PaymentReadController {
  PaymentReadController(
    this.provider, {
    required this.scope,
    required this.environment,
    required this.clock,
    PaymentReadPolicy? policy,
    PaymentRetryPolicy? retryPolicy,
  }) : policy = policy ?? PaymentReadPolicy(),
       retryPolicy = retryPolicy ?? PaymentRetryPolicy() {
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    PaymentGuard.record(this.policy.validate());
    PaymentGuard.record(this.retryPolicy.validate());
  }
  final PaymentReadProvider provider;
  final String scope, environment;
  final DateTime Function() clock;
  final PaymentReadPolicy policy;
  final PaymentRetryPolicy retryPolicy;
  int _generation = 0, _inflight = 0;
  bool _closed = false;
  PaymentReadState? _state;
  PaymentReadState? get state => _state;
  static void validate(
    PaymentReadRequest request,
    PaymentReadPage page, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(request.validate());
    PaymentGuard.record(page.validate());
    PaymentGuard.scope(request.scopeFingerprint, scope);
    PaymentGuard.scope(page.scopeFingerprint, scope);
    if (request.environment != page.environment ||
        request.createdAt.isAfter(now) ||
        page.requestFingerprint != PaymentRequests.readFingerprint(request) ||
        !page.serverVerified ||
        !PaymentGuard.fresh(page.observedAt, page.expiresAt, now) ||
        page.intents.length > request.limit ||
        page.methods.length > request.limit ||
        page.receipts.length > request.limit ||
        page.refunds.length > request.limit)
      throw StateError('Payment read binding freshness or capacity mismatch');
    PaymentGuard.distinct(page.intents.map((i) => i.id));
    PaymentGuard.distinct(page.methods.map((m) => m.methodId));
    if (request.mode != 'intent' && page.intents.isNotEmpty ||
        request.mode != 'methods' && page.methods.isNotEmpty ||
        request.mode != 'receipt' && page.receipts.isNotEmpty ||
        request.mode != 'refunds' && page.refunds.isNotEmpty ||
        request.mode != 'currencies' && page.currencyCatalog != null)
      throw StateError('Payment response contains unrelated data types');
    for (final i in page.intents) {
      PaymentGuard.scope(i.scopeFingerprint, scope);
      if (i.environment != request.environment ||
          i.id != request.intentId ||
          i.orderId != request.orderId ||
          !i.serverVerified ||
          !PaymentGuard.fresh(i.observedAt, i.expiresAt, now))
        throw StateError('PaymentIntent read context mismatch');
    }
    PaymentGuard.distinct(page.receipts.map((r) => r.id));
    PaymentGuard.distinct(page.refunds.map((r) => r.id));
    for (final receipt in page.receipts) {
      PaymentGuard.scope(receipt.scopeFingerprint, scope);
      if (receipt.orderId != request.orderId ||
          receipt.intentId != request.intentId ||
          receipt.environment != request.environment ||
          !receipt.serverVerified ||
          !PaymentGuard.fresh(receipt.observedAt, receipt.expiresAt, now)) {
        throw StateError('Receipt read context mismatch');
      }
    }
    for (final refund in page.refunds) {
      PaymentGuard.scope(refund.scopeFingerprint, scope);
      if (refund.orderId != request.orderId ||
          refund.intentId != request.intentId ||
          refund.environment != request.environment ||
          !refund.serverVerified ||
          !PaymentGuard.fresh(refund.observedAt, refund.expiresAt, now)) {
        throw StateError('Refund read context mismatch');
      }
    }
    final catalog = page.currencyCatalog;
    if (catalog != null) {
      PaymentGuard.scope(catalog.scopeFingerprint, scope);
      if (!catalog.serverVerified ||
          !PaymentGuard.fresh(catalog.observedAt, catalog.expiresAt, now)) {
        throw StateError('Currency catalog read context mismatch');
      }
      for (final rule in catalog.rules) {
        PaymentGuard.record(rule.validate());
        if (!rule.serverVerified ||
            !PaymentGuard.fresh(rule.observedAt, rule.expiresAt, now)) {
          throw StateError(
            'Currency catalog contains stale or unverified rules',
          );
        }
      }
    }
    for (final method in page.methods)
      PaymentMethods.validate(
        method,
        scope: scope,
        customerId: request.customerId!,
        environment: request.environment,
        now: now,
      );
  }

  Future<PaymentReadPage> _fetch(PaymentReadRequest request) {
    if (_inflight >= policy.maximumInflight)
      throw const PaymentBackendException('readBusy', retryable: true);
    _inflight++;
    return Future<PaymentReadPage>.sync(() => provider.read(request)).then(
      (p) {
        _inflight--;
        return p;
      },
      onError: (Object e, StackTrace s) {
        _inflight--;
        Error.throwWithStackTrace(e, s);
      },
    );
  }

  Future<PaymentReadState?> load(
    PaymentReadRequest request, {
    required Future<void> Function(Duration) wait,
  }) async {
    if (_closed) throw StateError('Payment read controller closed');
    PaymentGuard.record(request.validate());
    PaymentGuard.scope(request.scopeFingerprint, scope);
    if (request.environment != environment ||
        request.createdAt.isAfter(clock()))
      throw StateError('Payment read environment or clock mismatch');
    final generation = ++_generation,
        fingerprint = PaymentRequests.readFingerprint(request);
    for (
      var attempt = 1;
      attempt <= retryPolicy.maximumReadAttempts;
      attempt++
    ) {
      if (_closed || generation != _generation) return null;
      _state = PaymentReadState(
        scopeFingerprint: request.scopeFingerprint,
        requestFingerprint: fingerprint,
        updatedAt: clock(),
        state: 'loading',
        generation: generation,
        attempt: attempt,
      );
      try {
        final page = await _fetch(
          request,
        ).timeout(Duration(seconds: policy.timeoutSeconds));
        if (_closed || generation != _generation) return null;
        validate(request, page, scope: scope, now: clock());
        if (clock().difference(page.observedAt).inSeconds >
            policy.maximumAgeSeconds)
          throw StateError('Payment read exceeds observation age policy');
        return _state = PaymentReadState(
          scopeFingerprint: request.scopeFingerprint,
          requestFingerprint: fingerprint,
          updatedAt: clock(),
          state: 'ready',
          generation: generation,
          attempt: attempt,
          page: page,
        );
      } catch (error) {
        if (_closed || generation != _generation) return null;
        final known = error is PaymentBackendException ? error : null,
            retry = known?.retryable ?? error is TimeoutException;
        if (retry && attempt < retryPolicy.maximumReadAttempts) {
          await wait(
            Duration(
              seconds:
                  (known?.retryAfterSeconds ??
                          retryPolicy.initialDelaySeconds * attempt)
                      .clamp(1, retryPolicy.maximumDelaySeconds),
            ),
          );
          continue;
        }
        final safe =
                known?.code ??
                (error is TimeoutException ? 'timeout' : 'invalidResponse'),
            code =
                {
                  'readBusy',
                  'rateLimited',
                  'authenticationRequired',
                  'backendUnavailable',
                  'timeout',
                  'invalidResponse',
                  'requestRejected',
                }.contains(safe)
                ? safe
                : 'readFailure';
        return _state = PaymentReadState(
          scopeFingerprint: request.scopeFingerprint,
          requestFingerprint: fingerprint,
          updatedAt: clock(),
          state: 'failed',
          generation: generation,
          attempt: attempt,
          failure: PaymentReadFailure(
            code: code,
            occurredAt: clock(),
            retryable: retry,
          ),
        );
      }
    }
    return null;
  }

  void cancel() {
    if (_closed) return;
    _generation++;
    final old = _state;
    if (old != null)
      _state = PaymentReadState(
        scopeFingerprint: old.scopeFingerprint,
        requestFingerprint: old.requestFingerprint,
        updatedAt: clock(),
        state: 'cancelled',
        generation: _generation,
      );
  }

  void close() {
    if (_closed) return;
    cancel();
    _closed = true;
  }
}

/// A read-only bounded collector. An incomplete result never represents a full
/// saved-method or refund history. Pages are discarded if their context changes.
class PaymentReadCollector {
  PaymentReadCollector(
    this.provider, {
    required this.scope,
    required this.environment,
    required this.clock,
    PaymentReadPolicy? policy,
  }) : policy = policy ?? PaymentReadPolicy() {
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    PaymentGuard.record(this.policy.validate());
  }
  final PaymentReadProvider provider;
  final String scope, environment;
  final DateTime Function() clock;
  final PaymentReadPolicy policy;
  bool _closed = false, _busy = false;
  int _generation = 0;
  int _inflight = 0;

  Future<PaymentReadCollection?> collect(PaymentReadRequest initial) async {
    if (_closed || _busy) throw StateError('Payment collector unavailable');
    PaymentGuard.record(initial.validate());
    PaymentGuard.scope(initial.scopeFingerprint, scope);
    if (initial.environment != environment || initial.cursor != null) {
      throw StateError('Begin payment collection with a matching first page');
    }
    if (_inflight >= policy.maximumInflight) {
      throw StateError('Payment collector has unresolved reads');
    }
    _busy = true;
    final generation = ++_generation;
    final requests = PaymentRequests(
      scope: scope,
      environment: environment,
      clock: clock,
    );
    final intents = <PaymentIntent>[];
    final methods = <PaymentMethodReference>[];
    final receipts = <PaymentReceipt>[];
    final refunds = <PaymentRefundReference>[];
    final seen = <String>{};
    final cursors = <String>{};
    final reasons = <String>[];
    PaymentCurrencyCatalog? catalog;
    DateTime? expiresAt;
    var request = initial, pages = 0, complete = false;
    try {
      while (pages < policy.maximumPages) {
        if (_closed || generation != _generation) return null;
        if (_inflight >= policy.maximumInflight) {
          throw StateError('Payment collector inflight limit reached');
        }
        _inflight++;
        final future =
            Future<PaymentReadPage>.sync(() => provider.read(request)).then(
              (page) {
                _inflight--;
                return page;
              },
              onError: (Object error, StackTrace trace) {
                _inflight--;
                Error.throwWithStackTrace(error, trace);
              },
            );
        final page = await future.timeout(
          Duration(seconds: policy.timeoutSeconds),
        );
        if (_closed || generation != _generation) return null;
        PaymentReadController.validate(
          request,
          page,
          scope: scope,
          now: clock(),
        );
        if (clock().difference(page.observedAt).inSeconds >
            policy.maximumAgeSeconds) {
          throw StateError('Payment collection contains stale observations');
        }
        pages++;
        if (expiresAt == null || page.expiresAt.isBefore(expiresAt)) {
          expiresAt = page.expiresAt;
        }
        final ids = [
          ...page.intents.map((i) => i.id),
          ...page.methods.map((m) => m.methodId),
          ...page.receipts.map((r) => r.id),
          ...page.refunds.map((r) => r.id),
        ];
        for (final id in ids) {
          if (!seen.add(id)) throw StateError('Payment pages repeat a record');
        }
        if (seen.length > policy.maximumRecords) {
          throw StateError('Payment collection exceeds record capacity');
        }
        intents.addAll(page.intents);
        methods.addAll(page.methods);
        receipts.addAll(page.receipts);
        refunds.addAll(page.refunds);
        if (page.currencyCatalog != null) {
          if (catalog != null)
            throw StateError('Payment catalog repeated across pages');
          catalog = page.currencyCatalog;
        }
        if (page.complete) {
          complete = true;
          break;
        }
        final cursor = page.cursor;
        if (cursor == null) {
          reasons.add('missingContinuation');
          break;
        }
        if (!cursors.add(cursor))
          throw StateError('Payment cursor loop detected');
        if (seen.length >= policy.maximumRecords) {
          reasons.add('recordLimitReached');
          break;
        }
        request = requests.next(initial, cursor);
      }
      if (!complete && reasons.isEmpty) reasons.add('pageLimitReached');
      final now = clock();
      if (expiresAt == null || !expiresAt.isAfter(now)) {
        throw StateError('Payment collection expired during pagination');
      }
      final result = PaymentReadCollection(
        scopeFingerprint: initial.scopeFingerprint,
        requestFingerprint: PaymentRequests.readFingerprint(initial),
        mode: initial.mode,
        environment: environment,
        collectedAt: now,
        expiresAt: expiresAt,
        intents: intents,
        methods: methods,
        receipts: receipts,
        refunds: refunds,
        currencyCatalog: catalog,
        pages: pages,
        complete: complete,
        reasonCodes: reasons,
      );
      PaymentGuard.record(result.validate());
      return result;
    } finally {
      _busy = false;
    }
  }

  void cancel() {
    _generation++;
  }

  void close() {
    _closed = true;
    cancel();
  }
}
