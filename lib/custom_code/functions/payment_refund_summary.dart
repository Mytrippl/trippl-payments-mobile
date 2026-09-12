Map<String, dynamic> buildPaymentRefundSummary({
  required dynamic originalAmount,
  required dynamic refundedAmount,
  required dynamic currency,
  dynamic refundStatus,
  dynamic refundReason,
  dynamic refundId,
  dynamic createdAt,
}) {
  final original =
      _refundPositiveAmount(originalAmount);

  var refunded =
      _refundPositiveAmount(refundedAmount);

  if (refunded > original && original > 0) {
    refunded = original;
  }

  final remaining =
      _refundRound((original - refunded).clamp(
    0.0,
    double.infinity,
  ));

  final status = _resolveRefundStatus(
    refundStatus,
    original,
    refunded,
  );

  final percentage = original <= 0
      ? 0.0
      : _refundRound(
          (refunded / original) * 100,
        );

  return {
    'refundId': _refundString(refundId),
    'currency': _refundCurrency(currency),
    'originalAmount': _refundRound(original),
    'refundedAmount': _refundRound(refunded),
    'remainingAmount': remaining,
    'refundPercentage': percentage,
    'status': status,
    'reason': _normalizeRefundReason(refundReason),
    'hasRefund': refunded > 0,
    'fullyRefunded':
        status == 'fully_refunded',
    'partiallyRefunded':
        status == 'partially_refunded',
    'pending': status == 'pending',
    'failed': status == 'failed',
    'createdAt':
        _refundDateString(createdAt),
  };
}

Map<String, dynamic> calculateRefundEligibility({
  required dynamic paidAmount,
  dynamic alreadyRefunded,
  dynamic requestedRefund,
  bool refundable = true,
}) {
  final paid = _refundPositiveAmount(paidAmount);
  final already =
      _refundPositiveAmount(alreadyRefunded);

  final available = _refundRound(
    (paid - already).clamp(
      0.0,
      double.infinity,
    ),
  );

  final requested =
      _refundPositiveAmount(requestedRefund);

  final errors = <String>[];

  if (!refundable) {
    errors.add('payment_not_refundable');
  }

  if (paid <= 0) {
    errors.add('no_paid_amount');
  }

  if (available <= 0) {
    errors.add('no_refundable_balance');
  }

  if (requested <= 0) {
    errors.add('invalid_refund_amount');
  }

  if (requested > available) {
    errors.add('refund_exceeds_available_amount');
  }

  return {
    'eligible': errors.isEmpty,
    'paidAmount': _refundRound(paid),
    'alreadyRefunded': _refundRound(already),
    'availableToRefund': available,
    'requestedRefund': _refundRound(requested),
    'remainingAfterRefund': requested <= available
        ? _refundRound(available - requested)
        : available,
    'errors': errors,
  };
}

String refundStatusLabel(
  dynamic status, {
  String languageCode = 'en',
}) {
  final normalized = _refundString(status)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (languageCode.toLowerCase() == 'tr') {
    const labels = {
      'not_refunded': 'İade yok',
      'partially_refunded': 'Kısmi iade',
      'fully_refunded': 'Tam iade',
      'pending': 'İade işleniyor',
      'failed': 'İade başarısız',
      'cancelled': 'İade iptal edildi',
    };

    return labels[normalized] ??
        'İade durumu bilinmiyor';
  }

  const labels = {
    'not_refunded': 'Not refunded',
    'partially_refunded': 'Partially refunded',
    'fully_refunded': 'Fully refunded',
    'pending': 'Refund processing',
    'failed': 'Refund failed',
    'cancelled': 'Refund cancelled',
  };

  return labels[normalized] ??
      'Refund status unknown';
}

String _resolveRefundStatus(
  dynamic rawStatus,
  double original,
  double refunded,
) {
  final status = _refundString(rawStatus)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (status.contains('pending')) {
    return 'pending';
  }

  if (status.contains('fail')) {
    return 'failed';
  }

  if (status.contains('cancel')) {
    return 'cancelled';
  }

  if (original > 0 && refunded >= original) {
    return 'fully_refunded';
  }

  if (refunded > 0) {
    return 'partially_refunded';
  }

  return 'not_refunded';
}

String _normalizeRefundReason(dynamic value) {
  final reason = _refundString(value)
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  const knownReasons = {
    'duplicate',
    'fraudulent',
    'requested_by_customer',
    'booking_cancelled',
    'service_unavailable',
    'price_adjustment',
  };

  if (knownReasons.contains(reason)) {
    return reason;
  }

  return reason.isEmpty ? 'unspecified' : reason;
}

String _refundDateString(dynamic value) {
  if (value == null) {
    return '';
  }

  if (value is DateTime) {
    return value.toIso8601String();
  }

  if (value is int) {
    final milliseconds =
        value < 100000000000 ? value * 1000 : value;

    return DateTime.fromMillisecondsSinceEpoch(
      milliseconds,
    ).toIso8601String();
  }

  final parsed =
      DateTime.tryParse(value.toString());

  return parsed?.toIso8601String() ??
      value.toString();
}

double _refundPositiveAmount(dynamic value) {
  double amount;

  if (value is num) {
    amount = value.toDouble();
  } else {
    amount = double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  if (!amount.isFinite || amount < 0) {
    return 0;
  }

  return amount;
}

double _refundRound(num value) {
  return (value * 100).round() / 100;
}

String _refundCurrency(dynamic value) {
  final code =
      _refundString(value).toUpperCase();

  return RegExp(r'^[A-Z]{3}$').hasMatch(code)
      ? code
      : 'GBP';
}

String _refundString(dynamic value) {
  if (value == null) {
    return '';
  }

  final text = value.toString().trim();

  return text == 'null' ? '' : text;
}
