import '../trippl_payments_mobile.dart';

class PaymentGuard {
  static void record(List<PaymentIssue> issues) {
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
  }

  static String identity(String value) {
    if (value.isEmpty ||
        value != value.trim() ||
        value.length > 200 ||
        RegExp(r'[\x00-\x1f]').hasMatch(value))
      throw const FormatException('Invalid payment reference');
    return value;
  }

  static void scope(String fingerprint, String scope) {
    identity(scope);
    fingerprintValue(fingerprint);
    if (fingerprint != PaymentCodec.digest(scope))
      throw StateError('Payment account mismatch');
  }

  static void fingerprintValue(String value) {
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(value))
      throw const FormatException('Invalid payment fingerprint');
  }

  static void distinct(Iterable<String> values) {
    final seen = <String>{};
    for (final value in values)
      if (!seen.add(identity(value)))
        throw const FormatException('Payment references repeat');
  }

  static void environment(String value) {
    if (!{'test', 'live'}.contains(value))
      throw const FormatException('Explicit payment environment required');
  }

  static void objectId(String value, String prefix) {
    if (!RegExp(
      '^${RegExp.escape(prefix)}_[A-Za-z0-9]{1,180}\$',
    ).hasMatch(value))
      throw const FormatException('Invalid Stripe reference format');
  }

  static void revision(int actual, int expected) {
    if (actual != expected) throw StateError('Payment revision changed');
  }

  static bool fresh(DateTime observed, DateTime expires, DateTime now) =>
      !observed.isAfter(now) &&
      expires.isAfter(now) &&
      expires.isAfter(observed);
  static Uri https(String text) {
    final uri = Uri.tryParse(text);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.port != 443 ||
        uri.hasFragment ||
        uri.queryParameters.keys.any(
          (k) => {
            'client_secret',
            'secret',
            'token',
            'access_token',
            'api_key',
            'apikey',
            'key',
          }.contains(k.toLowerCase()),
        ))
      throw const FormatException('Use credential-free HTTPS payment links');
    return uri;
  }

  static void language(String value) {
    if (!RegExp(r'^[a-z]{2,3}(?:-[A-Za-z]{2,4})?$').hasMatch(value))
      throw const FormatException('Invalid payment language');
  }

  static Object? inspect(
    Object? value, {
    int depth = 0,
    Set<Object>? ancestors,
  }) {
    if (depth > 16)
      throw const FormatException('Payment input nesting exceeds capacity');
    if (value == null || value is bool || value is int) return value;
    if (value is double) {
      if (!value.isFinite)
        throw const FormatException('Nonfinite payment value');
      return value;
    }
    if (value is String) {
      if (value.length > 100000)
        throw const FormatException('Payment text exceeds capacity');
      return value;
    }
    final seen = ancestors ?? Set<Object>.identity();
    if (!seen.add(value))
      throw const FormatException('Payment input contains a cycle');
    try {
      if (value is List) {
        if (value.length > 1000)
          throw const FormatException('Payment list exceeds capacity');
        return [
          for (final v in value) inspect(v, depth: depth + 1, ancestors: seen),
        ];
      }
      if (value is Map) {
        if (value.length > 100 || value.keys.any((k) => k is! String))
          throw const FormatException('Payment object keys invalid');
        return {
          for (final e in value.entries)
            e.key as String: inspect(
              e.value,
              depth: depth + 1,
              ancestors: seen,
            ),
        };
      }
      throw const FormatException('Unsupported payment input type');
    } finally {
      seen.remove(value);
    }
  }

  static Map<String, Object?> object(Object? value) =>
      PaymentCodec.object(inspect(value));
  static void noSensitiveKeys(Object? input) {
    final value = inspect(input);
    void scan(Object? item) {
      if (item is Map) {
        for (final e in item.entries) {
          final key = (e.key as String)
              .toLowerCase()
              .replaceAll('_', '')
              .replaceAll('-', '');
          if ({
            'clientsecret',
            'ephemeralkey',
            'customerEphemeralKeySecret'.toLowerCase(),
            'secretkey',
            'cardnumber',
            'pan',
            'cvc',
            'cvv',
            'password',
            'accessToken'.toLowerCase(),
          }.contains(key))
            throw const FormatException(
              'Sensitive fields are not permitted in payment records',
            );
          scan(e.value);
        }
      } else if (item is List) {
        for (final v in item) scan(v);
      }
    }

    scan(value);
  }
}
