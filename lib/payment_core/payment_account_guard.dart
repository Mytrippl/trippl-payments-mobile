import '../trippl_payments_mobile.dart';

class PaymentAccountGuard {
  static void context(
    String fingerprint,
    String mode, {
    required String scope,
    required String environment,
  }) {
    PaymentGuard.scope(fingerprint, scope);
    PaymentGuard.environment(environment);
    if (mode != environment)
      throw StateError('Payment account environment mismatch');
  }

  static void current(
    DateTime observed,
    DateTime expires,
    bool verified,
    DateTime now,
  ) {
    if (!verified || !PaymentGuard.fresh(observed, expires, now)) {
      throw StateError('Current authenticated backend observation required');
    }
  }

  static void customer(String actual, String expected) {
    PaymentGuard.objectId(actual, 'cus');
    PaymentGuard.objectId(expected, 'cus');
    if (actual != expected)
      throw StateError('Payment customer context mismatch');
  }

  static void access(
    PaymentSessionContext session,
    PaymentAccessPolicy policy,
    String permission, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(session.validate());
    PaymentGuard.record(policy.validate());
    context(
      session.scopeFingerprint,
      session.environment,
      scope: scope,
      environment: environment,
    );
    PaymentGuard.scope(policy.scopeFingerprint, scope);
    customer(session.customerId, policy.customerId);
    if (!session.active ||
        !PaymentGuard.fresh(session.authenticatedAt, session.expiresAt, now)) {
      throw StateError('Payment account session expired');
    }
    current(policy.observedAt, policy.expiresAt, policy.serverVerified, now);
    if (!session.permissions.contains(permission) ||
        !policy.permissions.contains(permission)) {
      throw StateError('Payment account permission missing');
    }
  }

  static void currencyCode(String currency) {
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency))
      throw const FormatException('Explicit uppercase currency required');
  }

  static DateTime earliest(Iterable<DateTime> dates) {
    if (dates.isEmpty) throw StateError('Expiry context missing');
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  static String fingerprint(Object? value) {
    PaymentGuard.noSensitiveKeys(value);
    return PaymentCodec.digest(value);
  }
}
