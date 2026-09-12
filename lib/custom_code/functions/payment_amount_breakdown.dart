Map<String, dynamic> buildPaymentAmountBreakdown({
  required dynamic subtotal,
  dynamic discount,
  dynamic taxes,
  dynamic serviceFee,
  dynamic processingFee,
  dynamic creditsApplied,
  String currency = 'GBP',
}) {
  final normalizedCurrency = _normalizeCurrency(currency);

  final subtotalValue = _moneyValue(subtotal);
  final discountValue = _positiveMoney(discount);
  final taxesValue = _positiveMoney(taxes);
  final serviceFeeValue = _positiveMoney(serviceFee);
  final processingFeeValue = _positiveMoney(processingFee);
  final creditsValue = _positiveMoney(creditsApplied);

  final additions =
      taxesValue + serviceFeeValue + processingFeeValue;

  final deductions = discountValue + creditsValue;

  final beforeDeductions = subtotalValue + additions;

  final total = _roundMoney(
    (beforeDeductions - deductions).clamp(0.0, double.infinity),
  );

  final effectiveDiscount = _roundMoney(
    discountValue + creditsValue,
  );

  return {
    'currency': normalizedCurrency,
    'subtotal': _roundMoney(subtotalValue),
    'discount': _roundMoney(discountValue),
    'taxes': _roundMoney(taxesValue),
    'serviceFee': _roundMoney(serviceFeeValue),
    'processingFee': _roundMoney(processingFeeValue),
    'creditsApplied': _roundMoney(creditsValue),
    'additions': _roundMoney(additions),
    'deductions': _roundMoney(deductions),
    'effectiveDiscount': effectiveDiscount,
    'beforeDeductions': _roundMoney(beforeDeductions),
    'total': total,
    'amountDue': total,
    'isFree': total == 0,
    'hasDiscount': discountValue > 0,
    'hasCredits': creditsValue > 0,
    'hasTaxes': taxesValue > 0,
    'hasFees': serviceFeeValue > 0 || processingFeeValue > 0,
    'minorUnitAmount': _toMinorUnits(total, normalizedCurrency),
  };
}

Map<String, dynamic> calculatePaymentAdjustment({
  required dynamic originalAmount,
  required dynamic newAmount,
  String currency = 'GBP',
}) {
  final original = _positiveMoney(originalAmount);
  final updated = _positiveMoney(newAmount);
  final difference = _roundMoney(updated - original);

  String direction;

  if (difference > 0) {
    direction = 'increase';
  } else if (difference < 0) {
    direction = 'decrease';
  } else {
    direction = 'unchanged';
  }

  final percentage = original == 0
      ? 0.0
      : _roundMoney((difference.abs() / original) * 100);

  return {
    'currency': _normalizeCurrency(currency),
    'originalAmount': _roundMoney(original),
    'newAmount': _roundMoney(updated),
    'difference': difference,
    'absoluteDifference': _roundMoney(difference.abs()),
    'direction': direction,
    'percentageChange': percentage,
    'changed': difference != 0,
  };
}

double _moneyValue(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    if (!value.toDouble().isFinite) {
      return 0;
    }

    return value.toDouble();
  }

  if (value is String) {
    var normalized = value.trim();

    if (normalized.isEmpty) {
      return 0;
    }

    normalized = normalized.replaceAll(RegExp(r'[^\d,.\-]'), '');

    if (normalized.contains(',') && normalized.contains('.')) {
      if (normalized.lastIndexOf(',') > normalized.lastIndexOf('.')) {
        normalized = normalized.replaceAll('.', '');
        normalized = normalized.replaceAll(',', '.');
      } else {
        normalized = normalized.replaceAll(',', '');
      }
    } else if (normalized.contains(',')) {
      final pieces = normalized.split(',');

      if (pieces.length == 2 && pieces.last.length <= 2) {
        normalized = normalized.replaceAll(',', '.');
      } else {
        normalized = normalized.replaceAll(',', '');
      }
    }

    return double.tryParse(normalized) ?? 0;
  }

  return 0;
}

double _positiveMoney(dynamic value) {
  final parsed = _moneyValue(value);

  if (parsed < 0) {
    return 0;
  }

  return parsed;
}

double _roundMoney(num value) {
  return (value * 100).round() / 100;
}

String _normalizeCurrency(String value) {
  final normalized = value.trim().toUpperCase();

  if (normalized.length != 3) {
    return 'GBP';
  }

  return normalized;
}

int _toMinorUnits(double amount, String currency) {
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

  if (zeroDecimalCurrencies.contains(currency)) {
    return amount.round();
  }

  return (amount * 100).round();
}
