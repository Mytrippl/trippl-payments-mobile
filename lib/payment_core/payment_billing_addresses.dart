import '../trippl_payments_mobile.dart';

class PaymentBillingAddresses {
  static String postal(String value, String country) {
    final input = value.trim().toUpperCase();
    if (input.length > 20 || RegExp(r'[\x00-\x1f]').hasMatch(input)) {
      throw const FormatException('Postal code exceeds allowed format');
    }
    return {'GB', 'CA'}.contains(country)
        ? input.replaceAll(RegExp(r'\s+'), ' ')
        : input;
  }

  static PaymentBillingValidation assess(
    PaymentBillingAddress address,
    PaymentCountryAddressRule rule, {
    required DateTime now,
  }) {
    PaymentGuard.record(rule.validate());
    PaymentAccountGuard.current(
      rule.observedAt,
      rule.expiresAt,
      rule.serverVerified,
      now,
    );
    final missing = <String>[], reasons = <String>[];
    if (address.countryCode != rule.countryCode)
      reasons.add('countryRuleMismatch');
    if (address.updatedAt.isAfter(now)) reasons.add('addressClockInvalid');
    if (address.revision < 1) reasons.add('addressRevisionInvalid');
    if (rule.line1Required && address.line1.trim().isEmpty)
      missing.add('line1');
    if (rule.cityRequired && address.city.trim().isEmpty) missing.add('city');
    if (rule.regionRequired && (address.regionCode?.trim().isEmpty ?? true))
      missing.add('regionCode');
    if (rule.postalCodeRequired && (address.postalCode?.trim().isEmpty ?? true))
      missing.add('postalCode');
    for (final line in [address.line1, address.line2, address.city]) {
      if (line != null &&
          (line.length > rule.maximumLineLength ||
              RegExp(r'[\x00-\x1f]').hasMatch(line)))
        reasons.add('addressLineInvalid');
    }
    if (address.regionCode != null &&
        rule.allowedRegionCodes.isNotEmpty &&
        !rule.allowedRegionCodes.contains(address.regionCode))
      reasons.add('regionNotAllowed');
    final code = address.postalCode == null
        ? 'unknown'
        : postal(address.postalCode!, address.countryCode);
    final pattern = switch (rule.postalPattern) {
      'digits' => r'^\d{3,12}$',
      'alphanumeric' => r'^[A-Z0-9 -]{2,16}$',
      'us' => r'^\d{5}(?:-\d{4})?$',
      'ca' => r'^[A-Z]\d[A-Z] ?\d[A-Z]\d$',
      'uk' => r'^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$',
      _ => null,
    };
    if (address.postalCode != null &&
        pattern != null &&
        !RegExp(pattern).hasMatch(code))
      reasons.add('postalFormatInvalid');
    return PaymentBillingValidation(
      addressId: address.id,
      evaluatedAt: now,
      ruleRevision: rule.revision,
      valid: missing.isEmpty && reasons.isEmpty,
      missingFields: missing,
      reasonCodes: reasons.toSet().toList(),
      normalizedPostalCode: code,
    );
  }

  static PaymentBillingAddress normalize(
    PaymentBillingAddress address,
    PaymentCountryAddressRule rule, {
    required DateTime now,
  }) {
    final value = address.copyWith(
      line1: address.line1.trim(),
      line2: address.line2?.trim(),
      city: address.city.trim(),
      postalCode: address.postalCode == null
          ? null
          : postal(address.postalCode!, address.countryCode),
    );
    PaymentGuard.record(value.validate());
    if (!assess(value, rule, now: now).valid)
      throw StateError('Billing address requires correction');
    return value;
  }
}
