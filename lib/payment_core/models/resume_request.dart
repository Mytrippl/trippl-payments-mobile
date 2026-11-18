// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentResumeRequest {
  PaymentResumeRequest({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.intentId,
    required this.attemptId,
    required this.environment,
    required this.createdAt,
    this.readOnly = true,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final String intentId;
  final String attemptId;
  final String environment;
  final DateTime createdAt;
  final bool readOnly;

  factory PaymentResumeRequest.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "intentId",
      "attemptId",
      "environment",
      "createdAt",
      "readOnly",
    });
    final value = PaymentResumeRequest(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      attemptId: PaymentCodec.text(json, 'attemptId', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      readOnly: PaymentCodec.boolean(json, 'readOnly') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentResumeRequest> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentResumeRequest.fromJson(PaymentCodec.object(input)),
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

  PaymentResumeRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    String? intentId,
    String? attemptId,
    String? environment,
    DateTime? createdAt,
    bool? readOnly,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentResumeRequest(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      intentId: (intentId ?? this.intentId),
      attemptId: (attemptId ?? this.attemptId),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      readOnly: (readOnly ?? this.readOnly),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderFingerprint.trim().isEmpty || orderFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'orderFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (attemptId.trim().isEmpty || attemptId.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
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
    if (!readOnly || !{'test', 'live'}.contains(environment))
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
    "orderId": orderId,
    "orderFingerprint": orderFingerprint,
    "intentId": intentId,
    "attemptId": attemptId,
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "readOnly": readOnly,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentResumeRequest &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentResumeRequest(redacted)';
}
