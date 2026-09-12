Map<String, dynamic> getPaymentCurrencyRules(dynamic currency) {
  final code = _currencyCode(currency);

  const zeroDecimalCurrencies = {
    'BIF',
    'CLP',
    'DJF',
    'GNF',
    'JPY',
    'KMF',
    'KRW',
    'MGA',
    'PYG',
    'RWF',
    'UGX',
    'VND',
    'VUV',
    'XAF',
    'XOF',
    'XPF',
  };

  const supportedCurrencies = {
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

  final zeroDecimal = zeroDecimalCurrencies.contains(code);

  return {
    'currency': code,
    'supported': supportedCurrencies.contains(code),
    'zeroDecimal': zeroDecimal,
    'minorUnitDigits': zeroDecimal ? 0 : 2,
    'minorUnitMultiplier': zeroDecimal ? 1 : 100,
    'symbol': _currencySymbol(code),
  };
}

int paymentAmountToMinorUnits(
  dynamic amount,
  dynamic currency,
) {
  final parsed = _parseCurrencyAmount(amount);

  if (parsed <= 0) {
    return 0;
  }

  final rules = getPaymentCurrencyRules(currency);

  final multiplier =
      (rules['minorUnitMultiplier'] as num?)?.toInt() ?? 100;

  return (parsed * multiplier).round();
}

double paymentAmountFromMinorUnits(
  dynamic amount,
  dynamic currency,
) {
  final parsed = _parseCurrencyAmount(amount);

  final rules = getPaymentCurrencyRules(currency);

  final multiplier =
      (rules['minorUnitMultiplier'] as num?)?.toInt() ?? 100;

  if (multiplier <= 0) {
    return 0;
  }

  return _roundCurrency(parsed / multiplier);
}

Map<String, dynamic> validatePaymentCurrencyAmount({
  required dynamic amount,
  required dynamic currency,
  dynamic minimumAmount,
  dynamic maximumAmount,
}) {
  final code = _currencyCode(currency);
  final parsedAmount = _parseCurrencyAmount(amount);
  final minimum = _parseCurrencyAmount(minimumAmount);
  final maximum = _parseCurrencyAmount(maximumAmount);

  final rules = getPaymentCurrencyRules(code);

  final errors = <String>[];

  if (!(rules['supported'] == true)) {
    errors.add('unsupported_currency');
  }

  if (parsedAmount <= 0) {
    errors.add('invalid_amount');
  }

  if (minimum > 0 && parsedAmount < minimum) {
    errors.add('below_minimum_amount');
  }

  if (maximum > 0 && parsedAmount > maximum) {
    errors.add('above_maximum_amount');
  }

  return {
    'valid': errors.isEmpty,
    'currency': code,
    'amount': _roundCurrency(parsedAmount),
    'minorUnitAmount':
        paymentAmountToMinorUnits(parsedAmount, code),
    'errors': errors,
    'rules': rules,
  };
}

String formatPaymentCurrencyAmount(
  dynamic amount,
  dynamic currency, {
  bool includeCode = false,
}) {
  final code = _currencyCode(currency);
  final parsed = _parseCurrencyAmount(amount);

  final rules = getPaymentCurrencyRules(code);

  final zeroDecimal = rules['zeroDecimal'] == true;
  final symbol = rules['symbol']?.toString() ?? code;

  final amountText = zeroDecimal
      ? parsed.round().toString()
      : parsed.toStringAsFixed(2);

  if (includeCode) {
    return '$symbol$amountText $code';
  }

  return '$symbol$amountText';
}

String _currencyCode(dynamic value) {
  if (value == null) {
    return 'GBP';
  }

  final code = value.toString().trim().toUpperCase();

  if (!RegExp(r'^[A-Z]{3}$').hasMatch(code)) {
    return 'GBP';
  }

  return code;
}

double _parseCurrencyAmount(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    final result = value.toDouble();

    return result.isFinite ? result : 0;
  }

  var text = value.toString().trim();

  if (text.isEmpty) {
    return 0;
  }

  text = text.replaceAll(RegExp(r'[^\d,.\-]'), '');

  if (text.contains(',') && text.contains('.')) {
    if (text.lastIndexOf(',') > text.lastIndexOf('.')) {
      text = text.replaceAll('.', '');
      text = text.replaceAll(',', '.');
    } else {
      text = text.replaceAll(',', '');
    }
  } else if (text.contains(',')) {
    final parts = text.split(',');

    if (parts.length == 2 && parts.last.length <= 2) {
      text = text.replaceAll(',', '.');
    } else {
      text = text.replaceAll(',', '');
    }
  }

  return double.tryParse(text) ?? 0;
}

String _currencySymbol(String code) {
  const symbols = {
    'AED': 'AED ',
    'AUD': 'A\$',
    'BRL': 'R\$',
    'CAD': 'C\$',
    'CHF': 'CHF ',
    'CNY': '¥',
    'CZK': 'Kč ',
    'DKK': 'kr ',
    'EUR': '€',
    'GBP': '£',
    'HKD': 'HK\$',
    'HUF': 'Ft ',
    'INR': '₹',
    'JPY': '¥',
    'KRW': '₩',
    'MXN': 'MX\$',
    'NOK': 'kr ',
    'NZD': 'NZ\$',
    'PLN': 'zł ',
    'RON': 'lei ',
    'SEK': 'kr ',
    'SGD': 'S\$',
    'THB': '฿',
    'TRY': '₺',
    'USD': '\$',
    'ZAR': 'R',
  };

  return symbols[code] ?? '$code ';
}

double _roundCurrency(double value) {
  return (value * 100).round() / 100;
}
