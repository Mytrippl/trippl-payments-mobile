// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentSdkConfiguration {
  PaymentSdkConfiguration({
    required this.merchantName,
    required this.merchantCountry,
    required this.environment,
    required this.returnUri,
    this.language = "en",
    this.applePayEnabled = false,
    this.googlePayEnabled = false,
    this.billingCollection = "automatic",
    this.allowsDelayedMethods = false,
    this.version = 1,
  });

  final String merchantName;
  final String merchantCountry;
  final String environment;
  final String returnUri;
  final String language;
  final bool applePayEnabled;
  final bool googlePayEnabled;
  final String billingCollection;
  final bool allowsDelayedMethods;
  final int version;

  factory PaymentSdkConfiguration.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "merchantName",
      "merchantCountry",
      "environment",
      "returnUri",
      "language",
      "applePayEnabled",
      "googlePayEnabled",
      "billingCollection",
      "allowsDelayedMethods",
      "version",
    });
    final value = PaymentSdkConfiguration(
      merchantName: PaymentCodec.text(json, 'merchantName', required: true)!,
      merchantCountry: PaymentCodec.text(
        json,
        'merchantCountry',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      returnUri: PaymentCodec.text(json, 'returnUri', required: true)!,
      language: PaymentCodec.text(json, 'language') ?? "en",
      applePayEnabled: PaymentCodec.boolean(json, 'applePayEnabled') ?? false,
      googlePayEnabled: PaymentCodec.boolean(json, 'googlePayEnabled') ?? false,
      billingCollection:
          PaymentCodec.text(json, 'billingCollection') ?? "automatic",
      allowsDelayedMethods:
          PaymentCodec.boolean(json, 'allowsDelayedMethods') ?? false,
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

  static PaymentResult<PaymentSdkConfiguration> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentSdkConfiguration.fromJson(PaymentCodec.object(input)),
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

  PaymentSdkConfiguration copyWith({
    Set<String> clear = const {},
    String? merchantName,
    String? merchantCountry,
    String? environment,
    String? returnUri,
    String? language,
    bool? applePayEnabled,
    bool? googlePayEnabled,
    String? billingCollection,
    bool? allowsDelayedMethods,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentSdkConfiguration(
      merchantName: (merchantName ?? this.merchantName),
      merchantCountry: (merchantCountry ?? this.merchantCountry),
      environment: (environment ?? this.environment),
      returnUri: (returnUri ?? this.returnUri),
      language: (language ?? this.language),
      applePayEnabled: (applePayEnabled ?? this.applePayEnabled),
      googlePayEnabled: (googlePayEnabled ?? this.googlePayEnabled),
      billingCollection: (billingCollection ?? this.billingCollection),
      allowsDelayedMethods: (allowsDelayedMethods ?? this.allowsDelayedMethods),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (merchantName.trim().isEmpty || merchantName.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'merchantName',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (merchantCountry.trim().isEmpty || merchantCountry.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'merchantCountry',
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
      if (returnUri.trim().isEmpty || returnUri.length > 4000)
        validationIssues.add(
          const PaymentIssue('returnUri', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (language.trim().isEmpty || language.length > 4000)
        validationIssues.add(
          const PaymentIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (billingCollection.trim().isEmpty || billingCollection.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'billingCollection',
            'text',
            'Use nonempty bounded text',
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
        !RegExp(r'^[A-Z]{2}$').hasMatch(merchantCountry) ||
        !{'test', 'live'}.contains(environment) ||
        !{'automatic', 'required', 'never'}.contains(billingCollection))
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
    "merchantName": merchantName,
    "merchantCountry": merchantCountry,
    "environment": environment,
    "returnUri": returnUri,
    "language": language,
    "applePayEnabled": applePayEnabled,
    "googlePayEnabled": googlePayEnabled,
    "billingCollection": billingCollection,
    "allowsDelayedMethods": allowsDelayedMethods,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentSdkConfiguration &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentSdkConfiguration(redacted)';
}
