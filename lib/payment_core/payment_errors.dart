import '../trippl_payments_mobile.dart';

class PaymentErrors {
  static PaymentError fromCode(
    String code, {
    required DateTime now,
    bool mutationStarted = false,
  }) {
    final normalized = code.trim().toLowerCase().replaceAll('-', '_'),
        known = {
          'canceled',
          'cancelled',
          'card_declined',
          'expired_card',
          'incorrect_cvc',
          'authentication_required',
          'processing_error',
          'api_connection_error',
          'rate_limit',
          'timeout',
          'invalid_response',
          'unknown',
        };
    final safe = known.contains(normalized) ? normalized : 'unknown',
        cancelled = {'canceled', 'cancelled'}.contains(safe),
        network = {
          'api_connection_error',
          'rate_limit',
          'timeout',
        }.contains(safe),
        card = {
          'card_declined',
          'expired_card',
          'incorrect_cvc',
        }.contains(safe);
    return PaymentError(
      code: safe,
      category: cancelled
          ? 'cancelled'
          : network
          ? 'connection'
          : card
          ? 'paymentMethod'
          : safe == 'authentication_required'
          ? 'authentication'
          : 'unknown',
      occurredAt: now,
      retryable: !mutationStarted && network,
      cancelled: cancelled,
      requiresUserAction: card || safe == 'authentication_required',
      requiresVerification: mutationStarted || cancelled,
      reasonCodes: [
        if (mutationStarted) 'resolveExistingAttemptBeforeRetry',
        if (cancelled) 'sdkCancellationIsNotServerCancellation',
      ],
    );
  }

  static String label(PaymentError error, {String language = 'en'}) {
    PaymentGuard.record(error.validate());
    PaymentGuard.language(language);
    final tr = language.startsWith('tr');
    return switch (error.category) {
      'cancelled' =>
        tr
            ? 'Ödeme ekranı kapatıldı. Durum kontrol ediliyor.'
            : 'Payment screen closed. Checking status.',
      'connection' =>
        tr
            ? 'Bağlantı sorunu. Ödeme durumunu kontrol edin.'
            : 'Connection issue. Check payment status.',
      'paymentMethod' =>
        tr ? 'Ödeme yöntemini kontrol edin.' : 'Check your payment method.',
      'authentication' =>
        tr
            ? 'Ödeme doğrulaması gerekli.'
            : 'Payment authentication is required.',
      _ =>
        tr
            ? 'Ödeme durumu doğrulanmalı.'
            : 'Payment status needs verification.',
    };
  }
}

class PaymentBackendException implements Exception {
  const PaymentBackendException(
    this.code, {
    this.retryable = false,
    this.retryAfterSeconds,
  });
  final String code;
  final bool retryable;
  final int? retryAfterSeconds;
  @override
  String toString() => 'Payment backend operation failed';
}
