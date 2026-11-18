// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReadFailure {
  PaymentReadFailure({
    required this.code,
    required this.occurredAt,
    this.retryable = false,
    this.retryAfterSeconds,
    this.operation = "read",
  });

  final String code;
  final DateTime occurredAt;
  final bool retryable;
  final int? retryAfterSeconds;
  final String operation;

  factory PaymentReadFailure.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "code",
      "occurredAt",
      "retryable",
      "retryAfterSeconds",
      "operation",
    });
    final value = PaymentReadFailure(
      code: PaymentCodec.text(json, 'code', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      retryable: PaymentCodec.boolean(json, 'retryable') ?? false,
      retryAfterSeconds: PaymentCodec.integer(
        json,
        'retryAfterSeconds',
        minimum: 0,
        maximum: 9000000000000,
      ),
      operation: PaymentCodec.text(json, 'operation') ?? "read",
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentReadFailure> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadFailure.fromJson(PaymentCodec.object(input)),
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

  PaymentReadFailure copyWith({
    Set<String> clear = const {},
    String? code,
    DateTime? occurredAt,
    bool? retryable,
    int? retryAfterSeconds,
    String? operation,
  }) {
    final clearableFields = <String>{"retryAfterSeconds"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadFailure(
      code: (code ?? this.code),
      occurredAt: (occurredAt ?? this.occurredAt),
      retryable: (retryable ?? this.retryable),
      retryAfterSeconds: clear.contains('retryAfterSeconds')
          ? null
          : (retryAfterSeconds ?? this.retryAfterSeconds),
      operation: (operation ?? this.operation),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const PaymentIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    if (retryAfterSeconds != null) {
      if (retryAfterSeconds! < 0 || retryAfterSeconds! > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'retryAfterSeconds',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (operation.trim().isEmpty || operation.length > 4000)
        validationIssues.add(
          const PaymentIssue('operation', 'text', 'Use nonempty bounded text'),
        );
    }
    if (operation != 'read' ||
        !RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(code) ||
        retryAfterSeconds != null && retryAfterSeconds! > 120)
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
    "code": code,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "retryable": retryable,
    if (retryAfterSeconds != null) "retryAfterSeconds": retryAfterSeconds,
    "operation": operation,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadFailure &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadFailure(redacted)';
}
