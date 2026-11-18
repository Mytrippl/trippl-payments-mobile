// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCountryAddressRule {
  PaymentCountryAddressRule({
    required this.countryCode,
    this.postalCodeRequired = false,
    this.regionRequired = false,
    this.cityRequired = true,
    this.line1Required = true,
    this.postalPattern = "none",
    this.maximumLineLength = 100,
    List<String> allowedRegionCodes = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : allowedRegionCodes = List.unmodifiable(allowedRegionCodes);

  final String countryCode;
  final bool postalCodeRequired;
  final bool regionRequired;
  final bool cityRequired;
  final bool line1Required;
  final String postalPattern;
  final int maximumLineLength;
  final List<String> allowedRegionCodes;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentCountryAddressRule.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "countryCode",
      "postalCodeRequired",
      "regionRequired",
      "cityRequired",
      "line1Required",
      "postalPattern",
      "maximumLineLength",
      "allowedRegionCodes",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentCountryAddressRule(
      countryCode: PaymentCodec.text(json, 'countryCode', required: true)!,
      postalCodeRequired:
          PaymentCodec.boolean(json, 'postalCodeRequired') ?? false,
      regionRequired: PaymentCodec.boolean(json, 'regionRequired') ?? false,
      cityRequired: PaymentCodec.boolean(json, 'cityRequired') ?? true,
      line1Required: PaymentCodec.boolean(json, 'line1Required') ?? true,
      postalPattern: PaymentCodec.text(json, 'postalPattern') ?? "none",
      maximumLineLength:
          PaymentCodec.integer(
            json,
            'maximumLineLength',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
      allowedRegionCodes:
          PaymentCodec.list(json, 'allowedRegionCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
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

  static PaymentResult<PaymentCountryAddressRule> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCountryAddressRule.fromJson(PaymentCodec.object(input)),
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

  PaymentCountryAddressRule copyWith({
    Set<String> clear = const {},
    String? countryCode,
    bool? postalCodeRequired,
    bool? regionRequired,
    bool? cityRequired,
    bool? line1Required,
    String? postalPattern,
    int? maximumLineLength,
    List<String>? allowedRegionCodes,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCountryAddressRule(
      countryCode: (countryCode ?? this.countryCode),
      postalCodeRequired: (postalCodeRequired ?? this.postalCodeRequired),
      regionRequired: (regionRequired ?? this.regionRequired),
      cityRequired: (cityRequired ?? this.cityRequired),
      line1Required: (line1Required ?? this.line1Required),
      postalPattern: (postalPattern ?? this.postalPattern),
      maximumLineLength: (maximumLineLength ?? this.maximumLineLength),
      allowedRegionCodes: (allowedRegionCodes ?? this.allowedRegionCodes),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (postalPattern.trim().isEmpty || postalPattern.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'postalPattern',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (maximumLineLength < 0 || maximumLineLength > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumLineLength',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (allowedRegionCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'allowedRegionCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (allowedRegionCodes.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'allowedRegionCodes',
            'text',
            'Use bounded nonempty list text',
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
        !expiresAt.isAfter(observedAt) ||
        !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode) ||
        maximumLineLength < 1 ||
        maximumLineLength > 200 ||
        !{
          'none',
          'digits',
          'alphanumeric',
          'uk',
          'us',
          'ca',
        }.contains(postalPattern))
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
    "countryCode": countryCode,
    "postalCodeRequired": postalCodeRequired,
    "regionRequired": regionRequired,
    "cityRequired": cityRequired,
    "line1Required": line1Required,
    "postalPattern": postalPattern,
    "maximumLineLength": maximumLineLength,
    "allowedRegionCodes": allowedRegionCodes,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCountryAddressRule &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCountryAddressRule(redacted)';
}
