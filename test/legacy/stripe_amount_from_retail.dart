// Exact production helper bodies; FlutterFlow imports supplied by the host.

int stripeAmountFromRetail(dynamic json) {
  if (json == null) return 0;

  dynamic retail = json["retailPrice"];
  if (retail == null) return 0;

  double price;

  if (retail is num) {
    price = retail.toDouble();
  } else {
    price = double.tryParse(retail.toString()) ?? 0;
  }

  // Convert to smallest currency unit (cents, kuruş, etc.)
  int amountInSmallestUnit = (price * 100).round();

  return amountInSmallestUnit;
}
