// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentPlanConsent {
  PaymentPlanConsent({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.planId,
    required this.planFingerprint,
    required this.termsRevision,
    required this.acceptedAt,
    required this.expiresAt,
    List<String> acknowledgedCodes = const [],
    this.automaticChargeConsent = false,
    this.submitted = false,
  }) : acknowledgedCodes = List.unmodifiable(acknowledgedCodes);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String planId;
  final String planFingerprint;
  final int termsRevision;
  final DateTime acceptedAt;
  final DateTime expiresAt;
  final List<String> acknowledgedCodes;
  final bool automaticChargeConsent;
  final bool submitted;

  factory PaymentPlanConsent.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "planId",
      "planFingerprint",
      "termsRevision",
      "acceptedAt",
      "expiresAt",
      "acknowledgedCodes",
      "automaticChargeConsent",
      "submitted",
    });
    final value = PaymentPlanConsent(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      planId: PaymentCodec.text(json, 'planId', required: true)!,
      planFingerprint: PaymentCodec.text(
        json,
        'planFingerprint',
        required: true,
      )!,
      termsRevision: PaymentCodec.integer(
        json,
        'termsRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      acceptedAt: PaymentCodec.date(json, 'acceptedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      acknowledgedCodes:
          PaymentCodec.list(json, 'acknowledgedCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      automaticChargeConsent:
          PaymentCodec.boolean(json, 'automaticChargeConsent') ?? false,
      submitted: PaymentCodec.boolean(json, 'submitted') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentPlanConsent> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPlanConsent.fromJson(PaymentCodec.object(input)),
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

  PaymentPlanConsent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? planId,
    String? planFingerprint,
    int? termsRevision,
    DateTime? acceptedAt,
    DateTime? expiresAt,
    List<String>? acknowledgedCodes,
    bool? automaticChargeConsent,
    bool? submitted,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPlanConsent(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      planId: (planId ?? this.planId),
      planFingerprint: (planFingerprint ?? this.planFingerprint),
      termsRevision: (termsRevision ?? this.termsRevision),
      acceptedAt: (acceptedAt ?? this.acceptedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      acknowledgedCodes: (acknowledgedCodes ?? this.acknowledgedCodes),
      automaticChargeConsent:
          (automaticChargeConsent ?? this.automaticChargeConsent),
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
      if (planFingerprint.trim().isEmpty || planFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'planFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (termsRevision < 0 || termsRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'termsRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (acknowledgedCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'acknowledgedCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (acknowledgedCodes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'acknowledgedCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        termsRevision < 1 ||
        !expiresAt.isAfter(acceptedAt) ||
        automaticChargeConsent ||
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
    "planFingerprint": planFingerprint,
    "termsRevision": termsRevision,
    "acceptedAt": acceptedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "acknowledgedCodes": acknowledgedCodes,
    "automaticChargeConsent": automaticChargeConsent,
    "submitted": submitted,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPlanConsent &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPlanConsent(redacted)';
}
