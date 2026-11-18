import '../trippl_payments_mobile.dart';

class PaymentSdkOutcome {
  const PaymentSdkOutcome(this.state, {this.errorCode});
  final String state;
  final String? errorCode;
  static const completed = PaymentSdkOutcome('completed');
  static const cancelled = PaymentSdkOutcome('cancelled');
  @override
  String toString() => 'PaymentSdkOutcome(redacted)';
}

abstract interface class PaymentNativeSdk {
  Future<void> initialize(PaymentSdkConfiguration configuration);
  Future<PaymentSdkOutcome> present(
    PaymentAllocation allocation,
    PaymentSdkConfiguration configuration,
    String clientSecret,
    String? ephemeralKey,
  );
}

class PaymentSdkAdapter {
  PaymentSdkAdapter(this.sdk, {required this.scope, required this.clock});
  final PaymentNativeSdk sdk;
  final String scope;
  final DateTime Function() clock;
  bool _busy = false;
  Future<PaymentSdkOutcome> present(
    PaymentCheckoutEnvelope envelope,
    PaymentSdkConfiguration configuration,
    PaymentEnvironment environment,
  ) async {
    if (_busy) throw StateError('Native payment interface already active');
    PaymentConfiguration.validate(configuration, environment, now: clock());
    final a = envelope.allocation;
    PaymentGuard.record(a.validate());
    PaymentGuard.scope(a.scopeFingerprint, scope);
    if (a.environment != configuration.environment ||
        a.credentials.environment != configuration.environment ||
        a.credentials.orderId != a.orderId ||
        a.credentials.intentId != a.intentId ||
        envelope.credentials.reference != a.credentials)
      throw StateError('SDK allocation credentials or environment mismatch');
    _busy = true;
    try {
      await sdk.initialize(configuration);
      return await envelope.credentials.use(
        (secret, ephemeral) => sdk.present(a, configuration, secret, ephemeral),
        scope: scope,
        now: clock(),
      );
    } finally {
      _busy = false;
      envelope.dispose();
    }
  }
}

/// The host wires these callbacks to its installed Flutter Stripe SDK version.
class PaymentCallbackSdk implements PaymentNativeSdk {
  PaymentCallbackSdk({required this.onInitialize, required this.onPresent});
  final Future<void> Function(PaymentSdkConfiguration) onInitialize;
  final Future<PaymentSdkOutcome> Function(
    PaymentAllocation,
    PaymentSdkConfiguration,
    String,
    String?,
  )
  onPresent;
  @override
  Future<void> initialize(PaymentSdkConfiguration configuration) =>
      onInitialize(configuration);
  @override
  Future<PaymentSdkOutcome> present(
    PaymentAllocation a,
    PaymentSdkConfiguration c,
    String secret,
    String? ephemeral,
  ) => onPresent(a, c, secret, ephemeral);
}
