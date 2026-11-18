// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCredentialsReference {
  PaymentCredentialsReference({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.intentId,
    this.customerId,
    required this.environment,
    required this.createdAt,
    required this.expiresAt,
    this.singleUse = true,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String intentId;
  final String? customerId;
  final String environment;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool singleUse;
  final int revision;

  factory PaymentCredentialsReference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "intentId",
      "customerId",
      "environment",
      "createdAt",
      "expiresAt",
      "singleUse",
      "revision",
    });
    final value = PaymentCredentialsReference(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId'),
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      singleUse: PaymentCodec.boolean(json, 'singleUse') ?? true,
      revision:
          PaymentCodec.integer(
            json,
            'revision',
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

  static PaymentResult<PaymentCredentialsReference> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCredentialsReference.fromJson(PaymentCodec.object(input)),
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

  PaymentCredentialsReference copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? intentId,
    String? customerId,
    String? environment,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? singleUse,
    int? revision,
  }) {
    final clearableFields = <String>{"customerId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCredentialsReference(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      customerId: clear.contains('customerId')
          ? null
          : (customerId ?? this.customerId),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      singleUse: (singleUse ?? this.singleUse),
      revision: (revision ?? this.revision),
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
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (customerId != null) {
      if (customerId!.trim().isEmpty || customerId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
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
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'revision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (revision < 1 ||
        !expiresAt.isAfter(createdAt) ||
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
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "orderId": orderId,
    "intentId": intentId,
    if (customerId != null) "customerId": customerId,
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "singleUse": singleUse,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCredentialsReference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCredentialsReference(redacted)';
}
