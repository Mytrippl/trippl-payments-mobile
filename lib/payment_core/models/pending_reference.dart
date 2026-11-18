// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentPendingReference {
  PaymentPendingReference({
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.attemptId,
    required this.intentId,
    required this.environment,
    required this.savedAt,
    required this.expiresAt,
    this.needsVerification = true,
    this.schemaVersion = 1,
  });

  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final String attemptId;
  final String intentId;
  final String environment;
  final DateTime savedAt;
  final DateTime expiresAt;
  final bool needsVerification;
  final int schemaVersion;

  factory PaymentPendingReference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "attemptId",
      "intentId",
      "environment",
      "savedAt",
      "expiresAt",
      "needsVerification",
      "schemaVersion",
    });
    final value = PaymentPendingReference(
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
      attemptId: PaymentCodec.text(json, 'attemptId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      savedAt: PaymentCodec.date(json, 'savedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      needsVerification:
          PaymentCodec.boolean(json, 'needsVerification') ?? true,
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

  static PaymentResult<PaymentPendingReference> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPendingReference.fromJson(PaymentCodec.object(input)),
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

  PaymentPendingReference copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    String? attemptId,
    String? intentId,
    String? environment,
    DateTime? savedAt,
    DateTime? expiresAt,
    bool? needsVerification,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPendingReference(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      attemptId: (attemptId ?? this.attemptId),
      intentId: (intentId ?? this.intentId),
      environment: (environment ?? this.environment),
      savedAt: (savedAt ?? this.savedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      needsVerification: (needsVerification ?? this.needsVerification),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (attemptId.trim().isEmpty || attemptId.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
      if (schemaVersion < 0 || schemaVersion > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'schemaVersion',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (schemaVersion != 1 ||
        !expiresAt.isAfter(savedAt) ||
        !{'test', 'live'}.contains(environment))
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
    "scopeFingerprint": scopeFingerprint,
    "orderId": orderId,
    "orderFingerprint": orderFingerprint,
    "attemptId": attemptId,
    "intentId": intentId,
    "environment": environment,
    "savedAt": savedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "needsVerification": needsVerification,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPendingReference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPendingReference(redacted)';
}
