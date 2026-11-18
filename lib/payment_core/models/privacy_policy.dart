// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentPrivacyPolicy {
  PaymentPrivacyPolicy({
    this.persistPendingReferences = false,
    this.persistMethodReferences = false,
    this.maximumAgeHours = 24,
    this.maximumRecords = 20,
    this.version = 1,
  });

  final bool persistPendingReferences;
  final bool persistMethodReferences;
  final int maximumAgeHours;
  final int maximumRecords;
  final int version;

  factory PaymentPrivacyPolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "persistPendingReferences",
      "persistMethodReferences",
      "maximumAgeHours",
      "maximumRecords",
      "version",
    });
    final value = PaymentPrivacyPolicy(
      persistPendingReferences:
          PaymentCodec.boolean(json, 'persistPendingReferences') ?? false,
      persistMethodReferences:
          PaymentCodec.boolean(json, 'persistMethodReferences') ?? false,
      maximumAgeHours:
          PaymentCodec.integer(
            json,
            'maximumAgeHours',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          24,
      maximumRecords:
          PaymentCodec.integer(
            json,
            'maximumRecords',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
      version:
          PaymentCodec.integer(
            json,
            'version',
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

  static PaymentResult<PaymentPrivacyPolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPrivacyPolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentPrivacyPolicy copyWith({
    Set<String> clear = const {},
    bool? persistPendingReferences,
    bool? persistMethodReferences,
    int? maximumAgeHours,
    int? maximumRecords,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPrivacyPolicy(
      persistPendingReferences:
          (persistPendingReferences ?? this.persistPendingReferences),
      persistMethodReferences:
          (persistMethodReferences ?? this.persistMethodReferences),
      maximumAgeHours: (maximumAgeHours ?? this.maximumAgeHours),
      maximumRecords: (maximumRecords ?? this.maximumRecords),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (maximumAgeHours < 0 || maximumAgeHours > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumAgeHours',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (maximumRecords < 0 || maximumRecords > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumRecords',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (version < 0 || version > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'version',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (version != 1 ||
        maximumAgeHours < 1 ||
        maximumAgeHours > 168 ||
        maximumRecords < 1 ||
        maximumRecords > 100)
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
    "persistPendingReferences": persistPendingReferences,
    "persistMethodReferences": persistMethodReferences,
    "maximumAgeHours": maximumAgeHours,
    "maximumRecords": maximumRecords,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPrivacyPolicy &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPrivacyPolicy(redacted)';
}
