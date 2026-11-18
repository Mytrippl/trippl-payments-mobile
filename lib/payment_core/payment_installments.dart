import '../trippl_payments_mobile.dart';

class PaymentInstallments {
  static void validate(
    PaymentInstallmentPlan plan,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(plan.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
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
    if (plan.orderId != order.id ||
        plan.orderFingerprint != PaymentOrders.fingerprint(order) ||
        plan.total != order.total)
      throw StateError('Installment plan order mismatch');
    PaymentGuard.distinct(plan.installments.map((i) => i.id));
    var sum = plan.total.copyWith(amountMinor: 0);
    DateTime? previous;
    final ids = <String>{};
    for (var index = 0; index < plan.installments.length; index++) {
      final installment = plan.installments[index];
      if (installment.sequence != index + 1 ||
          installment.amount.amountMinor < 1 ||
          previous != null && installment.dueAt.isBefore(previous))
        throw StateError('Installments must be positive and ordered');
      previous = installment.dueAt;
      sum = PaymentAmounts.add(sum, installment.amount);
      if (installment.intentId != null) {
        PaymentGuard.objectId(installment.intentId!, 'pi');
        if (!ids.add(installment.intentId!))
          throw StateError('PaymentIntent cannot settle multiple installments');
      }
      if (installment.status == 'paid' &&
          (installment.intentId == null ||
              installment.paidAt == null ||
              installment.paidAt!.isAfter(plan.observedAt)))
        throw StateError('Paid installment lacks backend payment reference');
      if (installment.status != 'paid' && installment.paidAt != null)
        throw StateError('Unpaid installment has a paid timestamp');
    }
    if (sum != plan.total)
      throw StateError('Installments do not reconcile with order total');
    if (plan.status == 'completed' &&
        plan.installments.any((i) => i.status != 'paid'))
      throw StateError('Completed plan contains unsettled installments');
  }

  static PaymentPlanAssessment assess(
    PaymentInstallmentPlan plan,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    validate(plan, order, scope: scope, environment: environment, now: now);
    var paid = plan.total.copyWith(amountMinor: 0), pending = paid;
    final overdue = <String>[], reasons = <String>[];
    PaymentInstallment? next;
    for (final item in plan.installments) {
      if (item.status == 'paid')
        paid = PaymentAmounts.add(paid, item.amount);
      else if (item.status == 'processing')
        pending = PaymentAmounts.add(pending, item.amount);
      if (!{'paid', 'cancelled'}.contains(item.status)) {
        next ??= item;
        if (item.dueAt.isBefore(now) && item.status != 'processing')
          overdue.add(item.id);
      }
      if (item.status == 'unknown') reasons.add('installmentStatusUnknown');
    }
    if (plan.status == 'cancelled') reasons.add('planCancelled');
    return PaymentPlanAssessment(
      planId: plan.id,
      orderId: order.id,
      evaluatedAt: now,
      paid: paid,
      pending: pending,
      remaining: PaymentAmounts.subtract(plan.total, paid),
      overdueIds: overdue,
      nextInstallmentId: next?.id ?? 'none',
      complete: plan.status == 'completed' && reasons.isEmpty,
      reasonCodes: reasons.toSet().toList(),
    );
  }

  static PaymentPlanSchedule schedule(
    PaymentInstallmentPlan plan, {
    required DateTime now,
  }) {
    PaymentGuard.record(plan.validate());
    PaymentAccountGuard.current(
      plan.observedAt,
      plan.expiresAt,
      plan.serverVerified,
      now,
    );
    final due = <String>[], upcoming = <String>[], overdue = <String>[];
    for (final item in plan.installments) {
      if ({'paid', 'cancelled', 'processing'}.contains(item.status) ||
          plan.status == 'cancelled')
        continue;
      if (item.dueAt.isBefore(now))
        overdue.add(item.id);
      else if (item.dueAt.difference(now) <= const Duration(hours: 24))
        due.add(item.id);
      else
        upcoming.add(item.id);
    }
    return PaymentPlanSchedule(
      planId: plan.id,
      orderId: plan.orderId,
      generatedAt: now,
      expiresAt: plan.expiresAt,
      dueNowIds: due,
      upcomingIds: upcoming,
      overdueIds: overdue,
    );
  }
}
