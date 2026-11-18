import '../trippl_payments_mobile.dart';

abstract interface class PaymentBackend implements PaymentReadProvider {
  Future<PaymentCheckoutEnvelope> allocate(PaymentCheckoutRequest request);
  Future<PaymentVerification> verify(PaymentVerificationRequest request);
  Future<PaymentVerification?> findAttempt(PaymentCheckoutRequest request);
}

abstract interface class PaymentJsonEndpoint {
  Future<PaymentJsonResponse> post(Uri uri, Map<String, Object?> body);
}

class PaymentJsonResponse {
  PaymentJsonResponse({
    required this.statusCode,
    required this.body,
    this.retryAfterSeconds,
  }) {
    if (statusCode < 100 ||
        statusCode > 599 ||
        retryAfterSeconds != null &&
            (retryAfterSeconds! < 0 || retryAfterSeconds! > 120))
      throw ArgumentError('Invalid payment endpoint metadata');
  }
  final int statusCode;
  final Object? body;
  final int? retryAfterSeconds;
  @override
  String toString() => 'PaymentJsonResponse(statusCode: $statusCode)';
}

class PaymentBackendGateway implements PaymentBackend {
  PaymentBackendGateway(
    this.endpoint, {
    required String baseUri,
    required this.scope,
    required this.environment,
    required this.clock,
  }) : baseUri = PaymentGuard.https(baseUri) {
    PaymentGuard.identity(scope);
    PaymentGuard.environment(environment);
    if (this.baseUri.hasQuery)
      throw ArgumentError(
        'Payment backend base URI cannot contain query parameters',
      );
  }
  final PaymentJsonEndpoint endpoint;
  final Uri baseUri;
  final String scope, environment;
  final DateTime Function() clock;
  bool _closed = false;
  int _inflight = 0;
  Uri _path(String suffix) {
    final prefix = baseUri.path.endsWith('/')
        ? baseUri.path
        : '${baseUri.path}/';
    return baseUri.replace(path: '$prefix$suffix');
  }

  void _context(String scopeFingerprint, String mode) {
    PaymentGuard.scope(scopeFingerprint, scope);
    if (mode != environment)
      throw StateError('Payment gateway environment mismatch');
  }

  Future<Object?> _post(
    String path,
    Map<String, Object?> body, {
    bool lookup = false,
  }) async {
    if (_closed) throw StateError('Payment gateway closed');
    if (_inflight >= 4)
      throw const PaymentBackendException('readBusy', retryable: true);
    PaymentGuard.noSensitiveKeys(body);
    _inflight++;
    try {
      final response = await endpoint.post(_path(path), body);
      if (_closed) throw const PaymentBackendException('gatewayClosed');
      if (lookup && response.statusCode == 404) return null;
      if (response.statusCode == 401 || response.statusCode == 403)
        throw const PaymentBackendException('authenticationRequired');
      if (response.statusCode == 429)
        throw PaymentBackendException(
          'rateLimited',
          retryable: true,
          retryAfterSeconds: response.retryAfterSeconds,
        );
      if (response.statusCode >= 500)
        throw const PaymentBackendException(
          'backendUnavailable',
          retryable: true,
        );
      if (response.statusCode != 200)
        throw const PaymentBackendException('requestRejected');
      return response.body;
    } finally {
      _inflight--;
    }
  }

  @override
  Future<PaymentCheckoutEnvelope> allocate(
    PaymentCheckoutRequest request,
  ) async {
    _context(request.scopeFingerprint, request.environment);
    final raw = await _post(
      'checkout/allocate',
      PaymentRequests.checkoutPayload(request),
    );
    return PaymentProviderAdapter.allocation(raw, now: clock());
  }

  @override
  Future<PaymentVerification> verify(PaymentVerificationRequest request) async {
    PaymentGuard.record(request.validate());
    _context(request.scopeFingerprint, request.environment);
    final raw = await _post('checkout/verify', {
      'requestFingerprint': PaymentRequests.verificationFingerprint(request),
      'orderId': request.orderId,
      'orderFingerprint': request.orderFingerprint,
      'intentId': request.intentId,
      'attemptId': request.attemptId,
      'environment': request.environment,
      'minimumRevision': request.minimumRevision,
    });
    return PaymentProviderAdapter.verification(raw, now: clock());
  }

  @override
  Future<PaymentVerification?> findAttempt(
    PaymentCheckoutRequest request,
  ) async {
    _context(request.scopeFingerprint, request.environment);
    final raw = await _post('checkout/lookup', {
      'checkoutFingerprint': PaymentRequests.checkoutFingerprint(request),
      'orderId': request.orderId,
      'orderFingerprint': request.orderFingerprint,
      'attemptId': request.attemptId,
      'idempotencyKey': request.idempotencyKey,
      'environment': request.environment,
    }, lookup: true);
    return raw == null
        ? null
        : PaymentProviderAdapter.verification(raw, now: clock());
  }

  @override
  Future<PaymentReadPage> read(PaymentReadRequest request) async {
    PaymentGuard.record(request.validate());
    _context(request.scopeFingerprint, request.environment);
    final raw = await _post('payments/read', {
      'requestFingerprint': PaymentRequests.readFingerprint(request),
      'mode': request.mode,
      'environment': request.environment,
      'limit': request.limit,
      if (request.orderId != null) 'orderId': request.orderId,
      if (request.intentId != null) 'intentId': request.intentId,
      if (request.customerId != null) 'customerId': request.customerId,
      if (request.cursor != null) 'cursor': request.cursor,
    });
    final page = PaymentProviderAdapter.page(raw, now: clock());
    PaymentReadController.validate(request, page, scope: scope, now: clock());
    return page;
  }

  void close() {
    _closed = true;
  }
}
