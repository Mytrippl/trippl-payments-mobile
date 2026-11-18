import '../trippl_payments_mobile.dart';

class PaymentReturns {
  static Uri validate(String text, PaymentReturnPolicy policy) {
    PaymentGuard.record(policy.validate());
    if (text.length > 8000)
      throw const FormatException('Payment return URI exceeds capacity');
    final uri = Uri.tryParse(text);
    if (uri != null) PaymentGuard.noSensitiveKeys(uri.queryParameters);
    if (uri == null ||
        !policy.allowedSchemes.contains(uri.scheme) ||
        !policy.allowedHosts.contains(uri.host) ||
        !policy.allowedPaths.contains(uri.path) ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment ||
        uri.scheme == 'https' && uri.port != 443 ||
        uri.queryParametersAll.values.any((v) => v.length != 1) ||
        uri.queryParameters.keys.any(
          (k) => !policy.allowedQueryKeys.contains(k),
        ))
      throw StateError(
        'Payment return URI destination or parameters not permitted',
      );
    return uri;
  }

  static PaymentReturnSignal decode(
    String text,
    PaymentReturnPolicy policy, {
    required DateTime now,
    required String expectedState,
    String? expectedIntentId,
  }) {
    PaymentGuard.identity(expectedState);
    final uri = validate(text, policy), state = uri.queryParameters['state'];
    if (policy.requireState && (state == null || state != expectedState))
      throw StateError('Payment return state mismatch');
    final intentId = uri.queryParameters['payment_intent'];
    if (intentId != null) {
      PaymentGuard.objectId(intentId, 'pi');
      if (expectedIntentId != null && intentId != expectedIntentId)
        throw StateError('Payment return intent mismatch');
    }
    final marker =
        uri.queryParameters['status'] ?? uri.queryParameters['redirect_status'];
    final kind =
        marker == 'success' ||
            marker == 'succeeded' ||
            uri.path.endsWith('/stripe-payment-success')
        ? 'successMarker'
        : marker == 'cancel' ||
              marker == 'canceled' ||
              uri.path.endsWith('/stripe-payment-cancel')
        ? 'cancelMarker'
        : 'unknown';
    return PaymentReturnSignal(
      receivedAt: now,
      kind: kind,
      intentId: intentId,
      stateFingerprint: state == null ? null : PaymentCodec.digest(state),
      needsVerification: true,
      paymentConfirmed: false,
      reasonCodes: ['returnNavigationIsNotPaymentProof'],
    );
  }

  static String build(
    String base,
    PaymentReturnPolicy policy, {
    required String state,
  }) {
    PaymentGuard.identity(state);
    final uri = validate(base, policy);
    if (!policy.allowedQueryKeys.contains('state'))
      throw StateError('Payment return policy does not permit state binding');
    final result = uri.replace(
      queryParameters: {...uri.queryParameters, 'state': state},
    );
    validate(result.toString(), policy);
    return result.toString();
  }
}
