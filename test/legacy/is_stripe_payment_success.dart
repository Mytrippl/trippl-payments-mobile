// Exact production helper bodies; FlutterFlow imports supplied by the host.

// Navigation marker only. This is not payment or booking confirmation.
bool isStripePaymentSuccess(String currentUrl) {
  final uri = Uri.tryParse(currentUrl);
  return uri != null &&
      {'https', 'mytrippl'}.contains(uri.scheme) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      uri.queryParametersAll['status']?.length == 1 &&
      uri.queryParameters['status'] == 'success';
}
