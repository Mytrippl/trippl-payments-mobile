import '../trippl_payments_mobile.dart';

class PaymentRequests {
  PaymentRequests({
    required this.scope,
    required this.environment,
    required this.clock,
  }) {
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
  }
  final String scope, environment;
  final DateTime Function() clock;
  int _sequence = 0;
  String _id() => 'payment-${clock().microsecondsSinceEpoch}-${++_sequence}';
  static String checkoutFingerprint(PaymentCheckoutRequest request) {
    PaymentGuard.record(request.validate());
    PaymentGuard.noSensitiveKeys(request.toJson());
    final json = request.toJson()
      ..remove('id')
      ..remove('createdAt');
    return PaymentCodec.digest(json);
  }

  static String verificationFingerprint(PaymentVerificationRequest request) {
    PaymentGuard.record(request.validate());
    final json = request.toJson()
      ..remove('id')
      ..remove('createdAt');
    return PaymentCodec.digest(json);
  }

  static String readFingerprint(PaymentReadRequest request) {
    PaymentGuard.record(request.validate());
    final json = request.toJson()
      ..remove('id')
      ..remove('createdAt')
      ..remove('cursor');
    return PaymentCodec.digest(json);
  }

  PaymentCheckoutRequest checkout(
    PaymentOrder order,
    PaymentQuote quote,
    PaymentAttempt attempt, {
    PaymentMethodSelection? method,
  }) {
    PaymentOrders.validate(order, scope: scope, now: clock());
    PaymentGuard.record(quote.validate());
    PaymentGuard.record(attempt.validate());
    PaymentGuard.scope(attempt.scopeFingerprint, scope);
    if (attempt.orderId != order.id ||
        attempt.orderFingerprint != PaymentOrders.fingerprint(order) ||
        attempt.quoteId != quote.id ||
        attempt.environment != environment ||
        attempt.createdAt.isAfter(clock()))
      throw StateError(
        'Checkout attempt does not match order quote or environment',
      );
    if (method != null) {
      PaymentGuard.record(method.validate());
      PaymentGuard.scope(method.scopeFingerprint, scope);
      if (method.environment != environment ||
          method.customerId != order.customerReference)
        throw StateError('Checkout method customer or environment mismatch');
    }
    final request = PaymentCheckoutRequest(
      id: _id(),
      scopeFingerprint: PaymentCodec.digest(scope),
      orderId: order.id,
      orderRevision: order.revision,
      orderFingerprint: PaymentOrders.fingerprint(order),
      quoteId: quote.id,
      total: quote.total,
      attemptId: attempt.id,
      idempotencyKey: attempt.idempotencyKey,
      environment: environment,
      createdAt: clock(),
      customerId: order.customerReference,
      methodId: method?.methodId,
    );
    PaymentGuard.record(request.validate());
    return request;
  }

  PaymentVerificationRequest verification(
    PaymentOrder order,
    PaymentAttempt attempt,
    String intentId,
  ) {
    PaymentOrders.validate(order, scope: scope, now: clock());
    PaymentGuard.record(attempt.validate());
    PaymentGuard.objectId(intentId, 'pi');
    PaymentGuard.scope(attempt.scopeFingerprint, scope);
    if (attempt.orderId != order.id ||
        attempt.orderFingerprint != PaymentOrders.fingerprint(order) ||
        attempt.environment != environment)
      throw StateError('Payment verification attempt context mismatch');
    return PaymentVerificationRequest(
      id: _id(),
      scopeFingerprint: PaymentCodec.digest(scope),
      orderId: order.id,
      orderFingerprint: PaymentOrders.fingerprint(order),
      intentId: intentId,
      attemptId: attempt.id,
      expectedTotal: order.total,
      environment: environment,
      createdAt: clock(),
    );
  }

  PaymentReadRequest read(
    String mode, {
    String? orderId,
    String? intentId,
    String? customerId,
    int limit = 20,
  }) {
    final request = PaymentReadRequest(
      id: _id(),
      scopeFingerprint: PaymentCodec.digest(scope),
      mode: mode,
      environment: environment,
      createdAt: clock(),
      orderId: orderId,
      intentId: intentId,
      customerId: customerId,
      limit: limit,
    );
    PaymentGuard.record(request.validate());
    if (mode == 'intent' && (intentId == null || orderId == null) ||
        mode == 'methods' && customerId == null ||
        {'refunds', 'receipt'}.contains(mode) &&
            (intentId == null || orderId == null))
      throw StateError('Payment read identity context missing');
    if (intentId != null) PaymentGuard.objectId(intentId, 'pi');
    if (customerId != null) PaymentGuard.objectId(customerId, 'cus');
    return request;
  }

  PaymentReadRequest next(PaymentReadRequest request, String cursor) {
    PaymentGuard.record(request.validate());
    PaymentGuard.scope(request.scopeFingerprint, scope);
    if (cursor.isEmpty ||
        cursor.length > 200 ||
        request.environment != environment)
      throw StateError('Payment cursor context invalid');
    return request.copyWith(id: _id(), createdAt: clock(), cursor: cursor);
  }

  static Map<String, Object?> checkoutPayload(PaymentCheckoutRequest request) {
    PaymentGuard.record(request.validate());
    return Map.unmodifiable({
      'requestFingerprint': checkoutFingerprint(request),
      'orderId': request.orderId,
      'orderRevision': request.orderRevision,
      'orderFingerprint': request.orderFingerprint,
      'quoteId': request.quoteId,
      'attemptId': request.attemptId,
      'idempotencyKey': request.idempotencyKey,
      'environment': request.environment,
      if (request.customerId != null) 'customerId': request.customerId,
      if (request.methodId != null) 'methodId': request.methodId,
    });
  }
}
