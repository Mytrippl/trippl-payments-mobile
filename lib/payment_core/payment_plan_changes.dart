import '../trippl_payments_mobile.dart';

class PaymentPlanChanges {
  static PaymentPlanChange propose(
    PaymentInstallmentPlan current,
    PaymentInstallmentPlan replacement,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
    required int expectedRevision,
    required String reasonCode,
  }) {
    PaymentInstallments.validate(
      current,
      order,
      scope: scope,
      environment: environment,
      now: now,
    );
    PaymentInstallments.validate(
      replacement,
      order,
      scope: scope,
      environment: environment,
      now: now,
    );
    PaymentGuard.revision(current.revision, expectedRevision);
    PaymentGuard.identity(reasonCode);
    if (!{'proposed', 'active'}.contains(current.status) ||
        replacement.id != current.id ||
        replacement.revision != current.revision + 1 ||
        replacement.termsRevision <= current.termsRevision)
      throw StateError('Plan replacement identity or revision mismatch');
    for (final paid in current.installments.where((i) => i.status == 'paid')) {
      final next = replacement.installments
          .where((i) => i.id == paid.id)
          .firstOrNull;
      if (next != paid)
        throw StateError('A paid installment cannot be rewritten');
    }
    return PaymentPlanChange(
      id: 'plan-change-${PaymentPlanConsents.fingerprint(replacement)}',
      scopeFingerprint: current.scopeFingerprint,
      environment: environment,
      planId: current.id,
      expectedRevision: expectedRevision,
      replacement: replacement,
      reasonCode: reasonCode,
      createdAt: now,
    );
  }

  static List<PaymentInstallmentPlan> history(
    PaymentPlanHistory history, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(history.validate());
    PaymentAccountGuard.context(
      history.scopeFingerprint,
      history.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      history.observedAt,
      history.expiresAt,
      history.serverVerified,
      now,
    );
    final versions = [...history.versions]
      ..sort((a, b) => a.revision.compareTo(b.revision));
    final seen = <int>{};
    DateTime? previous;
    for (final plan in versions) {
      PaymentAccountGuard.context(
        plan.scopeFingerprint,
        plan.environment,
        scope: scope,
        environment: environment,
      );
      if (plan.id != history.planId ||
          plan.orderId != history.orderId ||
          !plan.serverVerified ||
          plan.observedAt.isAfter(now) ||
          !seen.add(plan.revision) ||
          previous != null && plan.observedAt.isBefore(previous))
        throw StateError('Plan history is inconsistent');
      previous = plan.observedAt;
    }
    return List.unmodifiable(versions);
  }
}
