import '../trippl_payments_mobile.dart';

class PaymentOrders {
  static void validate(
    PaymentOrder order, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(order.validate());
    PaymentGuard.identity(order.id);
    PaymentGuard.scope(order.scopeFingerprint, scope);
    if (order.updatedAt.isAfter(now))
      throw StateError('Payment order timestamp is in future');
    PaymentGuard.distinct(order.lines.map((l) => l.id));
    PaymentGuard.distinct(order.adjustments.map((a) => a.id));
    for (final line in order.lines)
      PaymentAmounts.compatible(order.total, line.unitAmount);
    for (final adjustment in order.adjustments)
      PaymentAmounts.compatible(order.total, adjustment.amount);
    if (order.customerReference != null)
      PaymentGuard.objectId(order.customerReference!, 'cus');
  }

  static String fingerprint(PaymentOrder order) {
    PaymentGuard.record(order.validate());
    final json = order.toJson()
      ..remove('createdAt')
      ..remove('updatedAt')
      ..remove('status');
    PaymentGuard.noSensitiveKeys(json);
    return PaymentCodec.digest(json);
  }

  static PaymentAmountBreakdown breakdown(
    PaymentOrder order, {
    required String scope,
    required DateTime now,
  }) {
    validate(order, scope: scope, now: now);
    final zero = order.total.copyWith(amountMinor: 0);
    var subtotal = zero,
        tax = zero,
        fees = zero,
        discounts = zero,
        credits = zero;
    void add(String kind, PaymentMoney amount) {
      switch (kind) {
        case 'tax':
          tax = PaymentAmounts.add(tax, amount);
        case 'fee':
          fees = PaymentAmounts.add(fees, amount);
        case 'discount':
          discounts = PaymentAmounts.add(discounts, amount);
        case 'credit':
          credits = PaymentAmounts.add(credits, amount);
        default:
          subtotal = PaymentAmounts.add(subtotal, amount);
      }
    }

    for (final line in order.lines)
      add(line.kind, PaymentAmounts.multiply(line.unitAmount, line.quantity));
    for (final adjustment in order.adjustments) {
      if (!adjustment.included) continue;
      if (!adjustment.confirmed)
        throw StateError('Order adjustment is not confirmed');
      add(adjustment.kind, adjustment.amount);
    }
    final gross = PaymentAmounts.add(PaymentAmounts.add(subtotal, tax), fees),
        total = PaymentAmounts.subtract(
          gross,
          PaymentAmounts.add(discounts, credits),
        );
    return PaymentAmountBreakdown(
      orderId: order.id,
      evaluatedAt: now,
      subtotal: subtotal,
      tax: tax,
      fees: fees,
      discounts: discounts,
      credits: credits,
      total: total,
      reconciled: total == order.total,
      reasonCodes: [
        if (order.lines.isEmpty) 'orderLineItemsMissing',
        if (total != order.total) 'orderTotalDoesNotReconcile',
      ],
    );
  }

  static PaymentAmountAssessment assess(
    PaymentOrder order, {
    required String scope,
    required DateTime now,
    PaymentMoney? received,
  }) {
    final b = breakdown(order, scope: scope, now: now),
        reasons = [...b.reasonCodes];
    if (received != null) {
      PaymentAmounts.compatible(order.total, received);
      if (received != order.total) reasons.add('receivedAmountMismatch');
    }
    return PaymentAmountAssessment(
      orderId: order.id,
      evaluatedAt: now,
      valid: order.lines.isNotEmpty && b.reconciled && reasons.isEmpty,
      reasonCodes: reasons,
      expected: order.total,
      received: received,
      requiresServerReview: true,
    );
  }

  static PaymentOrder replaceLines(
    PaymentOrder order,
    List<PaymentOrderLine> lines,
    List<PaymentAdjustment> adjustments, {
    required String scope,
    required DateTime now,
    required int expectedRevision,
  }) {
    validate(order, scope: scope, now: now);
    PaymentGuard.revision(order.revision, expectedRevision);
    if (!{'draft', 'quoted'}.contains(order.status))
      throw StateError('Cannot edit a payment-pending or paid order');
    final draft = order.copyWith(
      lines: lines,
      adjustments: adjustments,
      total: order.total.copyWith(amountMinor: 0),
      updatedAt: now,
      revision: order.revision + 1,
      status: 'draft',
    );
    final b = breakdown(draft, scope: scope, now: now);
    return draft.copyWith(total: b.total);
  }
}
