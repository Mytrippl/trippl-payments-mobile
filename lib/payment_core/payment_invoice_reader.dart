import '../trippl_payments_mobile.dart';

abstract interface class PaymentInvoiceProvider {
  Future<PaymentInvoicePage> invoices(
    PaymentInvoiceFilter filter, {
    String? cursor,
  });
}

class PaymentInvoiceReader {
  PaymentInvoiceReader(
    this.provider, {
    required this.scope,
    required this.environment,
    required this.clock,
    PaymentReadPolicy? policy,
  }) : policy = policy ?? PaymentReadPolicy() {
    PaymentGuard.record(this.policy.validate());
  }
  final PaymentInvoiceProvider provider;
  final String scope, environment;
  final DateTime Function() clock;
  final PaymentReadPolicy policy;
  int _generation = 0, _inflight = 0;
  bool _closed = false, _busy = false;
  static String fingerprint(PaymentInvoiceFilter filter) =>
      PaymentAccountGuard.fingerprint(filter.toJson());
  Future<List<PaymentInvoice>?> load(
    PaymentInvoiceFilter filter, {
    required bool requireComplete,
  }) async {
    if (_closed || _busy || _inflight >= policy.maximumInflight)
      throw StateError('Invoice reader unavailable');
    PaymentGuard.record(filter.validate());
    final generation = ++_generation,
        requestFingerprint = fingerprint(filter),
        seen = <String>{},
        cursors = <String>{},
        result = <PaymentInvoice>[];
    String? cursor;
    var complete = false;
    _busy = true;
    try {
      for (var p = 0; p < policy.maximumPages; p++) {
        if (_closed || generation != _generation) return null;
        _inflight++;
        final future =
            Future<PaymentInvoicePage>.sync(
              () => provider.invoices(filter, cursor: cursor),
            ).then(
              (p) {
                _inflight--;
                return p;
              },
              onError: (Object e, StackTrace s) {
                _inflight--;
                Error.throwWithStackTrace(e, s);
              },
            );
        final page = await future.timeout(
          Duration(seconds: policy.timeoutSeconds),
        );
        if (_closed || generation != _generation) return null;
        PaymentGuard.record(page.validate());
        PaymentAccountGuard.context(
          page.scopeFingerprint,
          page.environment,
          scope: scope,
          environment: environment,
        );
        PaymentAccountGuard.current(
          page.observedAt,
          page.expiresAt,
          page.serverVerified,
          clock(),
        );
        if (page.requestFingerprint != requestFingerprint ||
            page.invoices.length > filter.limit ||
            clock().difference(page.observedAt).inSeconds >
                policy.maximumAgeSeconds)
          throw StateError('Invoice page request mismatch');
        for (final invoice in page.invoices) {
          PaymentInvoices.validate(
            invoice,
            scope: scope,
            environment: environment,
            customerId: filter.customerId,
            now: clock(),
          );
          if (PaymentInvoices.filter([invoice], filter, now: clock()).isEmpty)
            throw StateError('Invoice is outside requested filter');
          if (!seen.add(invoice.id))
            throw StateError('Invoice appears on multiple pages');
          result.add(invoice);
        }
        if (result.length > policy.maximumRecords)
          throw StateError('Invoice history exceeds capacity');
        if (page.complete) {
          complete = true;
          break;
        }
        cursor = page.cursor;
        if (cursor == null) break;
        if (cursor.isEmpty || cursor.length > 200 || !cursors.add(cursor))
          throw StateError('Invoice continuation loop or invalid cursor');
      }
      if (requireComplete && !complete)
        throw StateError('Complete invoice history required');
      for (final invoice in result) {
        PaymentInvoices.validate(
          invoice,
          scope: scope,
          environment: environment,
          customerId: filter.customerId,
          now: clock(),
        );
      }
      result.sort((a, b) {
        final date = b.issuedAt.compareTo(a.issuedAt);
        return date != 0 ? date : a.id.compareTo(b.id);
      });
      return List.unmodifiable(result);
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
