import '../trippl_payments_mobile.dart';

class PaymentRefundPreviews {
  static void validate(
    PaymentRefundPreview preview,
    PaymentRefundRequestDraft draft,
    PaymentRefundEligibility eligibility, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(preview.validate());
    PaymentGuard.record(draft.validate());
    PaymentGuard.record(eligibility.validate());
    for (final pair in [
      (preview.scopeFingerprint, preview.environment),
      (draft.scopeFingerprint, draft.environment),
      (eligibility.scopeFingerprint, eligibility.environment),
    ])
      PaymentAccountGuard.context(
        pair.$1,
        pair.$2,
        scope: scope,
        environment: environment,
      );
    PaymentAccountGuard.current(
      preview.observedAt,
      preview.expiresAt,
      preview.serverVerified,
      now,
    );
    PaymentAccountGuard.current(
      eligibility.observedAt,
      eligibility.expiresAt,
      eligibility.serverVerified,
      now,
    );
    PaymentAmounts.compatible(draft.amount, eligibility.maximumRequest);
    PaymentAmounts.compatible(draft.amount, eligibility.available);
    final reason = eligibility.reasons
        .where((r) => r.code == draft.reasonCode)
        .firstOrNull;
    if (reason == null ||
        !reason.enabled ||
        !reason.serverVerified ||
        !PaymentGuard.fresh(reason.observedAt, reason.expiresAt, now) ||
        eligibility.maximumRequest.amountMinor >
            eligibility.available.amountMinor) {
      throw StateError(
        'Refund preview reason or capacity is no longer eligible',
      );
    }
    if (preview.draftFingerprint != PaymentRefundDrafts.fingerprint(draft) ||
        preview.orderId != draft.orderId ||
        preview.intentId != draft.intentId ||
        eligibility.orderId != draft.orderId ||
        eligibility.intentId != draft.intentId ||
        preview.requested != draft.amount ||
        !eligibility.eligible ||
        draft.amount.amountMinor > eligibility.maximumRequest.amountMinor ||
        preview.status != 'review')
      throw StateError('Refund preview does not match current eligible draft');
    if (PaymentAmounts.add(preview.fee, preview.net) != preview.requested)
      throw StateError('Refund fee and net amounts do not reconcile');
  }

  static PaymentRefundSubmission review(
    PaymentRefundPreview preview,
    PaymentRefundRequestDraft draft,
    PaymentRefundEligibility eligibility, {
    required String scope,
    required String environment,
    required DateTime now,
    required List<String> acknowledgedWarnings,
  }) {
    validate(
      preview,
      draft,
      eligibility,
      scope: scope,
      environment: environment,
      now: now,
    );
    PaymentGuard.distinct(acknowledgedWarnings);
    if (acknowledgedWarnings
            .toSet()
            .difference(preview.warningCodes.toSet())
            .isNotEmpty ||
        preview.warningCodes
            .toSet()
            .difference(acknowledgedWarnings.toSet())
            .isNotEmpty)
      throw StateError('Review all refund warnings');
    return PaymentRefundSubmission(
      id: 'refund-review-${preview.id}',
      scopeFingerprint: draft.scopeFingerprint,
      environment: environment,
      draftId: draft.id,
      draftFingerprint: PaymentRefundDrafts.fingerprint(draft),
      previewId: preview.id,
      orderId: draft.orderId,
      intentId: draft.intentId,
      createdAt: now,
      expiresAt: PaymentAccountGuard.earliest([
        preview.expiresAt,
        eligibility.expiresAt,
      ]),
    );
  }
}
