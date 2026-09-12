Map<String, dynamic> validatePaymentRequest({
  required dynamic amount,
  required dynamic currency,
  dynamic clientSecret,
  dynamic paymentMethodId,
  dynamic bookingReference,
  dynamic serviceType,
  bool requireClientSecret = true,
  bool requirePaymentMethod = false,
}) {
  final errors = <Map<String, dynamic>>[];

  final parsedAmount =
      _validationAmount(amount);

  final currencyCode =
      _validationCurrency(currency);

  if (parsedAmount <= 0) {
    errors.add(
      _validationError(
        field: 'amount',
        code: 'invalid_amount',
        message:
            'Payment amount must be greater than zero.',
      ),
    );
  }

  if (!_isValidPaymentCurrency(currencyCode)) {
    errors.add(
      _validationError(
        field: 'currency',
        code: 'invalid_currency',
        message:
            'A valid supported currency is required.',
      ),
    );
  }

  final secret =
      _validationString(clientSecret);

  if (requireClientSecret &&
      !_isValidClientSecret(secret)) {
    errors.add(
      _validationError(
        field: 'clientSecret',
        code: 'invalid_client_secret',
        message:
            'A valid PaymentIntent client secret is required.',
      ),
    );
  }

  final methodId =
      _validationString(paymentMethodId);

  if (requirePaymentMethod &&
      !_isValidPaymentMethodId(methodId)) {
    errors.add(
      _validationError(
        field: 'paymentMethodId',
        code: 'invalid_payment_method',
        message:
            'A valid payment method is required.',
      ),
    );
  }

  final booking =
      _validationString(bookingReference);

  if (booking.length > 100) {
    errors.add(
      _validationError(
        field: 'bookingReference',
        code: 'booking_reference_too_long',
        message:
            'Booking reference exceeds the supported length.',
      ),
    );
  }

  final normalizedService =
      _validationServiceType(serviceType);

  return {
    'valid': errors.isEmpty,
    'errors': errors,
    'errorCount': errors.length,
    'amount': _validationRound(parsedAmount),
    'currency': currencyCode,
    'clientSecretPresent': secret.isNotEmpty,
    'paymentMethodPresent': methodId.isNotEmpty,
    'bookingReference': booking,
    'serviceType': normalizedService,
  };
}

Map<String, dynamic> validatePaymentCompletion({
  dynamic paymentIntentId,
  dynamic status,
  dynamic amountReceived,
  dynamic expectedAmount,
  dynamic currency,
}) {
  final errors = <Map<String, dynamic>>[];

  final intentId =
      _validationString(paymentIntentId);

  if (!_isValidPaymentIntentId(intentId)) {
    errors.add(
      _validationError(
        field: 'paymentIntentId',
        code: 'invalid_payment_intent',
        message:
            'A valid PaymentIntent identifier is required.',
      ),
    );
  }

  final normalizedStatus =
      _validationString(status)
          .toLowerCase()
          .replaceAll('-', '_')
          .replaceAll(' ', '_');

  const successfulStatuses = {
    'succeeded',
    'paid',
    'completed',
  };

  if (!successfulStatuses.contains(
    normalizedStatus,
  )) {
    errors.add(
      _validationError(
        field: 'status',
        code: 'payment_not_completed',
        message:
            'The payment has not reached a completed state.',
      ),
    );
  }

  final received =
      _validationAmount(amountReceived);

  final expected =
      _validationAmount(expectedAmount);

  if (expected > 0 && received < expected) {
    errors.add(
      _validationError(
        field: 'amountReceived',
        code: 'amount_mismatch',
        message:
            'The received payment amount is below the expected amount.',
      ),
    );
  }

  final currencyCode =
      _validationCurrency(currency);

  if (!_isValidPaymentCurrency(currencyCode)) {
    errors.add(
      _validationError(
        field: 'currency',
        code: 'invalid_currency',
        message:
            'The payment currency is invalid.',
      ),
    );
  }

  return {
    'valid': errors.isEmpty,
    'errors': errors,
    'paymentIntentId': intentId,
    'status': normalizedStatus,
    'amountReceived':
        _validationRound(received),
    'expectedAmount':
        _validationRound(expected),
    'currency': currencyCode,
    'amountMatched':
        expected <= 0 || received >= expected,
  };
}

Map<String, dynamic> validateCardExpiry({
  required dynamic month,
  required dynamic year,
}) {
  final parsedMonth =
      _validationInteger(month);

  var parsedYear =
      _validationInteger(year);

  if (parsedYear > 0 && parsedYear < 100) {
    parsedYear += 2000;
  }

  final errors = <String>[];

  if (parsedMonth < 1 || parsedMonth > 12) {
    errors.add('invalid_expiry_month');
  }

  if (parsedYear < 2000) {
    errors.add('invalid_expiry_year');
  }

  if (errors.isEmpty) {
    final now = DateTime.now();

    if (parsedYear < now.year ||
        (parsedYear == now.year &&
            parsedMonth < now.month)) {
      errors.add('card_expired');
    }
  }

  return {
    'valid': errors.isEmpty,
    'month': parsedMonth,
    'year': parsedYear,
    'errors': errors,
    'expired':
        errors.contains('card_expired'),
  };
}

bool _isValidClientSecret(String value) {
  if (value.isEmpty) {
    return false;
  }

  return value.startsWith('pi_') &&
      value.contains('_secret_') &&
      value.length > 20;
}

bool _isValidPaymentMethodId(String value) {
  if (value.isEmpty) {
    return false;
  }

  return value.startsWith('pm_') &&
      value.length > 5;
}

bool _isValidPaymentIntentId(String value) {
  if (value.isEmpty) {
    return false;
  }

  return value.startsWith('pi_') &&
      !value.contains('_secret_') &&
      value.length > 5;
}

bool _isValidPaymentCurrency(String value) {
  const supported = {
    'AED',
    'AUD',
    'BRL',
    'CAD',
    'CHF',
    'CNY',
    'CZK',
    'DKK',
    'EUR',
    'GBP',
    'HKD',
    'HUF',
    'INR',
    'JPY',
    'KRW',
    'MXN',
    'NOK',
    'NZD',
    'PLN',
    'RON',
    'SEK',
    'SGD',
    'THB',
    'TRY',
    'USD',
    'ZAR',
  };

  return supported.contains(value);
}

String _validationCurrency(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim().toUpperCase();
}

String _validationServiceType(dynamic value) {
  final type = _validationString(value)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  const known = {
    'flight',
    'hotel',
    'activity',
    'transport',
    'esim',
    'visa',
    'tripplpass',
  };

  if (known.contains(type)) {
    return type;
  }

  return type.isEmpty ? 'travel' : type;
}

Map<String, dynamic> _validationError({
  required String field,
  required String code,
  required String message,
}) {
  return {
    'field': field,
    'code': code,
    'message': message,
  };
}

double _validationAmount(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    final parsed = value.toDouble();

    return parsed.isFinite ? parsed : 0;
  }

  final parsed =
      double.tryParse(value.toString());

  return parsed != null && parsed.isFinite
      ? parsed
      : 0;
}

int _validationInteger(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

String _validationString(dynamic value) {
  if (value == null) {
    return '';
  }

  final text = value.toString().trim();

  return text == 'null' ? '' : text;
}

double _validationRound(double value) {
  return (value * 100).round() / 100;
}
