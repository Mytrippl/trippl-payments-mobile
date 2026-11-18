import '../trippl_payments_mobile.dart';

class PaymentVerifications {
  static PaymentIntentAssessment validate(
    PaymentVerification verification,
    PaymentVerificationRequest request,
    PaymentOrder order, {
    required String scope,
    required DateTime now,
  }) {
    PaymentGuard.record(verification.validate());
    PaymentGuard.record(request.validate());
    PaymentOrders.validate(order, scope: scope, now: now);
    PaymentGuard.scope(verification.scopeFingerprint, scope);
    PaymentGuard.scope(request.scopeFingerprint, scope);
    final binding = verification.binding, intent = verification.intent;
    PaymentGuard.scope(binding.scopeFingerprint, scope);
    PaymentGuard.scope(intent.scopeFingerprint, scope);
    PaymentGuard.objectId(intent.id, 'pi');
    if (!verification.serverVerified ||
        !binding.serverVerified ||
        !intent.serverVerified ||
        verification.requestFingerprint !=
            PaymentRequests.verificationFingerprint(request) ||
        request.orderId != order.id ||
        request.orderFingerprint != PaymentOrders.fingerprint(order) ||
        binding.orderId != order.id ||
        binding.orderRevision != order.revision ||
        binding.orderFingerprint != request.orderFingerprint ||
        binding.intentId != request.intentId ||
        intent.id != request.intentId ||
        intent.orderId != order.id ||
        intent.orderRevision != order.revision ||
        binding.total != order.total ||
        intent.total != order.total ||
        request.expectedTotal != order.total ||
        binding.environment != request.environment ||
        intent.environment != request.environment ||
        intent.revision < request.minimumRevision)
      throw StateError(
        'Backend payment verification order amount account or environment mismatch',
      );
    for (final time in [
      (verification.observedAt, verification.expiresAt),
      (binding.observedAt, binding.expiresAt),
      (intent.observedAt, intent.expiresAt),
    ])
      if (!PaymentGuard.fresh(time.$1, time.$2, now))
        throw StateError('Backend payment verification expired');
    if (order.customerReference != null &&
        intent.customerId != order.customerReference)
      throw StateError('PaymentIntent belongs to another customer');
    final status = PaymentStatuses.normalize(intent.status);
    if (status == 'succeeded' &&
        (intent.amountReceived == null || intent.amountReceived != order.total))
      throw StateError(
        'Verified payment received amount does not match the order',
      );
    if (intent.amountCapturable != null)
      PaymentAmounts.compatible(order.total, intent.amountCapturable!);
    final webhook = verification.webhook;
    if (webhook != null) {
      PaymentGuard.scope(webhook.scopeFingerprint, scope);
      if (!webhook.serverVerified ||
          webhook.orderId != order.id ||
          webhook.intentId != intent.id ||
          webhook.verifiedAt.isAfter(now))
        throw StateError('Backend event acknowledgement context mismatch');
    }
    final assessed = PaymentStatuses.assess(intent, now: now);
    if (verification.bookingConfirmed &&
        (!assessed.paid || verification.bookingReference == null))
      throw StateError(
        'Booking confirmation lacks verified payment or booking reference',
      );
    return assessed.copyWith(bookingConfirmed: verification.bookingConfirmed);
  }

  static PaymentReconciliation reconcile(
    PaymentVerification verification,
    PaymentVerificationRequest request,
    PaymentOrder order, {
    required String scope,
    required DateTime now,
  }) {
    final result = validate(
      verification,
      request,
      order,
      scope: scope,
      now: now,
    );
    return PaymentReconciliation(
      orderId: order.id,
      intentId: result.intentId,
      evaluatedAt: now,
      state: result.paid
          ? 'matched'
          : result.pending
          ? 'pending'
          : 'unknown',
      amountMatched: true,
      currencyMatched: true,
      customerMatched:
          order.customerReference == null ||
          verification.intent.customerId == order.customerReference,
      orderRevisionMatched: true,
      serverVerified: true,
      bookingConfirmed: result.bookingConfirmed,
      reasonCodes: result.reasonCodes,
    );
  }
}
