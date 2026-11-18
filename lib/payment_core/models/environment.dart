// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentEnvironment {
  PaymentEnvironment({
    required this.mode,
    required this.merchantCountry,
    required this.publishableKeyFingerprint,
    required this.configuredAt,
    this.sdkReady = false,
    this.version = 1,
  });

  final String mode;
  final String merchantCountry;
  final String publishableKeyFingerprint;
  final DateTime configuredAt;
  final bool sdkReady;
  final int version;

  factory PaymentEnvironment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "mode",
      "merchantCountry",
      "publishableKeyFingerprint",
      "configuredAt",
      "sdkReady",
      "version",
    });
    final value = PaymentEnvironment(
      mode: PaymentCodec.text(json, 'mode', required: true)!,
      merchantCountry: PaymentCodec.text(
        json,
        'merchantCountry',
        required: true,
      )!,
      publishableKeyFingerprint: PaymentCodec.text(
        json,
        'publishableKeyFingerprint',
        required: true,
      )!,
      configuredAt: PaymentCodec.date(json, 'configuredAt', required: true)!,
      sdkReady: PaymentCodec.boolean(json, 'sdkReady') ?? false,
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

  static PaymentResult<PaymentEnvironment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentEnvironment.fromJson(PaymentCodec.object(input)),
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

  PaymentEnvironment copyWith({
    Set<String> clear = const {},
    String? mode,
    String? merchantCountry,
    String? publishableKeyFingerprint,
    DateTime? configuredAt,
    bool? sdkReady,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentEnvironment(
      mode: (mode ?? this.mode),
      merchantCountry: (merchantCountry ?? this.merchantCountry),
      publishableKeyFingerprint:
          (publishableKeyFingerprint ?? this.publishableKeyFingerprint),
      configuredAt: (configuredAt ?? this.configuredAt),
      sdkReady: (sdkReady ?? this.sdkReady),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (mode.trim().isEmpty || mode.length > 4000)
        validationIssues.add(
          const PaymentIssue('mode', 'text', 'Use nonempty bounded text'),
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
      if (publishableKeyFingerprint.trim().isEmpty ||
          publishableKeyFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'publishableKeyFingerprint',
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
        !{'test', 'live'}.contains(mode) ||
        !RegExp(r'^[A-Z]{2}$').hasMatch(merchantCountry) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(publishableKeyFingerprint))
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
    "mode": mode,
    "merchantCountry": merchantCountry,
    "publishableKeyFingerprint": publishableKeyFingerprint,
    "configuredAt": configuredAt.toUtc().toIso8601String(),
    "sdkReady": sdkReady,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentEnvironment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentEnvironment(redacted)';
}
