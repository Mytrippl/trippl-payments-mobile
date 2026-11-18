// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'installment_plan.dart';

class PaymentPlanChange {
  PaymentPlanChange({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.planId,
    required this.expectedRevision,
    required this.replacement,
    required this.reasonCode,
    required this.createdAt,
    this.submitted = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String planId;
  final int expectedRevision;
  final PaymentInstallmentPlan replacement;
  final String reasonCode;
  final DateTime createdAt;
  final bool submitted;

  factory PaymentPlanChange.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "planId",
      "expectedRevision",
      "replacement",
      "reasonCode",
      "createdAt",
      "submitted",
    });
    final value = PaymentPlanChange(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      planId: PaymentCodec.text(json, 'planId', required: true)!,
      expectedRevision: PaymentCodec.integer(
        json,
        'expectedRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      replacement: (json['replacement'] == null
          ? null
          : PaymentInstallmentPlan.fromJson(
              PaymentCodec.object(json['replacement']),
            ))!,
      reasonCode: PaymentCodec.text(json, 'reasonCode', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      submitted: PaymentCodec.boolean(json, 'submitted') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentPlanChange> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPlanChange.fromJson(PaymentCodec.object(input)),
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

  PaymentPlanChange copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? planId,
    int? expectedRevision,
    PaymentInstallmentPlan? replacement,
    String? reasonCode,
    DateTime? createdAt,
    bool? submitted,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPlanChange(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      planId: (planId ?? this.planId),
      expectedRevision: (expectedRevision ?? this.expectedRevision),
      replacement: (replacement ?? this.replacement),
      reasonCode: (reasonCode ?? this.reasonCode),
      createdAt: (createdAt ?? this.createdAt),
      submitted: (submitted ?? this.submitted),
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
      if (planId.trim().isEmpty || planId.length > 4000)
        validationIssues.add(
          const PaymentIssue('planId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (expectedRevision < 0 || expectedRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'expectedRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      for (final issue in replacement.validate())
        validationIssues.add(
          PaymentIssue(
            'replacement.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (reasonCode.trim().isEmpty || reasonCode.length > 4000)
        validationIssues.add(
          const PaymentIssue('reasonCode', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        expectedRevision < 1 ||
        submitted)
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
    "planId": planId,
    "expectedRevision": expectedRevision,
    "replacement": replacement.toJson(),
    "reasonCode": reasonCode,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "submitted": submitted,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPlanChange && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPlanChange(redacted)';
}
