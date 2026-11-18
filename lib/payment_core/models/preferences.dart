// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentPreferences {
  PaymentPreferences({
    required this.scopeFingerprint,
    required this.updatedAt,
    this.language = "en",
    this.showSavedMethods = true,
    this.preferWallet = false,
    this.revision = 1,
  });

  final String scopeFingerprint;
  final DateTime updatedAt;
  final String language;
  final bool showSavedMethods;
  final bool preferWallet;
  final int revision;

  factory PaymentPreferences.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "updatedAt",
      "language",
      "showSavedMethods",
      "preferWallet",
      "revision",
    });
    final value = PaymentPreferences(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      language: PaymentCodec.text(json, 'language') ?? "en",
      showSavedMethods: PaymentCodec.boolean(json, 'showSavedMethods') ?? true,
      preferWallet: PaymentCodec.boolean(json, 'preferWallet') ?? false,
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

  static PaymentResult<PaymentPreferences> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentPreferences.fromJson(PaymentCodec.object(input)),
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

  PaymentPreferences copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    DateTime? updatedAt,
    String? language,
    bool? showSavedMethods,
    bool? preferWallet,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentPreferences(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      updatedAt: (updatedAt ?? this.updatedAt),
      language: (language ?? this.language),
      showSavedMethods: (showSavedMethods ?? this.showSavedMethods),
      preferWallet: (preferWallet ?? this.preferWallet),
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
      if (language.trim().isEmpty || language.length > 4000)
        validationIssues.add(
          const PaymentIssue('language', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1)
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
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "language": language,
    "showSavedMethods": showSavedMethods,
    "preferWallet": preferWallet,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentPreferences &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentPreferences(redacted)';
}
