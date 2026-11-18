import '../trippl_payments_mobile.dart';

class PaymentDeposits {
  static void validate(
    PaymentDepositQuote quote,
    PaymentDepositTerms terms,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(quote.validate());
    PaymentGuard.record(terms.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    for (final pair in [
      (quote.scopeFingerprint, quote.environment),
      (terms.scopeFingerprint, terms.environment),
    ])
      PaymentAccountGuard.context(
        pair.$1,
        pair.$2,
        scope: scope,
        environment: environment,
      );
    PaymentAccountGuard.current(
      quote.observedAt,
      quote.expiresAt,
      quote.serverVerified,
      now,
    );
    PaymentAccountGuard.current(
      terms.observedAt,
      terms.expiresAt,
      terms.serverVerified,
      now,
    );
    if (quote.orderId != order.id ||
        quote.orderFingerprint != PaymentOrders.fingerprint(order) ||
        quote.total != order.total ||
        quote.termsId != terms.id ||
        terms.serviceType != order.serviceType ||
        quote.balanceDueAt != terms.balanceDueAt)
      throw StateError('Deposit terms do not match order');
    if (PaymentAmounts.add(quote.deposit, quote.balance) != order.total ||
        quote.deposit.amountMinor == 0)
      throw StateError('Deposit and balance do not reconcile');
    PaymentAmounts.compatible(order.total, terms.minimumDeposit);
    final percentage = PaymentAmounts.percent(
      order.total,
      terms.depositBasisPoints,
    );
    final expected = percentage.amountMinor >= terms.minimumDeposit.amountMinor
        ? percentage
        : terms.minimumDeposit;
    if (expected.amountMinor > order.total.amountMinor ||
        quote.deposit != expected)
      throw StateError('Backend deposit differs from declared terms');
    if (quote.balance.amountMinor > 0 && !quote.balanceDueAt.isAfter(now))
      throw StateError('Balance due date already passed');
  }

  static Map<String, Object?> presentation(
    PaymentDepositQuote quote,
    PaymentDepositTerms terms, {
    String language = 'en',
  }) {
    PaymentGuard.record(quote.validate());
    PaymentGuard.record(terms.validate());
    if (quote.termsId != terms.id)
      throw StateError('Deposit presentation terms mismatch');
    return Map.unmodifiable({
      'orderId': quote.orderId,
      'deposit': PaymentAmounts.format(quote.deposit, language: language),
      'balance': PaymentAmounts.format(quote.balance, language: language),
      'balanceDueAt': quote.balanceDueAt.toUtc().toIso8601String(),
      'refundable': terms.refundable,
      'cancellationPolicyId': terms.cancellationPolicyId,
      'requiresBackendVerification': true,
    });
  }
}
