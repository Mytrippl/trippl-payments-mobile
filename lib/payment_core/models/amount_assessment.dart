// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentAmountAssessment {
  PaymentAmountAssessment({
    required this.orderId,
    required this.evaluatedAt,
    this.valid = false,
    List<String> reasonCodes = const [],
    this.expected,
    this.received,
    this.requiresServerReview = true,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final DateTime evaluatedAt;
  final bool valid;
  final List<String> reasonCodes;
  final PaymentMoney? expected;
  final PaymentMoney? received;
  final bool requiresServerReview;

  factory PaymentAmountAssessment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "evaluatedAt",
      "valid",
      "reasonCodes",
      "expected",
      "received",
      "requiresServerReview",
    });
    final value = PaymentAmountAssessment(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      valid: PaymentCodec.boolean(json, 'valid') ?? false,
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      expected: json['expected'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['expected'])),
      received: json['received'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['received'])),
      requiresServerReview:
          PaymentCodec.boolean(json, 'requiresServerReview') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentAmountAssessment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAmountAssessment.fromJson(PaymentCodec.object(input)),
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

  PaymentAmountAssessment copyWith({
    Set<String> clear = const {},
    String? orderId,
    DateTime? evaluatedAt,
    bool? valid,
    List<String>? reasonCodes,
    PaymentMoney? expected,
    PaymentMoney? received,
    bool? requiresServerReview,
  }) {
    final clearableFields = <String>{"expected", "received"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAmountAssessment(
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      valid: (valid ?? this.valid),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      expected: clear.contains('expected') ? null : (expected ?? this.expected),
      received: clear.contains('received') ? null : (received ?? this.received),
      requiresServerReview: (requiresServerReview ?? this.requiresServerReview),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (expected != null) {
      for (final issue in expected!.validate())
        validationIssues.add(
          PaymentIssue(
            'expected.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (received != null) {
      for (final issue in received!.validate())
        validationIssues.add(
          PaymentIssue(
            'received.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "orderId": orderId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "valid": valid,
    "reasonCodes": reasonCodes,
    if (expected != null) "expected": expected!.toJson(),
    if (received != null) "received": received!.toJson(),
    "requiresServerReview": requiresServerReview,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAmountAssessment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAmountAssessment(redacted)';
}
