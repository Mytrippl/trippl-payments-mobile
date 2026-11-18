// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentBillingAddress {
  PaymentBillingAddress({
    required this.id,
    required this.countryCode,
    required this.line1,
    required this.city,
    this.line2,
    this.regionCode,
    this.postalCode,
    required this.updatedAt,
    this.revision = 1,
  });

  final String id;
  final String countryCode;
  final String line1;
  final String city;
  final String? line2;
  final String? regionCode;
  final String? postalCode;
  final DateTime updatedAt;
  final int revision;

  factory PaymentBillingAddress.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "countryCode",
      "line1",
      "city",
      "line2",
      "regionCode",
      "postalCode",
      "updatedAt",
      "revision",
    });
    final value = PaymentBillingAddress(
      id: PaymentCodec.text(json, 'id', required: true)!,
      countryCode: PaymentCodec.text(json, 'countryCode', required: true)!,
      line1: PaymentCodec.text(json, 'line1', required: true)!,
      city: PaymentCodec.text(json, 'city', required: true)!,
      line2: PaymentCodec.text(json, 'line2'),
      regionCode: PaymentCodec.text(json, 'regionCode'),
      postalCode: PaymentCodec.text(json, 'postalCode'),
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
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

  static PaymentResult<PaymentBillingAddress> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentBillingAddress.fromJson(PaymentCodec.object(input)),
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

  PaymentBillingAddress copyWith({
    Set<String> clear = const {},
    String? id,
    String? countryCode,
    String? line1,
    String? city,
    String? line2,
    String? regionCode,
    String? postalCode,
    DateTime? updatedAt,
    int? revision,
  }) {
    final clearableFields = <String>{"line2", "regionCode", "postalCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentBillingAddress(
      id: (id ?? this.id),
      countryCode: (countryCode ?? this.countryCode),
      line1: (line1 ?? this.line1),
      city: (city ?? this.city),
      line2: clear.contains('line2') ? null : (line2 ?? this.line2),
      regionCode: clear.contains('regionCode')
          ? null
          : (regionCode ?? this.regionCode),
      postalCode: clear.contains('postalCode')
          ? null
          : (postalCode ?? this.postalCode),
      updatedAt: (updatedAt ?? this.updatedAt),
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
      if (countryCode.trim().isEmpty || countryCode.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'countryCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (line1.trim().isEmpty || line1.length > 4000)
        validationIssues.add(
          const PaymentIssue('line1', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (city.trim().isEmpty || city.length > 4000)
        validationIssues.add(
          const PaymentIssue('city', 'text', 'Use nonempty bounded text'),
        );
    }
    if (line2 != null) {
      if (line2!.trim().isEmpty || line2!.length > 4000)
        validationIssues.add(
          const PaymentIssue('line2', 'text', 'Use nonempty bounded text'),
        );
    }
    if (regionCode != null) {
      if (regionCode!.trim().isEmpty || regionCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue('regionCode', 'text', 'Use nonempty bounded text'),
        );
    }
    if (postalCode != null) {
      if (postalCode!.trim().isEmpty || postalCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue('postalCode', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 || !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode))
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
    "countryCode": countryCode,
    "line1": line1,
    "city": city,
    if (line2 != null) "line2": line2,
    if (regionCode != null) "regionCode": regionCode,
    if (postalCode != null) "postalCode": postalCode,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentBillingAddress &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentBillingAddress(redacted)';
}
