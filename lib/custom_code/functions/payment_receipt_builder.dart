Map<String, dynamic> buildPaymentReceipt({
  required dynamic paymentId,
  required dynamic amount,
  required dynamic currency,
  dynamic bookingReference,
  dynamic serviceType,
  dynamic paymentStatus,
  dynamic paymentMethod,
  dynamic subtotal,
  dynamic taxes,
  dynamic fees,
  dynamic discount,
  dynamic creditsApplied,
  dynamic createdAt,
}) {
  final totalAmount = _receiptAmount(amount);
  final subtotalAmount = subtotal == null
      ? totalAmount
      : _receiptAmount(subtotal);

  final taxAmount = _receiptPositiveAmount(taxes);
  final feeAmount = _receiptPositiveAmount(fees);
  final discountAmount =
      _receiptPositiveAmount(discount);
  final creditsAmount =
      _receiptPositiveAmount(creditsApplied);

  final normalizedCurrency =
      _receiptCurrency(currency);

  final timestamp = _receiptDate(createdAt);

  final methodSummary =
      _receiptPaymentMethod(paymentMethod);

  return {
    'paymentId': _receiptString(paymentId),
    'bookingReference':
        _receiptString(bookingReference),
    'serviceType':
        _normalizeReceiptServiceType(serviceType),
    'status':
        _normalizeReceiptStatus(paymentStatus),
    'currency': normalizedCurrency,
    'subtotal': _receiptRound(subtotalAmount),
    'taxes': _receiptRound(taxAmount),
    'fees': _receiptRound(feeAmount),
    'discount': _receiptRound(discountAmount),
    'creditsApplied':
        _receiptRound(creditsAmount),
    'total': _receiptRound(totalAmount),
    'paymentMethod': methodSummary,
    'createdAt': timestamp.toIso8601String(),
    'date': _receiptDateText(timestamp),
    'time': _receiptTimeText(timestamp),
    'paid': _normalizeReceiptStatus(
          paymentStatus,
        ) ==
        'paid',
    'hasAdjustments':
        taxAmount > 0 ||
        feeAmount > 0 ||
        discountAmount > 0 ||
        creditsAmount > 0,
  };
}

Map<String, dynamic> buildPaymentReceiptLineItems({
  required dynamic subtotal,
  dynamic taxes,
  dynamic fees,
  dynamic discount,
  dynamic creditsApplied,
  required dynamic total,
  required dynamic currency,
}) {
  final code = _receiptCurrency(currency);

  final items = <Map<String, dynamic>>[];

  final subtotalValue = _receiptAmount(subtotal);
  final taxValue = _receiptPositiveAmount(taxes);
  final feeValue = _receiptPositiveAmount(fees);
  final discountValue =
      _receiptPositiveAmount(discount);
  final creditsValue =
      _receiptPositiveAmount(creditsApplied);
  final totalValue = _receiptAmount(total);

  items.add(
    _receiptLineItem(
      key: 'subtotal',
      label: 'Subtotal',
      amount: subtotalValue,
      currency: code,
      deduction: false,
    ),
  );

  if (taxValue > 0) {
    items.add(
      _receiptLineItem(
        key: 'taxes',
        label: 'Taxes',
        amount: taxValue,
        currency: code,
        deduction: false,
      ),
    );
  }

  if (feeValue > 0) {
    items.add(
      _receiptLineItem(
        key: 'fees',
        label: 'Fees',
        amount: feeValue,
        currency: code,
        deduction: false,
      ),
    );
  }

  if (discountValue > 0) {
    items.add(
      _receiptLineItem(
        key: 'discount',
        label: 'Discount',
        amount: discountValue,
        currency: code,
        deduction: true,
      ),
    );
  }

  if (creditsValue > 0) {
    items.add(
      _receiptLineItem(
        key: 'credits',
        label: 'Credits',
        amount: creditsValue,
        currency: code,
        deduction: true,
      ),
    );
  }

  items.add(
    _receiptLineItem(
      key: 'total',
      label: 'Total',
      amount: totalValue,
      currency: code,
      deduction: false,
    ),
  );

  return {
    'currency': code,
    'items': items,
    'itemCount': items.length,
    'total': _receiptRound(totalValue),
  };
}

Map<String, dynamic> _receiptLineItem({
  required String key,
  required String label,
  required double amount,
  required String currency,
  required bool deduction,
}) {
  return {
    'key': key,
    'label': label,
    'amount': _receiptRound(amount),
    'currency': currency,
    'deduction': deduction,
    'signedAmount':
        deduction ? -_receiptRound(amount) : _receiptRound(amount),
  };
}

Map<String, dynamic> _receiptPaymentMethod(
  dynamic value,
) {
  if (value is Map) {
    final mapped = value.map(
      (key, item) => MapEntry(
        key.toString(),
        item,
      ),
    );

    return {
      'type': _receiptString(mapped['type']),
      'brand': _receiptString(mapped['brand']),
      'last4': _receiptString(mapped['last4']),
      'walletType':
          _receiptString(mapped['walletType']),
      'displayName':
          _receiptString(mapped['displayName']),
    };
  }

  if (value == null) {
    return {
      'type': '',
      'brand': '',
      'last4': '',
      'walletType': '',
      'displayName': '',
    };
  }

  return {
    'type': '',
    'brand': '',
    'last4': '',
    'walletType': '',
    'displayName': value.toString(),
  };
}

String _normalizeReceiptStatus(dynamic value) {
  final status = _receiptString(value)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (status == 'succeeded' ||
      status == 'success' ||
      status == 'completed' ||
      status == 'paid') {
    return 'paid';
  }

  if (status == 'processing' ||
      status == 'pending') {
    return 'processing';
  }

  if (status == 'failed' ||
      status == 'declined') {
    return 'failed';
  }

  if (status == 'cancelled' ||
      status == 'canceled') {
    return 'cancelled';
  }

  if (status == 'refunded') {
    return 'refunded';
  }

  return status.isEmpty ? 'unknown' : status;
}

String _normalizeReceiptServiceType(dynamic value) {
  final text = _receiptString(value)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  const supported = {
    'flight',
    'hotel',
    'activity',
    'transport',
    'esim',
    'visa',
    'tripplpass',
  };

  return supported.contains(text)
      ? text
      : text.isEmpty
          ? 'travel'
          : text;
}

DateTime _receiptDate(dynamic value) {
  if (value is DateTime) {
    return value;
  }

  if (value is int) {
    final milliseconds =
        value < 100000000000 ? value * 1000 : value;

    return DateTime.fromMillisecondsSinceEpoch(
      milliseconds,
    );
  }

  if (value is String) {
    final parsed = DateTime.tryParse(value);

    if (parsed != null) {
      return parsed;
    }
  }

  return DateTime.now();
}

String _receiptDateText(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month =
      value.month.toString().padLeft(2, '0');

  return '$day/$month/${value.year}';
}

String _receiptTimeText(DateTime value) {
  final hour =
      value.hour.toString().padLeft(2, '0');
  final minute =
      value.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}

double _receiptAmount(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

double _receiptPositiveAmount(dynamic value) {
  final amount = _receiptAmount(value);

  return amount < 0 ? 0 : amount;
}

double _receiptRound(double value) {
  return (value * 100).round() / 100;
}

String _receiptCurrency(dynamic value) {
  final code =
      _receiptString(value).toUpperCase();

  return RegExp(r'^[A-Z]{3}$').hasMatch(code)
      ? code
      : 'GBP';
}

String _receiptString(dynamic value) {
  if (value == null) {
    return '';
  }

  final text = value.toString().trim();

  return text == 'null' ? '' : text;
}
