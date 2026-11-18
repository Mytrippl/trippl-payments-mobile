import '../trippl_payments_mobile.dart';

class PaymentRefundTimelines {
  static List<PaymentRefundTimelineEntry> validate(
    PaymentRefundTimeline timeline,
    PaymentRefundReference refund, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(timeline.validate());
    PaymentGuard.record(refund.validate());
    for (final pair in [
      (timeline.scopeFingerprint, timeline.environment),
      (refund.scopeFingerprint, refund.environment),
    ])
      PaymentAccountGuard.context(
        pair.$1,
        pair.$2,
        scope: scope,
        environment: environment,
      );
    PaymentAccountGuard.current(
      timeline.observedAt,
      timeline.expiresAt,
      timeline.serverVerified,
      now,
    );
    PaymentAccountGuard.current(
      refund.observedAt,
      refund.expiresAt,
      refund.serverVerified,
      now,
    );
    if (timeline.refundId != refund.id ||
        timeline.orderId != refund.orderId ||
        timeline.intentId != refund.intentId)
      throw StateError('Refund timeline context mismatch');
    PaymentGuard.distinct(timeline.entries.map((e) => e.id));
    final ordered = [...timeline.entries]
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    var sequence = 0;
    DateTime? prior;
    String? terminal;
    for (final entry in ordered) {
      if (entry.refundId != refund.id ||
          entry.sequence <= sequence ||
          entry.occurredAt.isBefore(refund.createdAt) ||
          entry.occurredAt.isAfter(timeline.observedAt) ||
          prior != null && entry.occurredAt.isBefore(prior))
        throw StateError('Refund timeline sequence invalid');
      if (terminal != null && entry.state != terminal)
        throw StateError('Refund timeline regresses from terminal state');
      if ({'succeeded', 'failed', 'cancelled'}.contains(entry.state))
        terminal = entry.state;
      sequence = entry.sequence;
      prior = entry.occurredAt;
    }
    final normalized = refund.status == 'canceled'
        ? 'cancelled'
        : refund.status;
    if (timeline.complete && terminal != null && terminal != normalized)
      throw StateError('Refund timeline differs from latest refund status');
    return List.unmodifiable(ordered);
  }

  static List<Map<String, Object?>> presentation(
    List<PaymentRefundTimelineEntry> ordered,
  ) => List.unmodifiable(
    ordered.map(
      (e) => Map<String, Object?>.unmodifiable({
        'id': e.id,
        'state': e.state,
        'label': e.label,
        'occurredAt': e.occurredAt.toUtc().toIso8601String(),
        'reasonCode': e.reasonCode,
      }),
    ),
  );
}
