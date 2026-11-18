import '../trippl_payments_mobile.dart';

class PaymentProviderAdapter {
  static PaymentCheckoutEnvelope allocation(
    Object? input, {
    required DateTime now,
  }) {
    final raw = PaymentGuard.object(input);
    PaymentCodec.keys(raw, {'allocation', 'sdkCredentials'});
    final allocation = PaymentAllocation.fromJson(
      PaymentGuard.object(raw['allocation']),
    );
    if (!PaymentGuard.fresh(allocation.observedAt, allocation.expiresAt, now))
      throw StateError('Payment allocation observation expired');
    final transient = PaymentGuard.object(raw['sdkCredentials']);
    PaymentCodec.keys(transient, {'clientSecret', 'ephemeralKey'});
    final clientSecret = transient['clientSecret'],
        ephemeral = transient['ephemeralKey'];
    if (clientSecret is! String || ephemeral != null && ephemeral is! String)
      throw const FormatException('Malformed transient SDK credentials');
    final credentials = PaymentSdkCredentials(
      reference: allocation.credentials,
      clientSecret: clientSecret,
      ephemeralKey: ephemeral as String?,
    );
    return PaymentCheckoutEnvelope(
      allocation: allocation,
      credentials: credentials,
    );
  }

  static PaymentVerification verification(
    Object? input, {
    required DateTime now,
  }) {
    final raw = PaymentGuard.object(input);
    PaymentGuard.noSensitiveKeys(raw);
    final result = PaymentVerification.fromJson(raw);
    if (result.observedAt.isAfter(now))
      throw StateError('Payment verification timestamp is in future');
    return result;
  }

  static PaymentReadPage page(Object? input, {required DateTime now}) {
    final raw = PaymentGuard.object(input);
    PaymentGuard.noSensitiveKeys(raw);
    final page = PaymentReadPage.fromJson(raw);
    if (page.observedAt.isAfter(now))
      throw StateError('Payment read timestamp is in future');
    return page;
  }

  static PaymentMethodReference method(Object? input, {required DateTime now}) {
    final raw = PaymentGuard.object(input);
    PaymentGuard.noSensitiveKeys(raw);
    final method = PaymentMethodReference.fromJson(raw);
    PaymentGuard.objectId(method.methodId, 'pm');
    PaymentGuard.objectId(method.customerId, 'cus');
    if (method.observedAt.isAfter(now))
      throw StateError('Payment method timestamp is in future');
    return method;
  }
}
