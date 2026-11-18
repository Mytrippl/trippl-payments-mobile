import '../trippl_payments_mobile.dart';

class PaymentForeignExchange {
  static int _rounded(int whole, int remainder, int denominator, String mode) {
    if (mode == 'floor') return whole;
    if (mode == 'ceil') return whole + (remainder > 0 ? 1 : 0);
    if (mode == 'halfUp') return whole + (remainder * 2 >= denominator ? 1 : 0);
    throw const FormatException('FX rounding mode unsupported');
  }

  static PaymentMoney convert(
    PaymentMoney source,
    PaymentFxRate rate, {
    required int targetDecimals,
    required DateTime now,
    String rounding = 'halfUp',
  }) {
    PaymentGuard.record(source.validate());
    PaymentGuard.record(rate.validate());
    PaymentAccountGuard.current(
      rate.observedAt,
      rate.expiresAt,
      rate.serverVerified,
      now,
    );
    PaymentAccountGuard.currencyCode(rate.baseCurrency);
    PaymentAccountGuard.currencyCode(rate.quoteCurrency);
    if (source.currency != rate.baseCurrency)
      throw StateError('FX base currency mismatch');
    final numerator =
        BigInt.from(source.amountMinor) *
        BigInt.from(rate.numerator) *
        BigInt.from(PaymentAmounts.scale(targetDecimals));
    final denominator =
        BigInt.from(rate.denominator) *
        BigInt.from(PaymentAmounts.scale(source.decimals));
    final whole = numerator ~/ denominator, remainder = numerator % denominator;
    if (whole > BigInt.from(9000000000000))
      throw StateError('FX amount exceeds safe range');
    final amount = _rounded(
      whole.toInt(),
      remainder.toInt(),
      denominator.toInt(),
      rounding,
    );
    final result = PaymentMoney(
      currency: rate.quoteCurrency,
      amountMinor: amount,
      decimals: targetDecimals,
    );
    PaymentGuard.record(result.validate());
    return result;
  }

  static PaymentFxDisclosure disclose(
    PaymentFxQuote quote,
    PaymentOrder order, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(quote.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentAccountGuard.context(
      quote.scopeFingerprint,
      quote.environment,
      scope: scope,
      environment: environment,
    );
    PaymentAccountGuard.current(
      quote.observedAt,
      quote.expiresAt,
      quote.serverVerified,
      now,
    );
    if (quote.orderId != order.id || quote.sourceAmount != order.total)
      throw StateError('FX quote order mismatch');
    final converted = convert(
      quote.sourceAmount,
      quote.rate,
      targetDecimals: quote.targetAmount.decimals,
      now: now,
      rounding: quote.rounding,
    );
    if (PaymentAmounts.add(converted, quote.fee) != quote.targetAmount)
      throw StateError('FX quote rate fee and total mismatch');
    return PaymentFxDisclosure(
      quoteId: quote.id,
      orderId: order.id,
      sourceAmount: order.total,
      displayAmount: quote.targetAmount,
      fee: quote.fee,
      expiresAt: PaymentAccountGuard.earliest([
        quote.expiresAt,
        quote.rate.expiresAt,
      ]),
      label: 'Estimated display conversion',
      reasonCodes: ['chargeCurrencyUnchanged'],
    );
  }
}
