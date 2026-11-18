import '../trippl_payments_mobile.dart';

class PaymentDisputes {
  static void validate(
    PaymentDispute dispute,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(dispute.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentAccountGuard.context(
      dispute.scopeFingerprint,
      dispute.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      dispute.observedAt,
      dispute.expiresAt,
      dispute.serverVerified,
      now,
    );
    PaymentGuard.objectId(dispute.intentId, 'pi');
    PaymentAmounts.compatible(order.total, dispute.amount);
    if (dispute.orderId != order.id ||
        dispute.amount.amountMinor < 1 ||
        dispute.amount.amountMinor > order.total.amountMinor ||
        dispute.openedAt.isAfter(dispute.observedAt))
      throw StateError('Dispute order amount or timestamps mismatch');
  }

  static List<PaymentDisputeEvent> events(
    PaymentDispute dispute,
    List<PaymentDisputeEvent> events, {
    required DateTime now,
  }) {
    PaymentGuard.record(dispute.validate());
    PaymentAccountGuard.current(
      dispute.observedAt,
      dispute.expiresAt,
      dispute.serverVerified,
      now,
    );
    PaymentGuard.distinct(events.map((e) => e.id));
    final ordered = [...events]
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    var sequence = 0;
    DateTime? previous;
    for (final event in ordered) {
      PaymentGuard.record(event.validate());
      if (event.disputeId != dispute.id ||
          !event.serverVerified ||
          event.sequence <= sequence ||
          event.occurredAt.isAfter(dispute.observedAt) ||
          event.occurredAt.isBefore(dispute.openedAt) ||
          previous != null && event.occurredAt.isBefore(previous))
        throw StateError('Dispute event history mismatch');
      sequence = event.sequence;
      previous = event.occurredAt;
    }
    return List.unmodifiable(ordered);
  }

  static PaymentDisputeSummary summarize(
    String orderId,
    List<PaymentDispute> disputes, {
    required DateTime now,
    bool complete = false,
  }) {
    PaymentGuard.distinct(disputes.map((d) => d.id));
    final open = <String>[], closed = <String>[], soon = <String>[];
    for (final d in disputes) {
      PaymentGuard.record(d.validate());
      PaymentAccountGuard.current(
        d.observedAt,
        d.expiresAt,
        d.serverVerified,
        now,
      );
      if (d.orderId != orderId)
        throw StateError('Dispute summary mixes orders');
      if ({'won', 'lost', 'closed'}.contains(d.status))
        closed.add(d.id);
      else
        open.add(d.id);
      if (d.status == 'needs_response' &&
          d.responseDueAt != null &&
          d.responseDueAt!.difference(now) <= const Duration(hours: 48))
        soon.add(d.id);
    }
    return PaymentDisputeSummary(
      orderId: orderId,
      evaluatedAt: now,
      openIds: open,
      closedIds: closed,
      dueSoonIds: soon,
      complete: complete,
      reasonCodes: [if (!complete) 'disputeHistoryIncomplete'],
    );
  }
}
