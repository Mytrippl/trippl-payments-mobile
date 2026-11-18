// Exact production helper bodies; FlutterFlow imports supplied by the host.

// Navigation marker only. Confirm the payment through the backend.
bool isStripePaymentSuccessURL(String currentUrl) {
  final uri = Uri.tryParse(currentUrl);
  return uri != null &&
      {'https', 'mytrippl'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      uri.path == '/stripe-payment-success';
}
