// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentSupportContext {
  PaymentSupportContext({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.topic,
    required this.createdAt,
    this.intentId,
    this.refundId,
    this.disputeId,
    List<String> reasonCodes = const [],
    this.schemaVersion = 1,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String topic;
  final DateTime createdAt;
  final String? intentId;
  final String? refundId;
  final String? disputeId;
  final List<String> reasonCodes;
  final int schemaVersion;

  factory PaymentSupportContext.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "topic",
      "createdAt",
      "intentId",
      "refundId",
      "disputeId",
      "reasonCodes",
      "schemaVersion",
    });
    final value = PaymentSupportContext(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      topic: PaymentCodec.text(json, 'topic', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      refundId: PaymentCodec.text(json, 'refundId'),
      disputeId: PaymentCodec.text(json, 'disputeId'),
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      schemaVersion:
          PaymentCodec.integer(
            json,
            'schemaVersion',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentSupportContext> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentSupportContext.fromJson(PaymentCodec.object(input)),
      );
    } on PaymentValidationException catch (e) {
      return PaymentResult(issues: e.issues);
    } on FormatException {
      return PaymentResult(
        issues: const [
          PaymentIssue(
            'record',
            'format',
            'Payment record has invalid fields or values',
          ),
        ],
      );
    }
  }

  PaymentSupportContext copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? topic,
    DateTime? createdAt,
    String? intentId,
    String? refundId,
    String? disputeId,
    List<String>? reasonCodes,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{"intentId", "refundId", "disputeId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentSupportContext(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      topic: (topic ?? this.topic),
      createdAt: (createdAt ?? this.createdAt),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      refundId: clear.contains('refundId') ? null : (refundId ?? this.refundId),
      disputeId: clear.contains('disputeId')
          ? null
          : (disputeId ?? this.disputeId),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const PaymentIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (environment.trim().isEmpty || environment.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'environment',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (topic.trim().isEmpty || topic.length > 4000)
        validationIssues.add(
          const PaymentIssue('topic', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (refundId != null) {
      if (refundId!.trim().isEmpty || refundId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('refundId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (disputeId != null) {
      if (disputeId!.trim().isEmpty || disputeId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('disputeId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (schemaVersion < 0 || schemaVersion > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'schemaVersion',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        schemaVersion != 1 ||
        !{'payment', 'refund', 'invoice', 'dispute', 'plan'}.contains(topic))
      validationIssues.add(
        const PaymentIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "orderId": orderId,
    "topic": topic,
    "createdAt": createdAt.toUtc().toIso8601String(),
    if (intentId != null) "intentId": intentId,
    if (refundId != null) "refundId": refundId,
    if (disputeId != null) "disputeId": disputeId,
    "reasonCodes": reasonCodes,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentSupportContext &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentSupportContext(redacted)';
}
