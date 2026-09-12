Map<String, dynamic> parsePaymentError(dynamic error) {
  if (error == null) {
    return _paymentErrorResult(
      type: 'unknown',
      code: 'unknown_error',
      message: 'An unknown payment error occurred.',
      retryable: false,
    );
  }

  final data = _errorMap(error);

  final rawCode = _firstErrorValue(
    data,
    [
      'code',
      'errorCode',
      'decline_code',
      'declineCode',
    ],
  );

  final rawType = _firstErrorValue(
    data,
    [
      'type',
      'errorType',
    ],
  );

  final rawMessage = _firstErrorValue(
    data,
    [
      'message',
      'localizedMessage',
      'errorMessage',
      'description',
    ],
  );

  final normalizedCode = _normalizeErrorCode(
    rawCode.isNotEmpty ? rawCode : rawMessage,
  );

  final category = _paymentErrorCategory(
    normalizedCode,
    rawType,
    rawMessage,
  );

  final retryable = _isRetryablePaymentError(
    normalizedCode,
    category,
  );

  final userAction = _paymentErrorAction(
    normalizedCode,
    category,
  );

  return {
    'type': category,
    'code': normalizedCode,
    'rawCode': rawCode,
    'message': rawMessage.isNotEmpty
        ? rawMessage
        : _defaultPaymentErrorMessage(category),
    'retryable': retryable,
    'userAction': userAction,
    'requiresNewPaymentMethod':
        category == 'card_declined' ||
        category == 'payment_method',
    'authenticationRequired':
        category == 'authentication',
    'networkRelated': category == 'network',
  };
}

Map<String, dynamic> _errorMap(dynamic error) {
  if (error is Map) {
    return error.map(
      (key, value) => MapEntry(key.toString(), value),
    );
  }

  return {
    'message': error.toString(),
  };
}

String _firstErrorValue(
  Map<String, dynamic> data,
  List<String> keys,
) {
  for (final key in keys) {
    final value = data[key];

    if (value == null) {
      continue;
    }

    final text = value.toString().trim();

    if (text.isNotEmpty && text != 'null') {
      return text;
    }
  }

  final nestedError = data['error'];

  if (nestedError is Map) {
    final nested = nestedError.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    for (final key in keys) {
      final value = nested[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
  }

  return '';
}

String _normalizeErrorCode(String value) {
  final text = value
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (text.contains('insufficient')) {
    return 'insufficient_funds';
  }

  if (text.contains('declin')) {
    return 'card_declined';
  }

  if (text.contains('expired')) {
    return 'expired_card';
  }

  if (text.contains('incorrect_cvc') ||
      text.contains('incorrect_security') ||
      text.contains('security_code')) {
    return 'incorrect_cvc';
  }

  if (text.contains('authentication') ||
      text.contains('3d_secure') ||
      text.contains('3ds')) {
    return 'authentication_required';
  }

  if (text.contains('network') ||
      text.contains('connection') ||
      text.contains('timeout')) {
    return 'network_error';
  }

  if (text.contains('cancel')) {
    return 'payment_cancelled';
  }

  if (text.contains('processing')) {
    return 'processing_error';
  }

  if (text.isEmpty) {
    return 'unknown_error';
  }

  return text.length > 80
      ? 'payment_error'
      : text;
}

String _paymentErrorCategory(
  String code,
  String type,
  String message,
) {
  final combined =
      '$code $type $message'.toLowerCase();

  if (combined.contains('insufficient_funds')) {
    return 'card_declined';
  }

  if (combined.contains('declin')) {
    return 'card_declined';
  }

  if (combined.contains('expired_card')) {
    return 'payment_method';
  }

  if (combined.contains('incorrect_cvc')) {
    return 'payment_method';
  }

  if (combined.contains('authentication') ||
      combined.contains('3d_secure')) {
    return 'authentication';
  }

  if (combined.contains('network') ||
      combined.contains('connection') ||
      combined.contains('timeout')) {
    return 'network';
  }

  if (combined.contains('cancel')) {
    return 'cancelled';
  }

  if (combined.contains('processing')) {
    return 'processing';
  }

  if (combined.contains('invalid_request')) {
    return 'configuration';
  }

  return 'unknown';
}

bool _isRetryablePaymentError(
  String code,
  String category,
) {
  if (category == 'network' ||
      category == 'processing' ||
      category == 'authentication') {
    return true;
  }

  const retryableCodes = {
    'card_declined',
    'insufficient_funds',
    'expired_card',
    'incorrect_cvc',
    'authentication_required',
    'processing_error',
  };

  return retryableCodes.contains(code);
}

String _paymentErrorAction(
  String code,
  String category,
) {
  if (code == 'insufficient_funds') {
    return 'use_different_payment_method';
  }

  if (code == 'expired_card' ||
      code == 'incorrect_cvc') {
    return 'update_payment_method';
  }

  if (category == 'authentication') {
    return 'authenticate_payment';
  }

  if (category == 'network') {
    return 'retry_payment';
  }

  if (category == 'card_declined') {
    return 'use_different_payment_method';
  }

  if (category == 'cancelled') {
    return 'none';
  }

  return 'review_payment';
}

String _defaultPaymentErrorMessage(String category) {
  switch (category) {
    case 'card_declined':
      return 'The payment method was declined.';
    case 'payment_method':
      return 'The payment method could not be used.';
    case 'authentication':
      return 'Additional payment authentication is required.';
    case 'network':
      return 'The payment could not be completed because of a network error.';
    case 'cancelled':
      return 'The payment was cancelled.';
    case 'processing':
      return 'The payment could not be processed.';
    case 'configuration':
      return 'The payment request could not be completed.';
    default:
      return 'The payment could not be completed.';
  }
}

Map<String, dynamic> _paymentErrorResult({
  required String type,
  required String code,
  required String message,
  required bool retryable,
}) {
  return {
    'type': type,
    'code': code,
    'rawCode': '',
    'message': message,
    'retryable': retryable,
    'userAction': 'review_payment',
    'requiresNewPaymentMethod': false,
    'authenticationRequired': false,
    'networkRelated': false,
  };
}
