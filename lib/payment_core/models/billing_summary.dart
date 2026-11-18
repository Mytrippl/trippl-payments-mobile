// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentBillingSummary {
  PaymentBillingSummary({
    this.countryCode,
    this.postalCode,
    this.nameCollected = false,
    this.emailCollected = false,
    this.phoneCollected = false,
    this.addressCollected = false,
    this.source = "sdk",
    this.revision = 1,
  });

  final String? countryCode;
  final String? postalCode;
  final bool nameCollected;
  final bool emailCollected;
  final bool phoneCollected;
  final bool addressCollected;
  final String source;
  final int revision;

  factory PaymentBillingSummary.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "countryCode",
      "postalCode",
      "nameCollected",
      "emailCollected",
      "phoneCollected",
      "addressCollected",
      "source",
      "revision",
    });
    final value = PaymentBillingSummary(
      countryCode: PaymentCodec.text(json, 'countryCode'),
      postalCode: PaymentCodec.text(json, 'postalCode'),
      nameCollected: PaymentCodec.boolean(json, 'nameCollected') ?? false,
      emailCollected: PaymentCodec.boolean(json, 'emailCollected') ?? false,
      phoneCollected: PaymentCodec.boolean(json, 'phoneCollected') ?? false,
      addressCollected: PaymentCodec.boolean(json, 'addressCollected') ?? false,
      source: PaymentCodec.text(json, 'source') ?? "sdk",
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

  static PaymentResult<PaymentBillingSummary> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentBillingSummary.fromJson(PaymentCodec.object(input)),
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

  PaymentBillingSummary copyWith({
    Set<String> clear = const {},
    String? countryCode,
    String? postalCode,
    bool? nameCollected,
    bool? emailCollected,
    bool? phoneCollected,
    bool? addressCollected,
    String? source,
    int? revision,
  }) {
    final clearableFields = <String>{"countryCode", "postalCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentBillingSummary(
      countryCode: clear.contains('countryCode')
          ? null
          : (countryCode ?? this.countryCode),
      postalCode: clear.contains('postalCode')
          ? null
          : (postalCode ?? this.postalCode),
      nameCollected: (nameCollected ?? this.nameCollected),
      emailCollected: (emailCollected ?? this.emailCollected),
      phoneCollected: (phoneCollected ?? this.phoneCollected),
      addressCollected: (addressCollected ?? this.addressCollected),
      source: (source ?? this.source),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    if (countryCode != null) {
      if (countryCode!.trim().isEmpty || countryCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'countryCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (postalCode != null) {
      if (postalCode!.trim().isEmpty || postalCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue('postalCode', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (source.trim().isEmpty || source.length > 4000)
        validationIssues.add(
          const PaymentIssue('source', 'text', 'Use nonempty bounded text'),
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
        !{'sdk', 'backend', 'unknown'}.contains(source) ||
        countryCode != null && !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode!))
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
    if (countryCode != null) "countryCode": countryCode,
    if (postalCode != null) "postalCode": postalCode,
    "nameCollected": nameCollected,
    "emailCollected": emailCollected,
    "phoneCollected": phoneCollected,
    "addressCollected": addressCollected,
    "source": source,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentBillingSummary &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentBillingSummary(redacted)';
}
