import '../trippl_payments_mobile.dart';

class PaymentConfiguration {
  static void validate(
    PaymentSdkConfiguration config,
    PaymentEnvironment environment, {
    required DateTime now,
  }) {
    PaymentGuard.record(config.validate());
    PaymentGuard.record(environment.validate());
    PaymentGuard.language(config.language);
    PaymentGuard.environment(config.environment);
    if (!environment.sdkReady ||
        environment.mode != config.environment ||
        environment.merchantCountry != config.merchantCountry ||
        environment.configuredAt.isAfter(now))
      throw StateError(
        'Native payment configuration is not ready or environments differ',
      );
    final uri = Uri.tryParse(config.returnUri);
    if (uri == null ||
        !{'https', 'mytrippl'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment ||
        uri.queryParameters.keys.any((k) => k.toLowerCase().contains('secret')))
      throw StateError('Invalid native payment return URI');
  }

  static PaymentEnvironment configured(
    String publishableKey, {
    required String merchantCountry,
    required String mode,
    required DateTime now,
    bool sdkReady = false,
  }) {
    PaymentGuard.environment(mode);
    if (!RegExp('^pk_${mode}_[A-Za-z0-9]{1,300}\$').hasMatch(publishableKey))
      throw const FormatException('Publishable key environment mismatch');
    final e = PaymentEnvironment(
      mode: mode,
      merchantCountry: merchantCountry,
      publishableKeyFingerprint: PaymentCodec.digest(publishableKey),
      configuredAt: now,
      sdkReady: sdkReady,
    );
    PaymentGuard.record(e.validate());
    return e;
  }

  static List<String> availableWallets(
    PaymentCapabilities capabilities,
    PaymentSdkConfiguration config,
    PaymentMoney total, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(capabilities.validate());
    PaymentGuard.scope(capabilities.scopeFingerprint, scope);
    PaymentGuard.record(config.validate());
    if (!capabilities.serverVerified ||
        capabilities.environment != config.environment ||
        !PaymentGuard.fresh(
          capabilities.observedAt,
          capabilities.expiresAt,
          now,
        ) ||
        !capabilities.currencies.contains(total.currency))
      throw StateError(
        'Payment capabilities require a fresh matching backend response',
      );
    return List.unmodifiable(
      capabilities.wallets
          .where(
            (w) =>
                w.supported &&
                w.environment == config.environment &&
                PaymentGuard.fresh(w.checkedAt, w.expiresAt, now) &&
                (w.merchantCountry == null ||
                    w.merchantCountry == config.merchantCountry) &&
                (w.currency == null || w.currency == total.currency) &&
                (w.kind == 'applePay' && config.applePayEnabled ||
                    w.kind == 'googlePay' && config.googlePayEnabled ||
                    w.kind == 'card'),
          )
          .map((w) => w.kind),
    );
  }
}
