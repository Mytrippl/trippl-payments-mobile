import '../trippl_payments_mobile.dart';

class PaymentSupport {
  static void evidence(
    PaymentDisputeEvidenceReference evidence,
    PaymentDispute dispute, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(evidence.validate());
    PaymentGuard.record(dispute.validate());
    for (final pair in [
      (evidence.scopeFingerprint, evidence.environment),
      (dispute.scopeFingerprint, dispute.environment),
    ])
      PaymentAccountGuard.context(
        pair.$1,
        pair.$2,
        scope: scope,
        environment: environment,
      );
    PaymentAccountGuard.current(
      dispute.observedAt,
      dispute.expiresAt,
      dispute.serverVerified,
      now,
    );
    if (evidence.disputeId != dispute.id ||
        !dispute.evidenceAllowed ||
        dispute.status != 'needs_response' ||
        dispute.responseDueAt == null ||
        !dispute.responseDueAt!.isAfter(now) ||
        evidence.createdAt.isAfter(now))
      throw StateError('Dispute evidence review unavailable');
    if (!RegExp(r'^[A-Za-z0-9_-]{1,180}$').hasMatch(evidence.fileReference))
      throw const FormatException(
        'Use an opaque host-managed evidence reference',
      );
  }

  static PaymentSupportContext context(
    String orderId,
    String topic, {
    required String scope,
    required String environment,
    required DateTime now,
    String? intentId,
    String? refundId,
    String? disputeId,
    List<String> reasonCodes = const [],
  }) {
    PaymentGuard.identity(orderId);
    PaymentGuard.environment(environment);
    PaymentGuard.distinct(reasonCodes);
    if (intentId != null) PaymentGuard.objectId(intentId, 'pi');
    final value = PaymentSupportContext(
      id: 'support-${PaymentCodec.digest({'order': orderId, 'topic': topic, 'time': now.toUtc().toIso8601String()})}',
      scopeFingerprint: PaymentCodec.digest(scope),
      environment: environment,
      orderId: orderId,
      topic: topic,
      createdAt: now,
      intentId: intentId,
      refundId: refundId,
      disputeId: disputeId,
      reasonCodes: reasonCodes,
    );
    PaymentGuard.record(value.validate());
    return value;
  }

  static PaymentSupportHandoff handoff(
    PaymentSupportContext context,
    String destination,
    PaymentReturnPolicy policy, {
    required String scope,
    required String environment,
    required DateTime now,
  }) {
    PaymentGuard.record(context.validate());
    PaymentAccountGuard.context(
      context.scopeFingerprint,
      context.environment,
      scope: scope,
      environment: environment,
    );
    if (context.createdAt.isAfter(now) ||
        now.difference(context.createdAt) > const Duration(minutes: 15))
      throw StateError('Support context expired');
    final uri = PaymentReturns.validate(destination, policy);
    if (uri.hasQuery)
      throw StateError(
        'Support destination cannot include private context in its query',
      );
    return PaymentSupportHandoff(
      id: 'support-handoff-${context.id}',
      scopeFingerprint: context.scopeFingerprint,
      environment: environment,
      contextFingerprint: PaymentAccountGuard.fingerprint(context.toJson()),
      orderId: context.orderId,
      destination: uri.toString(),
      createdAt: now,
      expiresAt: now.add(const Duration(minutes: 10)),
    );
  }

  static Map<String, Object?> presentation(PaymentSupportContext context) {
    PaymentGuard.record(context.validate());
    return Map.unmodifiable({
      'orderId': context.orderId,
      'topic': context.topic,
      'intentId': context.intentId,
      'refundId': context.refundId,
      'disputeId': context.disputeId,
      'reasonCodes': context.reasonCodes,
      'messageSent': false,
    });
  }
}
