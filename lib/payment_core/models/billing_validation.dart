// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentBillingValidation {
  PaymentBillingValidation({
    required this.addressId,
    required this.evaluatedAt,
    required this.ruleRevision,
    required this.valid,
    List<String> missingFields = const [],
    List<String> reasonCodes = const [],
    this.requiresBackendValidation = true,
    this.normalizedPostalCode = "unknown",
  }) : missingFields = List.unmodifiable(missingFields),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String addressId;
  final DateTime evaluatedAt;
  final int ruleRevision;
  final bool valid;
  final List<String> missingFields;
  final List<String> reasonCodes;
  final bool requiresBackendValidation;
  final String normalizedPostalCode;

  factory PaymentBillingValidation.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "addressId",
      "evaluatedAt",
      "ruleRevision",
      "valid",
      "missingFields",
      "reasonCodes",
      "requiresBackendValidation",
      "normalizedPostalCode",
    });
    final value = PaymentBillingValidation(
      addressId: PaymentCodec.text(json, 'addressId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      ruleRevision: PaymentCodec.integer(
        json,
        'ruleRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      valid: PaymentCodec.boolean(json, 'valid', required: true)!,
      missingFields:
          PaymentCodec.list(json, 'missingFields', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      requiresBackendValidation:
          PaymentCodec.boolean(json, 'requiresBackendValidation') ?? true,
      normalizedPostalCode:
          PaymentCodec.text(json, 'normalizedPostalCode') ?? "unknown",
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentBillingValidation> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentBillingValidation.fromJson(PaymentCodec.object(input)),
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

  PaymentBillingValidation copyWith({
    Set<String> clear = const {},
    String? addressId,
    DateTime? evaluatedAt,
    int? ruleRevision,
    bool? valid,
    List<String>? missingFields,
    List<String>? reasonCodes,
    bool? requiresBackendValidation,
    String? normalizedPostalCode,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentBillingValidation(
      addressId: (addressId ?? this.addressId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      ruleRevision: (ruleRevision ?? this.ruleRevision),
      valid: (valid ?? this.valid),
      missingFields: (missingFields ?? this.missingFields),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      requiresBackendValidation:
          (requiresBackendValidation ?? this.requiresBackendValidation),
      normalizedPostalCode: (normalizedPostalCode ?? this.normalizedPostalCode),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (addressId.trim().isEmpty || addressId.length > 4000)
        validationIssues.add(
          const PaymentIssue('addressId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (ruleRevision < 0 || ruleRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'ruleRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (missingFields.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'missingFields',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (missingFields.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'missingFields',
            'text',
            'Use bounded nonempty list text',
          ),
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
      if (normalizedPostalCode.trim().isEmpty ||
          normalizedPostalCode.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'normalizedPostalCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (ruleRevision < 1 ||
        valid && missingFields.isNotEmpty ||
        !requiresBackendValidation)
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
    "addressId": addressId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "ruleRevision": ruleRevision,
    "valid": valid,
    "missingFields": missingFields,
    "reasonCodes": reasonCodes,
    "requiresBackendValidation": requiresBackendValidation,
    "normalizedPostalCode": normalizedPostalCode,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentBillingValidation &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentBillingValidation(redacted)';
}
