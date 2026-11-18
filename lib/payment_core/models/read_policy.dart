// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReadPolicy {
  PaymentReadPolicy({
    this.timeoutSeconds = 15,
    this.maximumInflight = 4,
    this.maximumAgeSeconds = 300,
    this.maximumPages = 5,
    this.maximumRecords = 100,
    this.version = 1,
  });

  final int timeoutSeconds;
  final int maximumInflight;
  final int maximumAgeSeconds;
  final int maximumPages;
  final int maximumRecords;
  final int version;

  factory PaymentReadPolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "timeoutSeconds",
      "maximumInflight",
      "maximumAgeSeconds",
      "maximumPages",
      "maximumRecords",
      "version",
    });
    final value = PaymentReadPolicy(
      timeoutSeconds:
          PaymentCodec.integer(
            json,
            'timeoutSeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          15,
      maximumInflight:
          PaymentCodec.integer(
            json,
            'maximumInflight',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          4,
      maximumAgeSeconds:
          PaymentCodec.integer(
            json,
            'maximumAgeSeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          300,
      maximumPages:
          PaymentCodec.integer(
            json,
            'maximumPages',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          5,
      maximumRecords:
          PaymentCodec.integer(
            json,
            'maximumRecords',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
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

  static PaymentResult<PaymentReadPolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadPolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentReadPolicy copyWith({
    Set<String> clear = const {},
    int? timeoutSeconds,
    int? maximumInflight,
    int? maximumAgeSeconds,
    int? maximumPages,
    int? maximumRecords,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadPolicy(
      timeoutSeconds: (timeoutSeconds ?? this.timeoutSeconds),
      maximumInflight: (maximumInflight ?? this.maximumInflight),
      maximumAgeSeconds: (maximumAgeSeconds ?? this.maximumAgeSeconds),
      maximumPages: (maximumPages ?? this.maximumPages),
      maximumRecords: (maximumRecords ?? this.maximumRecords),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (timeoutSeconds < 0 || timeoutSeconds > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'timeoutSeconds',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (maximumInflight < 0 || maximumInflight > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumInflight',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
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
      if (maximumPages < 0 || maximumPages > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumPages',
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
        timeoutSeconds < 1 ||
        timeoutSeconds > 120 ||
        maximumInflight < 1 ||
        maximumInflight > 8 ||
        maximumAgeSeconds < 1 ||
        maximumAgeSeconds > 3600 ||
        maximumPages < 1 ||
        maximumPages > 20 ||
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
    "timeoutSeconds": timeoutSeconds,
    "maximumInflight": maximumInflight,
    "maximumAgeSeconds": maximumAgeSeconds,
    "maximumPages": maximumPages,
    "maximumRecords": maximumRecords,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadPolicy && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadPolicy(redacted)';
}
