Map<String, dynamic> buildPaymentMethodSummary(
  dynamic paymentMethod,
) {
  if (paymentMethod == null) {
    return _emptyPaymentMethodSummary();
  }

  final data = _paymentMethodMap(paymentMethod);

  final type = _paymentMethodType(data);

  final card = _nestedPaymentMap(
    data,
    'card',
  );

  final billingDetails = _nestedPaymentMap(
    data,
    'billing_details',
  );

  final wallet = _nestedPaymentMap(
    card,
    'wallet',
  );

  final brand = _paymentString(
    card['brand'],
  ).toLowerCase();

  final last4 = _paymentString(
    card['last4'],
  );

  final expMonth = _paymentInteger(
    card['exp_month'],
  );

  final expYear = _paymentInteger(
    card['exp_year'],
  );

  final walletType = _paymentString(
    wallet['type'],
  ).toLowerCase();

  final displayName = _paymentMethodDisplayName(
    type: type,
    brand: brand,
    walletType: walletType,
  );

  return {
    'id': _paymentString(data['id']),
    'type': type,
    'displayName': displayName,
    'brand': brand,
    'brandLabel': _cardBrandLabel(brand),
    'last4': last4,
    'maskedNumber':
        last4.isEmpty ? '' : '•••• $last4',
    'expMonth': expMonth,
    'expYear': expYear,
    'expiryText': _expiryText(
      expMonth,
      expYear,
    ),
    'walletType': walletType,
    'isWallet': walletType.isNotEmpty,
    'isApplePay': walletType == 'apple_pay',
    'isGooglePay': walletType == 'google_pay',
    'cardPresent': card.isNotEmpty,
    'billingName':
        _paymentString(billingDetails['name']),
    'billingEmail':
        _paymentString(billingDetails['email']),
    'billingPhone':
        _paymentString(billingDetails['phone']),
    'country': _paymentString(
      card['country'],
    ).toUpperCase(),
    'funding': _paymentString(
      card['funding'],
    ).toLowerCase(),
    'fingerprint':
        _paymentString(card['fingerprint']),
    'expired': _isPaymentCardExpired(
      expMonth,
      expYear,
    ),
  };
}

String paymentMethodDisplayText(
  dynamic paymentMethod,
) {
  final summary =
      buildPaymentMethodSummary(paymentMethod);

  final displayName =
      summary['displayName']?.toString() ?? '';

  final maskedNumber =
      summary['maskedNumber']?.toString() ?? '';

  if (displayName.isEmpty && maskedNumber.isEmpty) {
    return 'Payment method';
  }

  if (maskedNumber.isEmpty) {
    return displayName;
  }

  if (displayName.isEmpty) {
    return maskedNumber;
  }

  return '$displayName $maskedNumber';
}

Map<String, dynamic> _paymentMethodMap(dynamic value) {
  if (value is Map) {
    return value.map(
      (key, item) => MapEntry(
        key.toString(),
        item,
      ),
    );
  }

  return {};
}

Map<String, dynamic> _nestedPaymentMap(
  Map<String, dynamic> source,
  String key,
) {
  final value = source[key];

  if (value is Map) {
    return value.map(
      (nestedKey, nestedValue) => MapEntry(
        nestedKey.toString(),
        nestedValue,
      ),
    );
  }

  return {};
}

String _paymentMethodType(
  Map<String, dynamic> data,
) {
  final direct =
      _paymentString(data['type']).toLowerCase();

  if (direct.isNotEmpty) {
    return direct;
  }

  if (data['card'] != null) {
    return 'card';
  }

  if (data['paypal'] != null) {
    return 'paypal';
  }

  return 'unknown';
}

String _paymentMethodDisplayName({
  required String type,
  required String brand,
  required String walletType,
}) {
  if (walletType == 'apple_pay') {
    return 'Apple Pay';
  }

  if (walletType == 'google_pay') {
    return 'Google Pay';
  }

  if (type == 'card') {
    final brandLabel = _cardBrandLabel(brand);

    if (brandLabel.isNotEmpty) {
      return brandLabel;
    }

    return 'Card';
  }

  if (type == 'paypal') {
    return 'PayPal';
  }

  if (type.isEmpty || type == 'unknown') {
    return 'Payment method';
  }

  return type
      .split('_')
      .map(
        (part) => part.isEmpty
            ? ''
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}

String _cardBrandLabel(String brand) {
  switch (brand) {
    case 'visa':
      return 'Visa';
    case 'mastercard':
      return 'Mastercard';
    case 'amex':
    case 'american_express':
      return 'American Express';
    case 'discover':
      return 'Discover';
    case 'diners':
      return 'Diners Club';
    case 'jcb':
      return 'JCB';
    case 'unionpay':
      return 'UnionPay';
    default:
      return brand.isEmpty ? '' : brand;
  }
}

String _expiryText(
  int month,
  int year,
) {
  if (month <= 0 || year <= 0) {
    return '';
  }

  final monthText =
      month.toString().padLeft(2, '0');

  final yearText = year
      .toString()
      .padLeft(4, '0');

  return '$monthText/${yearText.substring(yearText.length - 2)}';
}

bool _isPaymentCardExpired(
  int month,
  int year,
) {
  if (month <= 0 || year <= 0) {
    return false;
  }

  final now = DateTime.now();

  if (year < now.year) {
    return true;
  }

  if (year == now.year && month < now.month) {
    return true;
  }

  return false;
}

String _paymentString(dynamic value) {
  if (value == null) {
    return '';
  }

  final text = value.toString().trim();

  return text == 'null' ? '' : text;
}

int _paymentInteger(dynamic value) {
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

Map<String, dynamic> _emptyPaymentMethodSummary() {
  return {
    'id': '',
    'type': 'unknown',
    'displayName': 'Payment method',
    'brand': '',
    'brandLabel': '',
    'last4': '',
    'maskedNumber': '',
    'expMonth': 0,
    'expYear': 0,
    'expiryText': '',
    'walletType': '',
    'isWallet': false,
    'isApplePay': false,
    'isGooglePay': false,
    'cardPresent': false,
    'billingName': '',
    'billingEmail': '',
    'billingPhone': '',
    'country': '',
    'funding': '',
    'fingerprint': '',
    'expired': false,
  };
}
