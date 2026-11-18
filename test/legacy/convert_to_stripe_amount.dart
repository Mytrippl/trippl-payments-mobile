// Exact production helper bodies; FlutterFlow imports supplied by the host.

int? convertToStripeAmount(double? amount, String? currency) {
  if (amount == null || currency == null) return 0;

  // currencies with no decimals
  final noDecimalCurrencies = ['JPY', 'KRW'];

  final multiplier = noDecimalCurrencies.contains(currency.toUpperCase())
      ? 1
      : 100;

  return (amount * multiplier).round();
}
