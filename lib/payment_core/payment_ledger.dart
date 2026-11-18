import '../trippl_payments_mobile.dart';

class PaymentLedger {
  static PaymentLedgerBalance balance(
    PaymentLedgerStatement statement, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    PaymentGuard.record(statement.validate());
    PaymentAccountGuard.context(
      statement.scopeFingerprint,
      statement.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.customer(statement.customerId, customerId);
    PaymentAccountGuard.current(
      statement.observedAt,
      statement.expiresAt,
      statement.serverVerified,
      now,
    );
    PaymentAccountGuard.currencyCode(statement.currency);
    PaymentGuard.distinct(statement.entries.map((e) => e.id));
    final sample =
        statement.entries.firstOrNull?.amount ??
        PaymentMoney(currency: statement.currency, amountMinor: 0);
    var debit = sample.copyWith(amountMinor: 0), credit = debit;
    final sequences = <int>{}, references = <String>{};
    for (final entry in statement.entries) {
      PaymentAccountGuard.context(
        entry.scopeFingerprint,
        entry.environment,
        scope: scope,
        environment: environment,
      );
      if (!entry.serverVerified ||
          entry.amount.currency != statement.currency ||
          entry.occurredAt.isBefore(statement.periodStart) ||
          entry.occurredAt.isAfter(statement.periodEnd) ||
          entry.occurredAt.isAfter(now) ||
          !sequences.add(entry.sequence) ||
          !references.add('${entry.kind}:${entry.referenceId}'))
        throw StateError('Ledger entry context or uniqueness mismatch');
      PaymentAmounts.compatible(sample, entry.amount);
      if (entry.kind == 'charge' && entry.direction != 'debit' ||
          {'refund', 'credit'}.contains(entry.kind) &&
              entry.direction != 'credit')
        throw StateError('Ledger posting direction mismatch');
      if (!entry.posted) continue;
      if (entry.direction == 'debit')
        debit = PaymentAmounts.add(debit, entry.amount);
      else
        credit = PaymentAmounts.add(credit, entry.amount);
    }
    final closing =
        BigInt.from(statement.openingMinor) +
        BigInt.from(debit.amountMinor) -
        BigInt.from(credit.amountMinor);
    if (closing.abs() > BigInt.from(9000000000000))
      throw StateError('Ledger balance exceeds safe range');
    final reconciled = closing.toInt() == statement.closingMinor;
    return PaymentLedgerBalance(
      currency: statement.currency,
      openingMinor: statement.openingMinor,
      closingMinor: closing.toInt(),
      debit: debit,
      credit: credit,
      calculatedAt: now,
      reconciled: reconciled,
      complete: statement.complete,
      reasonCodes: [
        if (!statement.complete) 'ledgerHistoryIncomplete',
        if (!reconciled) 'ledgerClosingBalanceMismatch',
      ],
    );
  }

  static PaymentLedgerReconciliation reconcile(
    PaymentLedgerStatement statement,
    PaymentOrder order,
    PaymentIntent intent, {
    required String scope,
    required String environment,
    required String customerId,
    required DateTime now,
  }) {
    final result = balance(
      statement,
      scope: scope,
      environment: environment,
      customerId: customerId,
      now: now,
    );
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.record(intent.validate());
    PaymentAccountGuard.context(
      intent.scopeFingerprint,
      intent.environment,
      scope: scope,
      environment: environment,
    );
    if (intent.orderId != order.id ||
        intent.orderRevision != order.revision ||
        order.customerReference != null &&
            (intent.customerId != order.customerReference ||
                order.customerReference != customerId) ||
        intent.total != order.total ||
        !PaymentStatuses.assess(intent, now: now).paid ||
        intent.amountReceived != order.total)
      throw StateError(
        'Ledger reconciliation requires a matching verified paid intent',
      );
    final entries = statement.entries
        .where((e) => e.orderId == order.id && e.kind == 'charge' && e.posted)
        .toList();
    var posted = order.total.copyWith(amountMinor: 0);
    final unexpected = <String>[];
    for (final entry in entries) {
      posted = PaymentAmounts.add(posted, entry.amount);
      if (entry.referenceId != intent.id) unexpected.add(entry.referenceId);
    }
    final missing = entries.any((e) => e.referenceId == intent.id)
        ? <String>[]
        : [intent.id];
    return PaymentLedgerReconciliation(
      statementId: statement.id,
      orderId: order.id,
      evaluatedAt: now,
      expected: order.total,
      posted: posted,
      matched:
          result.complete &&
          result.reconciled &&
          missing.isEmpty &&
          unexpected.isEmpty &&
          posted == order.total,
      missingReferences: missing,
      unexpectedReferences: unexpected,
      reasonCodes: [...result.reasonCodes, 'ledgerDoesNotConfirmBooking'],
    );
  }
}
