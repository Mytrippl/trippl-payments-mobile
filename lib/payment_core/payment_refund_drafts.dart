import '../trippl_payments_mobile.dart';

class PaymentRefundDrafts {
  static String fingerprint(PaymentRefundRequestDraft draft) {
    PaymentGuard.record(draft.validate());
    return PaymentAccountGuard.fingerprint(draft.toJson());
  }

  static PaymentRefundRequestDraft create(
    PaymentOrder order,
    PaymentIntent intent,
    PaymentMoney amount,
    PaymentRefundReason reason, {
    required String scope,
    required String environment,
    required DateTime now,
    required String nonce,
    List<String> lineIds = const [],
  }) {
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.record(intent.validate());
    PaymentGuard.record(reason.validate());
    PaymentAccountGuard.context(
      intent.scopeFingerprint,
      intent.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      reason.observedAt,
      reason.expiresAt,
      reason.serverVerified,
      now,
    );
    if (!PaymentStatuses.assess(intent, now: now).paid ||
        intent.orderId != order.id ||
        intent.orderRevision != order.revision ||
        order.customerReference != null &&
            intent.customerId != order.customerReference ||
        intent.total != order.total ||
        intent.amountReceived != order.total)
      throw StateError('Refund review requires a verified paid order');
    if (!RegExp(r'^[A-Za-z0-9_-]{16,120}$').hasMatch(nonce))
      throw const FormatException('Opaque refund draft nonce required');
    PaymentAmounts.compatible(order.total, amount);
    PaymentGuard.record(amount.validate());
    if (!reason.enabled ||
        reason.serviceTypes.isNotEmpty &&
            !reason.serviceTypes.contains(order.serviceType) ||
        amount.amountMinor < 1 ||
        amount.amountMinor > order.total.amountMinor ||
        !reason.partialAllowed && amount != order.total)
      throw StateError('Refund reason or amount is not allowed');
    PaymentGuard.distinct(lineIds);
    if (reason.requiresLineSelection && lineIds.isEmpty ||
        lineIds.any((id) => !order.lines.any((l) => l.id == id)))
      throw StateError('Refund line selection invalid');
    return PaymentRefundRequestDraft(
      id: 'refund-draft-$nonce',
      scopeFingerprint: order.scopeFingerprint,
      environment: environment,
      orderId: order.id,
      intentId: intent.id,
      amount: amount,
      reasonCode: reason.code,
      createdAt: now,
      expectedOrderRevision: order.revision,
      lineIds: lineIds,
    );
  }

  static Map<String, Object?> payload(PaymentRefundRequestDraft draft) {
    PaymentGuard.record(draft.validate());
    PaymentGuard.noSensitiveKeys(draft.toJson());
    return Map.unmodifiable({
      'draftId': draft.id,
      'draftFingerprint': fingerprint(draft),
      'orderId': draft.orderId,
      'intentId': draft.intentId,
      'requestedAmount': draft.amount.toJson(),
      'reasonCode': draft.reasonCode,
      'lineIds': draft.lineIds,
      'expectedOrderRevision': draft.expectedOrderRevision,
    });
  }
}
