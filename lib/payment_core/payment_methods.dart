import '../trippl_payments_mobile.dart';

class PaymentMethods {
  static void validate(
    PaymentMethodReference method, {
    required String scope,
    required String customerId,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(method.validate());
    PaymentGuard.scope(method.scopeFingerprint, scope);
    PaymentGuard.objectId(method.methodId, 'pm');
    PaymentGuard.objectId(customerId, 'cus');
    if (method.customerId != customerId ||
        method.environment != environment ||
        !method.serverVerified ||
        !PaymentGuard.fresh(method.observedAt, method.expiresAt, now))
      throw StateError(
        'Saved method customer environment or observation mismatch',
      );
    if (method.expiryYear != null &&
        method.expiryMonth != null &&
        DateTime.utc(method.expiryYear!, method.expiryMonth! + 1).isBefore(now))
      throw StateError('Saved card has expired');
  }

  static PaymentMethodSelection select(
    PaymentMethodSelection current,
    PaymentMethodReference? method, {
    required String scope,
    required DateTime now,
    required int expectedRevision,
    String kind = 'newCard',
  }) {
    PaymentGuard.record(current.validate());
    PaymentGuard.scope(current.scopeFingerprint, scope);
    PaymentGuard.revision(current.revision, expectedRevision);
    if (current.updatedAt.isAfter(now))
      throw StateError('Payment method selection clock mismatch');
    if (method != null) {
      validate(
        method,
        scope: scope,
        customerId: current.customerId,
        environment: current.environment,
        now: now,
      );
      if (!method.reusable) throw StateError('Method is not marked reusable');
      kind = 'savedMethod';
    }
    final next = current.copyWith(
      methodId: method?.methodId,
      kind: kind,
      updatedAt: now,
      revision: current.revision + 1,
      clear: method == null ? {'methodId'} : {},
    );
    PaymentGuard.record(next.validate());
    return next;
  }

  static Map<String, Object?> summary(
    PaymentMethodReference method, {
    required String scope,
    required String customerId,
    required String environment,
    required DateTime now,
    String language = 'en',
  }) {
    validate(
      method,
      scope: scope,
      customerId: customerId,
      environment: environment,
      now: now,
    );
    PaymentGuard.language(language);
    return Map.unmodifiable({
      'methodId': method.methodId,
      'type': method.type,
      'brand': method.brand,
      'masked': method.last4 == null ? null : '•••• ${method.last4}',
      'expiryMonth': method.expiryMonth,
      'expiryYear': method.expiryYear,
      'wallet': method.wallet,
      'reusable': method.reusable,
      'billingDetailsIncluded': false,
    });
  }

  static List<PaymentMethodReference> list(
    List<PaymentMethodReference> methods, {
    required String scope,
    required String customerId,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.distinct(methods.map((m) => m.methodId));
    if (methods.length > 100)
      throw const FormatException('Saved payment method capacity exceeded');
    for (final method in methods)
      validate(
        method,
        scope: scope,
        customerId: customerId,
        environment: environment,
        now: now,
      );
    return List.unmodifiable(methods);
  }
}
