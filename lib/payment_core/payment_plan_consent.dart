import '../trippl_payments_mobile.dart';

class PaymentPlanConsents {
  static String fingerprint(PaymentInstallmentPlan plan) {
    PaymentGuard.record(plan.validate());
    return PaymentAccountGuard.fingerprint(plan.toJson());
  }

  static PaymentPlanConsent accept(
    PaymentInstallmentPlan plan,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
    required List<String> acknowledgedCodes,
  }) {
    PaymentInstallments.validate(
      plan,
      order,
      scope: scope,
      environment: environment,
      now: now,
    );
    if (plan.status != 'proposed')
      throw StateError('Review consent is limited to proposed plans');
    PaymentGuard.distinct(acknowledgedCodes);
    if (!acknowledgedCodes.toSet().containsAll({
      'scheduleReviewed',
      'noAutomaticCharge',
    }))
      throw StateError('Plan review acknowledgements missing');
    return PaymentPlanConsent(
      id: 'consent-${fingerprint(plan)}',
      scopeFingerprint: plan.scopeFingerprint,
      environment: environment,
      planId: plan.id,
      planFingerprint: fingerprint(plan),
      termsRevision: plan.termsRevision,
      acceptedAt: now,
      expiresAt: plan.expiresAt,
      acknowledgedCodes: acknowledgedCodes,
    );
  }

  static void validate(
    PaymentPlanConsent consent,
    PaymentInstallmentPlan plan, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(consent.validate());
    PaymentGuard.record(plan.validate());
    PaymentAccountGuard.context(
      consent.scopeFingerprint,
      consent.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.context(
      plan.scopeFingerprint,
      plan.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      plan.observedAt,
      plan.expiresAt,
      plan.serverVerified,
      now,
    );
    if (!PaymentGuard.fresh(consent.acceptedAt, consent.expiresAt, now) ||
        consent.planId != plan.id ||
        consent.planFingerprint != fingerprint(plan) ||
        consent.termsRevision != plan.termsRevision ||
        !consent.acknowledgedCodes.toSet().containsAll({
          'scheduleReviewed',
          'noAutomaticCharge',
        }))
      throw StateError('Plan changed since customer review');
  }
}
