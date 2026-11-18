// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentRetryPolicy {
  PaymentRetryPolicy({
    this.maximumReadAttempts = 2,
    this.initialDelaySeconds = 2,
    this.maximumDelaySeconds = 30,
    this.allowMutationRetry = false,
    this.version = 1,
  });

  final int maximumReadAttempts;
  final int initialDelaySeconds;
  final int maximumDelaySeconds;
  final bool allowMutationRetry;
  final int version;

  factory PaymentRetryPolicy.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "maximumReadAttempts",
      "initialDelaySeconds",
      "maximumDelaySeconds",
      "allowMutationRetry",
      "version",
    });
    final value = PaymentRetryPolicy(
      maximumReadAttempts:
          PaymentCodec.integer(
            json,
            'maximumReadAttempts',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          2,
      initialDelaySeconds:
          PaymentCodec.integer(
            json,
            'initialDelaySeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          2,
      maximumDelaySeconds:
          PaymentCodec.integer(
            json,
            'maximumDelaySeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          30,
      allowMutationRetry:
          PaymentCodec.boolean(json, 'allowMutationRetry') ?? false,
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

  static PaymentResult<PaymentRetryPolicy> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRetryPolicy.fromJson(PaymentCodec.object(input)),
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

  PaymentRetryPolicy copyWith({
    Set<String> clear = const {},
    int? maximumReadAttempts,
    int? initialDelaySeconds,
    int? maximumDelaySeconds,
    bool? allowMutationRetry,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRetryPolicy(
      maximumReadAttempts: (maximumReadAttempts ?? this.maximumReadAttempts),
      initialDelaySeconds: (initialDelaySeconds ?? this.initialDelaySeconds),
      maximumDelaySeconds: (maximumDelaySeconds ?? this.maximumDelaySeconds),
      allowMutationRetry: (allowMutationRetry ?? this.allowMutationRetry),
      version: (version ?? this.version),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (maximumReadAttempts < 0 || maximumReadAttempts > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumReadAttempts',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (initialDelaySeconds < 0 || initialDelaySeconds > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'initialDelaySeconds',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (maximumDelaySeconds < 0 || maximumDelaySeconds > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumDelaySeconds',
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
        maximumReadAttempts < 1 ||
        maximumReadAttempts > 3 ||
        initialDelaySeconds < 1 ||
        maximumDelaySeconds < initialDelaySeconds ||
        maximumDelaySeconds > 120 ||
        allowMutationRetry)
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
    "maximumReadAttempts": maximumReadAttempts,
    "initialDelaySeconds": initialDelaySeconds,
    "maximumDelaySeconds": maximumDelaySeconds,
    "allowMutationRetry": allowMutationRetry,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRetryPolicy &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRetryPolicy(redacted)';
}
