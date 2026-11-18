// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentRefundSubmission {
  PaymentRefundSubmission({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.draftId,
    required this.draftFingerprint,
    required this.previewId,
    required this.orderId,
    required this.intentId,
    required this.createdAt,
    required this.expiresAt,
    this.requiresBackendReview = true,
    this.refundCreated = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String draftId;
  final String draftFingerprint;
  final String previewId;
  final String orderId;
  final String intentId;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool requiresBackendReview;
  final bool refundCreated;

  factory PaymentRefundSubmission.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "draftId",
      "draftFingerprint",
      "previewId",
      "orderId",
      "intentId",
      "createdAt",
      "expiresAt",
      "requiresBackendReview",
      "refundCreated",
    });
    final value = PaymentRefundSubmission(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      draftId: PaymentCodec.text(json, 'draftId', required: true)!,
      draftFingerprint: PaymentCodec.text(
        json,
        'draftFingerprint',
        required: true,
      )!,
      previewId: PaymentCodec.text(json, 'previewId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      requiresBackendReview:
          PaymentCodec.boolean(json, 'requiresBackendReview') ?? true,
      refundCreated: PaymentCodec.boolean(json, 'refundCreated') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentRefundSubmission> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundSubmission.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundSubmission copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? draftId,
    String? draftFingerprint,
    String? previewId,
    String? orderId,
    String? intentId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? requiresBackendReview,
    bool? refundCreated,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundSubmission(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      draftId: (draftId ?? this.draftId),
      draftFingerprint: (draftFingerprint ?? this.draftFingerprint),
      previewId: (previewId ?? this.previewId),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      requiresBackendReview:
          (requiresBackendReview ?? this.requiresBackendReview),
      refundCreated: (refundCreated ?? this.refundCreated),
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
      if (draftId.trim().isEmpty || draftId.length > 4000)
        validationIssues.add(
          const PaymentIssue('draftId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (draftFingerprint.trim().isEmpty || draftFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'draftFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (previewId.trim().isEmpty || previewId.length > 4000)
        validationIssues.add(
          const PaymentIssue('previewId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        !expiresAt.isAfter(createdAt) ||
        !requiresBackendReview ||
        refundCreated)
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
    "draftId": draftId,
    "draftFingerprint": draftFingerprint,
    "previewId": previewId,
    "orderId": orderId,
    "intentId": intentId,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "requiresBackendReview": requiresBackendReview,
    "refundCreated": refundCreated,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundSubmission &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundSubmission(redacted)';
}
