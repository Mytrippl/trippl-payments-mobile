import '../trippl_payments_mobile.dart';

class PaymentStatuses {
  static const known = {
    'requires_payment_method',
    'requires_confirmation',
    'requires_action',
    'processing',
    'requires_capture',
    'canceled',
    'succeeded',
  };
  static String normalize(String value) {
    final status = value.trim().toLowerCase();
    return status == 'cancelled'
        ? 'canceled'
        : known.contains(status)
        ? status
        : 'unknown';
  }

  static String state(String status) => switch (normalize(status)) {
    'succeeded' => 'paid',
    'processing' => 'pending',
    'requires_capture' => 'authorized',
    'requires_action' => 'authenticationRequired',
    'requires_confirmation' => 'confirmationRequired',
    'requires_payment_method' => 'methodRequired',
    'canceled' => 'cancelled',
    _ => 'unknown',
  };
  static PaymentIntentAssessment assess(
    PaymentIntent intent, {
    required DateTime now,
  }) {
    PaymentGuard.record(intent.validate());
    final current =
            intent.serverVerified &&
            PaymentGuard.fresh(intent.observedAt, intent.expiresAt, now),
        status = normalize(intent.status),
        reasons = <String>[];
    if (!current) reasons.add('currentBackendVerificationRequired');
    if (status == 'unknown') reasons.add('unknownPaymentIntentStatus');
    final paid = current && status == 'succeeded';
    return PaymentIntentAssessment(
      intentId: intent.id,
      orderId: intent.orderId,
      evaluatedAt: now,
      state: current ? state(status) : 'unknown',
      paid: paid,
      pending:
          current &&
          {
            'processing',
            'requires_action',
            'requires_confirmation',
            'requires_capture',
          }.contains(status),
      authorized: current && status == 'requires_capture',
      requiresAction:
          current &&
          {'requires_action', 'requires_payment_method'}.contains(status),
      terminal: current && {'succeeded', 'canceled'}.contains(status),
      reasonCodes: reasons,
      serverVerified: current,
      bookingConfirmed: false,
    );
  }

  static String label(String state, {String language = 'en'}) {
    PaymentGuard.language(language);
    final tr = language.startsWith('tr');
    return switch (state) {
      'paid' => tr ? 'Ödeme tamamlandı' : 'Payment completed',
      'pending' => tr ? 'Ödeme işleniyor' : 'Payment processing',
      'authorized' =>
        tr ? 'Tutar provizyonda' : 'Payment authorized, capture pending',
      'authenticationRequired' =>
        tr ? 'Doğrulama gerekli' : 'Authentication required',
      'confirmationRequired' => tr ? 'Onay gerekli' : 'Confirmation required',
      'methodRequired' =>
        tr ? 'Ödeme yöntemi gerekli' : 'Payment method required',
      'cancelled' => tr ? 'Ödeme iptal edildi' : 'Payment cancelled',
      _ => tr ? 'Ödeme doğrulanmalı' : 'Payment needs verification',
    };
  }
}
