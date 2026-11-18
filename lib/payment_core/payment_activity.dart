import '../trippl_payments_mobile.dart';

class PaymentActivity {
  static String fingerprint(PaymentActivityFilter filter) {
    PaymentGuard.record(filter.validate());
    return PaymentAccountGuard.fingerprint(filter.toJson());
  }

  static List<PaymentActivityEntry> page(
    PaymentActivityPage page,
    PaymentActivityFilter filter, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(page.validate());
    PaymentGuard.record(filter.validate());
    PaymentAccountGuard.context(
      page.scopeFingerprint,
      page.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      page.observedAt,
      page.expiresAt,
      page.serverVerified,
      now,
    );
    if (page.requestFingerprint != fingerprint(filter) ||
        page.entries.length > filter.limit)
      throw StateError('Activity page request mismatch');
    PaymentGuard.distinct(page.entries.map((e) => e.id));
    for (final entry in page.entries) {
      validateEntry(entry, scope: scope, environment: environment, now: now);
      if (!matches(entry, filter))
        throw StateError('Activity entry outside requested filter');
    }
    return filterEntries(page.entries, filter);
  }

  static void validateEntry(
    PaymentActivityEntry entry, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(entry.validate());
    PaymentAccountGuard.context(
      entry.scopeFingerprint,
      entry.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      entry.observedAt,
      entry.expiresAt,
      entry.serverVerified,
      now,
    );
    if (entry.occurredAt.isAfter(entry.observedAt))
      throw StateError('Activity occurs after its observation');
    if (entry.intentId != null) PaymentGuard.objectId(entry.intentId!, 'pi');
  }

  static bool matches(
    PaymentActivityEntry entry,
    PaymentActivityFilter filter,
  ) =>
      (filter.kinds.isEmpty || filter.kinds.contains(entry.kind)) &&
      (filter.statuses.isEmpty || filter.statuses.contains(entry.status)) &&
      (filter.orderIds.isEmpty || filter.orderIds.contains(entry.orderId)) &&
      (filter.currency == null || entry.amount?.currency == filter.currency) &&
      (filter.from == null || !entry.occurredAt.isBefore(filter.from!)) &&
      (filter.until == null || !entry.occurredAt.isAfter(filter.until!));
  static List<PaymentActivityEntry> filterEntries(
    List<PaymentActivityEntry> entries,
    PaymentActivityFilter filter,
  ) {
    PaymentGuard.record(filter.validate());
    PaymentGuard.distinct(entries.map((e) => e.id));
    final result = entries.where((e) => matches(e, filter)).toList()
      ..sort((a, b) {
        final t = a.occurredAt.compareTo(b.occurredAt);
        return t != 0 ? (filter.newestFirst ? -t : t) : a.id.compareTo(b.id);
      });
    return List.unmodifiable(result.take(filter.limit));
  }

  static PaymentActivitySummary summarize(
    List<PaymentActivityEntry> entries, {
    required String currency,
    required int decimals,
    required DateTime now,
    bool complete = false,
  }) {
    PaymentAccountGuard.currencyCode(currency);
    PaymentGuard.distinct(entries.map((e) => e.id));
    var charges = PaymentMoney(
          currency: currency,
          decimals: decimals,
          amountMinor: 0,
        ),
        refunds = charges;
    final pending = <String>[], attention = <String>[];
    for (final entry in entries) {
      PaymentGuard.record(entry.validate());
      PaymentAccountGuard.current(
        entry.observedAt,
        entry.expiresAt,
        entry.serverVerified,
        now,
      );
      if ({'pending', 'processing'}.contains(entry.status))
        pending.add(entry.id);
      if ({
        'failed',
        'requires_action',
        'needs_response',
        'unknown',
      }.contains(entry.status))
        attention.add(entry.id);
      if (entry.amount?.currency != currency) continue;
      if (entry.kind == 'payment' && entry.status == 'succeeded')
        charges = PaymentAmounts.add(charges, entry.amount!);
      if (entry.kind == 'refund' && entry.status == 'succeeded')
        refunds = PaymentAmounts.add(refunds, entry.amount!);
    }
    return PaymentActivitySummary(
      evaluatedAt: now,
      currency: currency,
      charges: charges,
      refunds: refunds,
      count: entries.length,
      pendingIds: pending,
      attentionIds: attention,
      complete: complete,
      reasonCodes: [
        if (!complete) 'activityHistoryIncomplete',
        'activityIsNotBookingProof',
      ],
    );
  }
}
