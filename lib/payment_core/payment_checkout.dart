import 'dart:async';
import '../trippl_payments_mobile.dart';

class PaymentCheckoutController {
  PaymentCheckoutController(
    this.backend,
    this.sdk, {
    required this.scope,
    required this.environment,
    required this.configuration,
    required this.sdkEnvironment,
    required this.clock,
    required this.coordinator,
    this.pendingStore,
    PaymentReadPolicy? readPolicy,
    String Function()? nonce,
  }) : readPolicy = readPolicy ?? PaymentReadPolicy(),
       _nonce = nonce ?? PaymentAttempts.token,
       _requests = PaymentRequests(
         scope: scope,
         environment: environment,
         clock: clock,
       ) {
    PaymentGuard.environment(environment);
    PaymentGuard.record(this.readPolicy.validate());
    PaymentConfiguration.validate(configuration, sdkEnvironment, now: clock());
    if (environment != configuration.environment ||
        sdk.scope != scope ||
        pendingStore != null &&
            (pendingStore!.scope != scope ||
                pendingStore!.environment != environment))
      throw StateError(
        'Checkout dependencies belong to different accounts or environments',
      );
  }
  final PaymentBackend backend;
  final PaymentSdkAdapter sdk;
  final String scope, environment;
  final PaymentSdkConfiguration configuration;
  final PaymentEnvironment sdkEnvironment;
  final DateTime Function() clock;
  final PaymentAttemptCoordinator coordinator;
  final PaymentPendingStore? pendingStore;
  final PaymentReadPolicy readPolicy;
  final String Function() _nonce;
  final PaymentRequests _requests;
  final _changes = StreamController<PaymentCheckoutState>.broadcast();
  PaymentCheckoutState? _state;
  PaymentOrder? _order;
  PaymentQuote? _quote;
  PaymentCurrencyRule? _currency;
  PaymentAttempt? _attempt;
  PaymentCheckoutRequest? _request;
  PaymentCheckoutEnvelope? _envelope;
  PaymentVerification? _verification;
  PaymentIntentAssessment? _assessment;
  bool _closed = false, _busy = false;
  int _generation = 0;
  final List<PaymentAuditEvent> _audit = [];
  PaymentCheckoutState? get state => _state;
  Stream<PaymentCheckoutState> get changes => _changes.stream;
  List<PaymentAuditEvent> get audit => List.unmodifiable(_audit);
  void _open() {
    if (_closed) throw StateError('Checkout controller closed');
    if (_busy) throw StateError('Checkout operation already active');
  }

  void _emit(String state, {bool busy = false, PaymentError? error}) {
    if (_closed) return;
    final order = _order ?? (throw StateError('Checkout order missing'));
    final value = PaymentCheckoutState(
      scopeFingerprint: PaymentCodec.digest(scope),
      orderId: order.id,
      updatedAt: clock(),
      state: state,
      attempt: _attempt,
      allocation: _envelope?.allocation,
      verification: _verification,
      error: error,
      busy: busy,
      revision: (_state?.revision ?? 0) + 1,
    );
    PaymentGuard.record(value.validate());
    _state = value;
    _changes.add(value);
    _audit.add(
      PaymentAuditEvent(
        id: PaymentCodec.digest({
          'order': order.id,
          'revision': value.revision,
        }),
        scopeFingerprint: value.scopeFingerprint,
        orderId: order.id,
        operation: 'checkout',
        occurredAt: clock(),
        state: state,
        attemptId: _attempt?.id,
        revision: value.revision,
      ),
    );
    if (_audit.length > 100) _audit.removeAt(0);
  }

  void _remember(
    String state, {
    String? intentId,
    PaymentIntentAssessment? assessment,
  }) {
    _attempt = PaymentAttempts.transition(
      _attempt!,
      state,
      now: clock(),
      intentId: intentId,
      assessment: assessment,
    );
    coordinator.remember(_attempt!, scope: scope);
  }

  void _validateAllocation(PaymentCheckoutEnvelope envelope) {
    final a = envelope.allocation, r = _request!, order = _order!;
    PaymentGuard.record(a.validate());
    PaymentGuard.scope(a.scopeFingerprint, scope);
    PaymentGuard.scope(a.credentials.scopeFingerprint, scope);
    if (!a.serverVerified ||
        a.requestFingerprint != PaymentRequests.checkoutFingerprint(r) ||
        a.orderId != order.id ||
        a.quoteId != r.quoteId ||
        a.total != order.total ||
        a.environment != environment ||
        a.credentials.intentId != a.intentId ||
        a.credentials.orderId != order.id ||
        a.credentials.environment != environment ||
        a.credentials.customerId != r.customerId ||
        envelope.credentials.reference != a.credentials ||
        !PaymentGuard.fresh(a.observedAt, a.expiresAt, clock()) ||
        !PaymentGuard.fresh(
          a.credentials.createdAt,
          a.credentials.expiresAt,
          clock(),
        ))
      throw StateError(
        'Backend checkout allocation does not match the current order request',
      );
    if (_attempt!.intentId != null && _attempt!.intentId != a.intentId)
      throw StateError(
        'Existing attempt cannot allocate a different payment intent',
      );
    PaymentGuard.objectId(a.intentId, 'pi');
  }

  Future<PaymentAllocation?> prepare(
    PaymentOrder order,
    PaymentQuote quote,
    PaymentCurrencyRule currency, {
    PaymentMethodSelection? method,
  }) async {
    _open();
    PaymentQuotes.validate(quote, order, currency, scope: scope, now: clock());
    if (_attempt != null ||
        coordinator.current(scope, order.id, environment) != null)
      throw StateError(
        'Recover or resolve the existing checkout attempt before preparing another',
      );
    final created = PaymentAttempts.create(
      order,
      quote,
      scope: scope,
      environment: environment,
      now: clock(),
      nonce: _nonce(),
    );
    final request = _requests.checkout(order, quote, created, method: method);
    final lease = coordinator.acquire(scope, order.id, environment),
        generation = ++_generation;
    _busy = true;
    _order = order;
    _quote = quote;
    _currency = currency;
    var callStarted = false, finished = false, accepted = false;
    try {
      _attempt = created;
      _request = request;
      coordinator.remember(_attempt!, scope: scope);
      _remember('allocating');
      _emit('preparing', busy: true);
      if (pendingStore != null) await pendingStore!.save(_request!);
      if (_closed || generation != _generation) return null;
      callStarted = true;
      final future = backend.allocate(_request!).then((envelope) {
        if (_closed || generation != _generation || finished && !accepted)
          envelope.dispose();
        return envelope;
      });
      final envelope = await future.timeout(
        Duration(seconds: readPolicy.timeoutSeconds),
      );
      if (_closed || generation != _generation) {
        envelope.dispose();
        return null;
      }
      try {
        _validateAllocation(envelope);
      } catch (_) {
        envelope.dispose();
        rethrow;
      }
      accepted = true;
      _envelope = envelope;
      _remember('allocated', intentId: envelope.allocation.intentId);
      _emit('ready');
      return envelope.allocation;
    } catch (_) {
      if (!_closed && generation == _generation) {
        _remember(callStarted ? 'uncertain' : 'failed');
        _emit(
          callStarted ? 'uncertain' : 'failed',
          error: PaymentErrors.fromCode(
            'unknown',
            now: clock(),
            mutationStarted: callStarted,
          ),
        );
      }
      rethrow;
    } finally {
      finished = true;
      _busy = false;
      coordinator.release(lease);
    }
  }

  Future<PaymentCheckoutResult?> present() async {
    _open();
    final order = _order ?? (throw StateError('Prepare checkout first')),
        envelope =
            _envelope ?? (throw StateError('Current SDK allocation missing'));
    if (_state?.state != 'ready')
      throw StateError('Checkout is not ready for native presentation');
    PaymentQuotes.validate(
      _quote!,
      order,
      _currency!,
      scope: scope,
      now: clock(),
    );
    final lease = coordinator.acquire(scope, order.id, environment),
        generation = ++_generation;
    _busy = true;
    _remember('presenting');
    _emit('presenting', busy: true);
    PaymentSdkOutcome outcome;
    try {
      try {
        outcome = await sdk.present(envelope, configuration, sdkEnvironment);
      } catch (_) {
        outcome = const PaymentSdkOutcome('failed', errorCode: 'unknown');
      }
      _envelope = null;
      if (_closed || generation != _generation) return null;
      _remember('verifying');
      _emit(
        'verifying',
        busy: true,
        error: outcome.state == 'cancelled'
            ? PaymentErrors.fromCode(
                'cancelled',
                now: clock(),
                mutationStarted: true,
              )
            : null,
      );
      return await _verify(
        generation,
        sdkCompleted: outcome.state == 'completed',
      );
    } finally {
      _busy = false;
      coordinator.release(lease);
    }
  }

  Future<PaymentCheckoutResult?> _verify(
    int generation, {
    bool sdkCompleted = false,
    PaymentVerification? supplied,
  }) async {
    final order = _order!,
        attempt = _attempt!,
        intentId = supplied?.intent.id ?? attempt.intentId;
    if (intentId == null)
      throw StateError(
        'Resolve the server attempt before verifying a payment intent',
      );
    final request = _requests
        .verification(order, attempt, intentId)
        .copyWith(minimumRevision: _verification?.intent.revision ?? 1);
    try {
      final verification =
          supplied ??
          await backend
              .verify(request)
              .timeout(Duration(seconds: readPolicy.timeoutSeconds));
      if (_closed || generation != _generation) return null;
      final assessment = PaymentVerifications.validate(
        verification,
        request,
        order,
        scope: scope,
        now: clock(),
      );
      if (_assessment?.paid == true && !assessment.paid) {
        throw StateError('Paid payment status cannot regress');
      }
      _verification = verification;
      _assessment = assessment;
      if (_attempt!.intentId == null)
        _remember('verifying', intentId: intentId);
      final state = assessment.paid
          ? 'paid'
          : assessment.state == 'cancelled'
          ? 'cancelled'
          : assessment.authorized
          ? 'authorized'
          : {
              'pending',
              'authenticationRequired',
              'confirmationRequired',
              'methodRequired',
            }.contains(assessment.state)
          ? 'pending'
          : 'uncertain';
      _remember(
        assessment.paid
            ? 'completed'
            : state == 'cancelled'
            ? 'cancelled'
            : state == 'uncertain'
            ? 'uncertain'
            : 'pending',
        assessment: assessment,
      );
      _emit(state);
      return PaymentCheckoutResult(
        orderId: order.id,
        attemptId: attempt.id,
        intentId: intentId,
        evaluatedAt: clock(),
        state: state,
        sdkCompleted: sdkCompleted,
        serverVerified: true,
        paid: assessment.paid,
        bookingConfirmed: assessment.bookingConfirmed,
        reasonCodes: assessment.reasonCodes,
      );
    } catch (_) {
      if (!_closed && generation == _generation) {
        _remember('uncertain');
        _emit(
          'uncertain',
          error: PaymentErrors.fromCode(
            'unknown',
            now: clock(),
            mutationStarted: true,
          ),
        );
      }
      rethrow;
    }
  }

  Future<PaymentCheckoutResult?> refresh() async {
    _open();
    final order = _order ?? (throw StateError('Checkout order missing'));
    if (_attempt == null) throw StateError('Checkout attempt missing');
    final lease = coordinator.acquire(scope, order.id, environment),
        generation = ++_generation;
    _busy = true;
    try {
      _emit('verifying', busy: true);
      return await _verify(generation);
    } finally {
      _busy = false;
      coordinator.release(lease);
    }
  }

  Future<PaymentCheckoutResult?> recover(PaymentOrder order) async {
    _open();
    PaymentOrders.validate(order, scope: scope, now: clock());
    final lease = coordinator.acquire(scope, order.id, environment),
        generation = ++_generation;
    _busy = true;
    try {
      final request = _request ?? await pendingStore?.load(order.id);
      if (_closed || generation != _generation) return null;
      if (request == null)
        throw StateError(
          'No local pending reference; ask the backend to resolve this order before a new charge',
        );
      PaymentGuard.scope(request.scopeFingerprint, scope);
      if (request.orderId != order.id ||
          request.orderFingerprint != PaymentOrders.fingerprint(order) ||
          request.total != order.total ||
          request.environment != environment)
        throw StateError('Pending checkout does not match the current order');
      _order = order;
      _request = request;
      _attempt ??= PaymentAttempt(
        id: request.attemptId,
        scopeFingerprint: request.scopeFingerprint,
        orderId: request.orderId,
        orderFingerprint: request.orderFingerprint,
        quoteId: request.quoteId,
        idempotencyKey: request.idempotencyKey,
        environment: environment,
        createdAt: request.createdAt,
        updatedAt: clock(),
        state: 'uncertain',
      );
      coordinator.remember(_attempt!, scope: scope);
      _emit('verifying', busy: true);
      final verification = await backend
          .findAttempt(request)
          .timeout(Duration(seconds: readPolicy.timeoutSeconds));
      if (_closed || generation != _generation) return null;
      if (verification == null) {
        _emit('uncertain');
        return PaymentCheckoutResult(
          orderId: order.id,
          attemptId: request.attemptId,
          evaluatedAt: clock(),
          state: 'uncertain',
          reasonCodes: ['backendAttemptResolutionRequired'],
        );
      }
      return await _verify(generation, supplied: verification);
    } catch (_) {
      if (!_closed &&
          generation == _generation &&
          _attempt != null &&
          _order != null) {
        _remember('uncertain');
        _emit('uncertain');
      }
      rethrow;
    } finally {
      _busy = false;
      coordinator.release(lease);
    }
  }

  Future<PaymentAllocation?> renew() async {
    _open();
    final order = _order ?? (throw StateError('Checkout order missing'));
    if (_verification == null ||
        _assessment?.serverVerified != true ||
        !{
          'requires_payment_method',
          'requires_action',
          'requires_confirmation',
        }.contains(PaymentStatuses.normalize(_verification!.intent.status)) ||
        _request == null ||
        _quote == null ||
        _currency == null)
      throw StateError(
        'Renew only a current verified retryable intent using its existing attempt',
      );
    PaymentQuotes.validate(
      _quote!,
      order,
      _currency!,
      scope: scope,
      now: clock(),
    );
    if (!PaymentGuard.fresh(
      _verification!.observedAt,
      _verification!.expiresAt,
      clock(),
    ))
      throw StateError(
        'Refresh the backend payment status before renewing SDK credentials',
      );
    final lease = coordinator.acquire(scope, order.id, environment),
        generation = ++_generation;
    _busy = true;
    var finished = false, accepted = false;
    try {
      _emit('preparing', busy: true);
      final future = backend.allocate(_request!).then((envelope) {
        if (_closed || generation != _generation || finished && !accepted)
          envelope.dispose();
        return envelope;
      });
      final envelope = await future.timeout(
        Duration(seconds: readPolicy.timeoutSeconds),
      );
      if (_closed || generation != _generation) {
        envelope.dispose();
        return null;
      }
      try {
        _validateAllocation(envelope);
      } catch (_) {
        envelope.dispose();
        rethrow;
      }
      _envelope?.dispose();
      _envelope = envelope;
      accepted = true;
      _remember('allocated', intentId: envelope.allocation.intentId);
      _emit('ready');
      return envelope.allocation;
    } catch (_) {
      if (!_closed && generation == _generation) {
        _remember('uncertain');
        _emit('uncertain');
      }
      rethrow;
    } finally {
      finished = true;
      _busy = false;
      coordinator.release(lease);
    }
  }

  Future<void> resetCancelled() async {
    _open();
    final attempt = _attempt ?? (throw StateError('No checkout attempt')),
        assessment =
            _assessment ??
            (throw StateError('Refresh backend cancellation first'));
    if (_state?.state != 'cancelled' ||
        _verification == null ||
        !PaymentGuard.fresh(
          _verification!.observedAt,
          _verification!.expiresAt,
          clock(),
        ))
      throw StateError('Current backend cancellation required');
    final lease = coordinator.acquire(scope, attempt.orderId, environment);
    _busy = true;
    try {
      if (pendingStore != null)
        await pendingStore!.clearCancelled(_request!, assessment);
      coordinator.clearCancelled(attempt, assessment, scope: scope);
      _envelope?.dispose();
      _envelope = null;
      _attempt = null;
      _request = null;
      _verification = null;
      _assessment = null;
      _emit('idle');
    } finally {
      _busy = false;
      coordinator.release(lease);
    }
  }

  PaymentCheckoutSnapshot snapshot() {
    if (_order == null) throw StateError('No checkout order');
    return PaymentCheckoutSnapshot(
      scopeFingerprint: PaymentCodec.digest(scope),
      orderId: _order!.id,
      orderFingerprint: PaymentOrders.fingerprint(_order!),
      updatedAt: clock(),
      state: _state?.state ?? 'idle',
      intentId: _attempt?.intentId,
      attemptId: _attempt?.id,
      offline: true,
      needsVerification: true,
    );
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _generation++;
    _envelope?.dispose();
    _envelope = null;
    await _changes.close();
  }
}
