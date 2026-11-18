import '../trippl_payments_mobile.dart';

class PaymentBillingProfiles {
  static void validate(
    PaymentBillingProfile profile, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    PaymentGuard.record(profile.validate());
    PaymentAccountGuard.context(
      profile.scopeFingerprint,
      profile.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(profile.customerId, customerId);
    PaymentAccountGuard.current(
      profile.observedAt,
      profile.expiresAt,
      profile.serverVerified,
      now,
    );
    PaymentGuard.distinct(profile.taxIdentityIds);
    if (profile.address.updatedAt.isAfter(profile.observedAt))
      throw StateError('Billing address is newer than its backend observation');
  }

  static PaymentBillingPatch patch(
    PaymentBillingProfile profile,
    PaymentBillingAddress replacement,
    PaymentCountryAddressRule rule, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
    required int expectedRevision,
  }) {
    validate(
      profile,
      scope: scope,
      environment: environment,
      customerId: customerId,
      now: now,
    );
    PaymentGuard.revision(profile.revision, expectedRevision);
    if (replacement.id != profile.address.id ||
        replacement.revision != profile.address.revision + 1 ||
        replacement.updatedAt.isBefore(profile.address.updatedAt)) {
      throw StateError('Billing address replacement revision mismatch');
    }
    final address = PaymentBillingAddresses.normalize(
      replacement,
      rule,
      now: now,
    );
    final before = profile.address.toJson(), after = address.toJson();
    final changed = after.keys
        .where(
          (k) =>
              !{'revision', 'updatedAt', 'id'}.contains(k) &&
              !PaymentCodec.same(before[k], after[k]),
        )
        .toList();
    if (changed.isEmpty) throw StateError('Billing address has no changes');
    return PaymentBillingPatch(
      id: 'billing-${PaymentCodec.digest(after)}',
      scopeFingerprint: profile.scopeFingerprint,
      environment: environment,
      profileId: profile.id,
      customerId: customerId,
      expectedRevision: expectedRevision,
      address: address,
      createdAt: now,
      changedFields: changed,
    );
  }

  static void taxIdentity(
    PaymentTaxIdentity identity, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    PaymentGuard.record(identity.validate());
    PaymentAccountGuard.context(
      identity.scopeFingerprint,
      identity.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(identity.customerId, customerId);
    PaymentAccountGuard.current(
      identity.observedAt,
      identity.expiresAt,
      identity.serverVerified,
      now,
    );
    if (!identity.maskedValue.contains('*') ||
        RegExp(r'\d{5,}').hasMatch(identity.maskedValue))
      throw StateError('Tax identity must be masked for mobile presentation');
  }

  static void taxAssessment(
    PaymentTaxAssessment assessment,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(assessment.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentAccountGuard.context(
      assessment.scopeFingerprint,
      assessment.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      assessment.observedAt,
      assessment.expiresAt,
      assessment.serverVerified,
      now,
    );
    if (assessment.orderId != order.id || assessment.total != order.total)
      throw StateError('Tax assessment order mismatch');
    PaymentAmounts.compatible(assessment.subtotal, assessment.tax);
    final calculated = assessment.inclusive
        ? assessment.subtotal
        : PaymentAmounts.add(assessment.subtotal, assessment.tax);
    if (calculated != assessment.total ||
        assessment.inclusive &&
            assessment.tax.amountMinor > assessment.subtotal.amountMinor)
      throw StateError('Tax assessment does not reconcile');
  }
}
