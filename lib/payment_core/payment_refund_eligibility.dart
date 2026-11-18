import '../trippl_payments_mobile.dart';

class PaymentRefundEligibilityRules {
  static void validate(
    PaymentRefundEligibility eligibility,
    PaymentRefundRequestDraft draft,
    PaymentRefundSummary summary, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(eligibility.validate());
    PaymentGuard.record(draft.validate());
    PaymentGuard.record(summary.validate());
    PaymentAccountGuard.context(
      eligibility.scopeFingerprint,
      eligibility.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.context(
      draft.scopeFingerprint,
      draft.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      eligibility.observedAt,
      eligibility.expiresAt,
      eligibility.serverVerified,
      now,
    );
    if (draft.createdAt.isAfter(now) ||
        eligibility.orderId != draft.orderId ||
        eligibility.intentId != draft.intentId ||
        summary.orderId != draft.orderId ||
        summary.intentId != draft.intentId ||
        !summary.complete ||
        summary.remaining == null ||
        summary.evaluatedAt.isAfter(now))
      throw StateError('Refund eligibility lacks complete matching history');
    PaymentAmounts.compatible(draft.amount, eligibility.available);
    PaymentAmounts.compatible(draft.amount, eligibility.maximumRequest);
    if (eligibility.available != summary.remaining ||
        eligibility.maximumRequest.amountMinor >
            eligibility.available.amountMinor ||
        !eligibility.eligible ||
        draft.amount.amountMinor > eligibility.maximumRequest.amountMinor)
      throw StateError('Refund request exceeds current eligibility');
    PaymentGuard.distinct(eligibility.reasons.map((r) => r.code));
    final reason = eligibility.reasons
        .where((r) => r.code == draft.reasonCode)
        .firstOrNull;
    if (reason == null ||
        !reason.enabled ||
        !PaymentGuard.fresh(reason.observedAt, reason.expiresAt, now) ||
        !reason.serverVerified ||
        reason.requiresLineSelection && draft.lineIds.isEmpty ||
        !reason.partialAllowed && draft.amount != summary.paid)
      throw StateError('Refund reason no longer eligible');
  }
}
