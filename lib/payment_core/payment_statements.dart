import '../trippl_payments_mobile.dart';

class PaymentStatements {
  static void validate(
    PaymentStatement statement,
    PaymentStatementQuery query, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(statement.validate());
    PaymentGuard.record(query.validate());
    PaymentAccountGuard.context(
      statement.scopeFingerprint,
      statement.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(statement.customerId, query.customerId);
    PaymentAccountGuard.current(
      statement.observedAt,
      statement.expiresAt,
      statement.serverVerified,
      now,
    );
    PaymentAccountGuard.currencyCode(query.currency);
    if (statement.currency != query.currency ||
        statement.periodStart != query.periodStart ||
        statement.periodEnd != query.periodEnd ||
        statement.entries.length > query.limit)
      throw StateError('Statement request mismatch');
    PaymentGuard.distinct(statement.entries.map((e) => e.id));
    for (final entry in statement.entries) {
      PaymentAccountGuard.currencyCode(entry.amount.currency);
      if (entry.amount.currency != query.currency ||
          entry.occurredAt.isBefore(query.periodStart) ||
          entry.occurredAt.isAfter(query.periodEnd) ||
          entry.occurredAt.isAfter(now) ||
          !query.includePending && entry.status == 'pending' ||
          query.orderIds.isNotEmpty && !query.orderIds.contains(entry.orderId))
        throw StateError('Statement entry outside requested range');
      if (entry.intentId != null) PaymentGuard.objectId(entry.intentId!, 'pi');
      if (entry.kind == 'refund' && entry.refundId == null)
        throw StateError('Refund statement entry lacks reference');
    }
  }

  static List<PaymentStatementEntry> ordered(PaymentStatement statement) {
    PaymentGuard.record(statement.validate());
    final rows = [...statement.entries]
      ..sort((a, b) {
        final t = a.occurredAt.compareTo(b.occurredAt);
        return t != 0 ? t : a.id.compareTo(b.id);
      });
    return List.unmodifiable(rows);
  }

  static Map<String, PaymentMoney> totals(PaymentStatement statement) {
    PaymentGuard.record(statement.validate());
    final first =
        statement.entries.firstOrNull?.amount ??
        PaymentMoney(currency: statement.currency, amountMinor: 0);
    final zero = first.copyWith(amountMinor: 0);
    var charged = zero, refunded = zero;
    for (final entry in statement.entries) {
      if (entry.amount.currency != statement.currency)
        throw StateError('Statement mixes currencies');
      if (entry.status != 'posted') continue;
      if (entry.kind == 'charge')
        charged = PaymentAmounts.add(charged, entry.amount);
      if (entry.kind == 'refund')
        refunded = PaymentAmounts.add(refunded, entry.amount);
    }
    return Map.unmodifiable({'charged': charged, 'refunded': refunded});
  }
}
