import '../trippl_payments_mobile.dart';

/// In-memory SDK credentials deliberately have no JSON serialization API.
class PaymentSdkCredentials {
  PaymentSdkCredentials({
    required this.reference,
    required String clientSecret,
    String? ephemeralKey,
  }) : _clientSecret = clientSecret,
       _ephemeralKey = ephemeralKey {
    PaymentGuard.record(reference.validate());
    PaymentGuard.objectId(reference.intentId, 'pi');
    if (!clientSecret.startsWith('${reference.intentId}_secret_') ||
        clientSecret.length > 500 ||
        clientSecret.length <= reference.intentId.length + 8 ||
        RegExp(r'\s').hasMatch(clientSecret))
      throw const FormatException('Invalid transient payment client secret');
    if (reference.customerId != null &&
        (ephemeralKey == null ||
            !ephemeralKey.startsWith('ek_') ||
            ephemeralKey.length > 500))
      throw const FormatException(
        'Customer session requires transient ephemeral credentials',
      );
    if (reference.customerId == null && ephemeralKey != null)
      throw const FormatException(
        'Ephemeral credentials lack customer binding',
      );
  }
  final PaymentCredentialsReference reference;
  String? _clientSecret, _ephemeralKey;
  bool _busy = false, _used = false;
  bool get disposed => _clientSecret == null;
  Future<T> use<T>(
    Future<T> Function(String, String?) action, {
    required String scope,
    required DateTime now,
  }) async {
    PaymentGuard.scope(reference.scopeFingerprint, scope);
    if (disposed ||
        _busy ||
        reference.singleUse && _used ||
        !PaymentGuard.fresh(reference.createdAt, reference.expiresAt, now))
      throw StateError('SDK credentials unavailable expired or already in use');
    _busy = true;
    _used = true;
    try {
      return await action(_clientSecret!, _ephemeralKey);
    } finally {
      _busy = false;
      dispose();
    }
  }

  void dispose() {
    _clientSecret = null;
    _ephemeralKey = null;
  }

  @override
  String toString() => 'PaymentSdkCredentials(redacted)';
}

class PaymentCheckoutEnvelope {
  PaymentCheckoutEnvelope({
    required this.allocation,
    required this.credentials,
  });
  final PaymentAllocation allocation;
  final PaymentSdkCredentials credentials;
  void dispose() => credentials.dispose();
  @override
  String toString() => 'PaymentCheckoutEnvelope(redacted)';
}
