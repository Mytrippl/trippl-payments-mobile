// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCachePolicy {
  PaymentCachePolicy({
    this.enabled = false,
    this.maximumAgeSeconds = 300,
    this.maximumBytes = 500000,
    this.maximumEntries = 20,
    this.allowOfflineDisplay = false,
    this.schemaVersion = 1,
  });

  final bool enabled;
  final int maximumAgeSeconds;
  final int maximumBytes;
  final int maximumEntries;
  final bool allowOfflineDisplay;
  final int schemaVersion;

  factory PaymentCachePolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "enabled",
      "maximumAgeSeconds",
      "maximumBytes",
      "maximumEntries",
      "allowOfflineDisplay",
      "schemaVersion",
    });
    final value = PaymentCachePolicy(
      enabled: PaymentCodec.boolean(json, 'enabled') ?? false,
      maximumAgeSeconds:
          PaymentCodec.integer(
            json,
            'maximumAgeSeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          300,
      maximumBytes:
          PaymentCodec.integer(
            json,
            'maximumBytes',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          500000,
      maximumEntries:
          PaymentCodec.integer(
            json,
            'maximumEntries',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
      allowOfflineDisplay:
          PaymentCodec.boolean(json, 'allowOfflineDisplay') ?? false,
      schemaVersion:
          PaymentCodec.integer(
            json,
            'schemaVersion',
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

  static PaymentResult<PaymentCachePolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCachePolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentCachePolicy copyWith({
    Set<String> clear = const {},
    bool? enabled,
    int? maximumAgeSeconds,
    int? maximumBytes,
    int? maximumEntries,
    bool? allowOfflineDisplay,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCachePolicy(
      enabled: (enabled ?? this.enabled),
      maximumAgeSeconds: (maximumAgeSeconds ?? this.maximumAgeSeconds),
      maximumBytes: (maximumBytes ?? this.maximumBytes),
      maximumEntries: (maximumEntries ?? this.maximumEntries),
      allowOfflineDisplay: (allowOfflineDisplay ?? this.allowOfflineDisplay),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (maximumAgeSeconds < 0 || maximumAgeSeconds > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumAgeSeconds',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (maximumBytes < 0 || maximumBytes > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumBytes',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (maximumEntries < 0 || maximumEntries > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumEntries',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (schemaVersion < 0 || schemaVersion > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'schemaVersion',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (schemaVersion != 1 ||
        maximumAgeSeconds < 1 ||
        maximumAgeSeconds > 3600 ||
        maximumBytes < 1024 ||
        maximumBytes > 1000000 ||
        maximumEntries < 1 ||
        maximumEntries > 100)
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
    "enabled": enabled,
    "maximumAgeSeconds": maximumAgeSeconds,
    "maximumBytes": maximumBytes,
    "maximumEntries": maximumEntries,
    "allowOfflineDisplay": allowOfflineDisplay,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCachePolicy &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCachePolicy(redacted)';
}
