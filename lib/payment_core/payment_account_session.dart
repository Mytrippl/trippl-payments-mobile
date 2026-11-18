import '../trippl_payments_mobile.dart';

class PaymentAccountSession {
  PaymentAccountSession({
    required this.scope,
    required this.environment,
    required this.clock,
  });
  final String scope, environment;
  final DateTime Function() clock;
  PaymentSessionContext? _context;
  int _generation = 0;
  bool _closed = false;
  PaymentSessionContext begin(
    String customerId,
    List<String> permissions, {
    required DateTime expiresAt,
  }) {
    if (_closed) throw StateError('Payment account session closed');
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    PaymentGuard.objectId(customerId, 'cus');
    PaymentGuard.distinct(permissions);
    final now = clock();
    if (!expiresAt.isAfter(now) ||
        expiresAt.difference(now) > const Duration(hours: 24))
      throw StateError('Payment account session expiry invalid');
    final next = PaymentSessionContext(
      id: 'session-${PaymentCodec.digest({'scope': scope, 'customer': customerId, 'generation': ++_generation, 'time': now.toUtc().toIso8601String()})}',
      scopeFingerprint: PaymentCodec.digest(scope),
      environment: environment,
      customerId: customerId,
      authenticatedAt: now,
      expiresAt: expiresAt,
      generation: _generation,
      permissions: permissions,
    );
    PaymentGuard.record(next.validate());
    return _context = next;
  }

  PaymentSessionContext current() {
    final context = _context;
    if (_closed ||
        context == null ||
        !context.active ||
        !PaymentGuard.fresh(
          context.authenticatedAt,
          context.expiresAt,
          clock(),
        ))
      throw StateError('Authenticate the payment account again');
    return context;
  }

  bool isCurrent(PaymentSessionContext captured) {
    try {
      final now = current();
      return now.id == captured.id && now.generation == captured.generation;
    } on StateError {
      return false;
    }
  }

  void invalidate() {
    _generation++;
    _context = null;
  }

  void close() {
    if (_closed) return;
    invalidate();
    _closed = true;
  }
}
