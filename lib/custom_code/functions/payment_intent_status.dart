Map<String, dynamic> normalizePaymentIntentStatus(
  dynamic status, {
  dynamic lastPaymentError,
}) {
  final normalized = _normalizePaymentStatus(status);

  switch (normalized) {
    case 'succeeded':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'paid',
        completed: true,
        pending: false,
        failed: false,
        retryable: false,
        requiresUserAction: false,
      );

    case 'processing':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'processing',
        completed: false,
        pending: true,
        failed: false,
        retryable: false,
        requiresUserAction: false,
      );

    case 'requires_action':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'authentication_required',
        completed: false,
        pending: true,
        failed: false,
        retryable: true,
        requiresUserAction: true,
      );

    case 'requires_confirmation':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'confirmation_required',
        completed: false,
        pending: true,
        failed: false,
        retryable: true,
        requiresUserAction: false,
      );

    case 'requires_payment_method':
      final hasError = lastPaymentError != null;

      return _paymentStatusResult(
        rawStatus: normalized,
        state: hasError
            ? 'payment_method_failed'
            : 'payment_method_required',
        completed: false,
        pending: false,
        failed: hasError,
        retryable: true,
        requiresUserAction: true,
      );

    case 'requires_capture':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'authorized',
        completed: false,
        pending: true,
        failed: false,
        retryable: false,
        requiresUserAction: false,
      );

    case 'canceled':
    case 'cancelled':
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'cancelled',
        completed: false,
        pending: false,
        failed: true,
        retryable: true,
        requiresUserAction: false,
      );

    default:
      return _paymentStatusResult(
        rawStatus: normalized,
        state: 'unknown',
        completed: false,
        pending: false,
        failed: false,
        retryable: false,
        requiresUserAction: false,
      );
  }
}

bool isPaymentIntentSuccessful(dynamic status) {
  return _normalizePaymentStatus(status) == 'succeeded';
}

bool isPaymentIntentPending(dynamic status) {
  const pendingStates = {
    'processing',
    'requires_action',
    'requires_confirmation',
    'requires_capture',
  };

  return pendingStates.contains(
    _normalizePaymentStatus(status),
  );
}

bool paymentIntentRequiresAction(dynamic status) {
  final normalized = _normalizePaymentStatus(status);

  return normalized == 'requires_action' ||
      normalized == 'requires_payment_method';
}

String paymentIntentStatusLabel(
  dynamic status, {
  String languageCode = 'en',
}) {
  final state = normalizePaymentIntentStatus(status);
  final appState = state['state']?.toString() ?? 'unknown';

  final language = languageCode.toLowerCase();

  if (language == 'tr') {
    const labels = {
      'paid': 'Ödeme tamamlandı',
      'processing': 'Ödeme işleniyor',
      'authentication_required': 'Doğrulama gerekli',
      'confirmation_required': 'Onay gerekli',
      'payment_method_required': 'Ödeme yöntemi gerekli',
      'payment_method_failed': 'Ödeme yöntemi başarısız',
      'authorized': 'Ödeme onaylandı',
      'cancelled': 'Ödeme iptal edildi',
      'unknown': 'Ödeme durumu bilinmiyor',
    };

    return labels[appState] ?? labels['unknown']!;
  }

  const labels = {
    'paid': 'Payment completed',
    'processing': 'Payment processing',
    'authentication_required': 'Authentication required',
    'confirmation_required': 'Confirmation required',
    'payment_method_required': 'Payment method required',
    'payment_method_failed': 'Payment method failed',
    'authorized': 'Payment authorized',
    'cancelled': 'Payment cancelled',
    'unknown': 'Payment status unknown',
  };

  return labels[appState] ?? labels['unknown']!;
}

Map<String, dynamic> _paymentStatusResult({
  required String rawStatus,
  required String state,
  required bool completed,
  required bool pending,
  required bool failed,
  required bool retryable,
  required bool requiresUserAction,
}) {
  return {
    'rawStatus': rawStatus,
    'state': state,
    'completed': completed,
    'pending': pending,
    'failed': failed,
    'retryable': retryable,
    'requiresUserAction': requiresUserAction,
    'terminal': completed || state == 'cancelled',
  };
}

String _normalizePaymentStatus(dynamic status) {
  if (status == null) {
    return '';
  }

  return status
      .toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
}
