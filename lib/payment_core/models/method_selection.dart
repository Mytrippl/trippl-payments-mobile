// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentMethodSelection {
  PaymentMethodSelection({
    required this.scopeFingerprint,
    required this.customerId,
    required this.updatedAt,
    this.methodId,
    this.kind = "newCard",
    required this.environment,
    this.revision = 1,
  });

  final String scopeFingerprint;
  final String customerId;
  final DateTime updatedAt;
  final String? methodId;
  final String kind;
  final String environment;
  final int revision;

  factory PaymentMethodSelection.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "customerId",
      "updatedAt",
      "methodId",
      "kind",
      "environment",
      "revision",
    });
    final value = PaymentMethodSelection(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      methodId: PaymentCodec.text(json, 'methodId'),
      kind: PaymentCodec.text(json, 'kind') ?? "newCard",
      environment: PaymentCodec.text(json, 'environment', required: true)!,
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

  static PaymentResult<PaymentMethodSelection> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentMethodSelection.fromJson(PaymentCodec.object(input)),
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

  PaymentMethodSelection copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? customerId,
    DateTime? updatedAt,
    String? methodId,
    String? kind,
    String? environment,
    int? revision,
  }) {
    final clearableFields = <String>{"methodId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentMethodSelection(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      customerId: (customerId ?? this.customerId),
      updatedAt: (updatedAt ?? this.updatedAt),
      methodId: clear.contains('methodId') ? null : (methodId ?? this.methodId),
      kind: (kind ?? this.kind),
      environment: (environment ?? this.environment),
      revision: (revision ?? this.revision),
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
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (methodId != null) {
      if (methodId!.trim().isEmpty || methodId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('methodId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
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
        !{'newCard', 'savedMethod', 'applePay', 'googlePay'}.contains(kind) ||
        kind == 'savedMethod' && methodId == null ||
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
    "customerId": customerId,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    if (methodId != null) "methodId": methodId,
    "kind": kind,
    "environment": environment,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentMethodSelection &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentMethodSelection(redacted)';
}
