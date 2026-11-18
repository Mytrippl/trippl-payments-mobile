// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentLedgerReconciliation {
  PaymentLedgerReconciliation({
    required this.statementId,
    required this.orderId,
    required this.evaluatedAt,
    required this.expected,
    required this.posted,
    required this.matched,
    List<String> missingReferences = const [],
    List<String> unexpectedReferences = const [],
    List<String> reasonCodes = const [],
    this.paymentConfirmed = false,
  }) : missingReferences = List.unmodifiable(missingReferences),
       unexpectedReferences = List.unmodifiable(unexpectedReferences),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String statementId;
  final String orderId;
  final DateTime evaluatedAt;
  final PaymentMoney expected;
  final PaymentMoney posted;
  final bool matched;
  final List<String> missingReferences;
  final List<String> unexpectedReferences;
  final List<String> reasonCodes;
  final bool paymentConfirmed;

  factory PaymentLedgerReconciliation.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "statementId",
      "orderId",
      "evaluatedAt",
      "expected",
      "posted",
      "matched",
      "missingReferences",
      "unexpectedReferences",
      "reasonCodes",
      "paymentConfirmed",
    });
    final value = PaymentLedgerReconciliation(
      statementId: PaymentCodec.text(json, 'statementId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      expected: (json['expected'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['expected'])))!,
      posted: (json['posted'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['posted'])))!,
      matched: PaymentCodec.boolean(json, 'matched', required: true)!,
      missingReferences:
          PaymentCodec.list(json, 'missingReferences', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      unexpectedReferences:
          PaymentCodec.list(json, 'unexpectedReferences', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      paymentConfirmed: PaymentCodec.boolean(json, 'paymentConfirmed') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentLedgerReconciliation> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentLedgerReconciliation.fromJson(PaymentCodec.object(input)),
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

  PaymentLedgerReconciliation copyWith({
    Set<String> clear = const {},
    String? statementId,
    String? orderId,
    DateTime? evaluatedAt,
    PaymentMoney? expected,
    PaymentMoney? posted,
    bool? matched,
    List<String>? missingReferences,
    List<String>? unexpectedReferences,
    List<String>? reasonCodes,
    bool? paymentConfirmed,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentLedgerReconciliation(
      statementId: (statementId ?? this.statementId),
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      expected: (expected ?? this.expected),
      posted: (posted ?? this.posted),
      matched: (matched ?? this.matched),
      missingReferences: (missingReferences ?? this.missingReferences),
      unexpectedReferences: (unexpectedReferences ?? this.unexpectedReferences),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      paymentConfirmed: (paymentConfirmed ?? this.paymentConfirmed),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (statementId.trim().isEmpty || statementId.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'statementId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in expected.validate())
        validationIssues.add(
          PaymentIssue(
            'expected.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in posted.validate())
        validationIssues.add(
          PaymentIssue(
            'posted.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (missingReferences.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'missingReferences',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (missingReferences.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'missingReferences',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (unexpectedReferences.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'unexpectedReferences',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (unexpectedReferences.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'unexpectedReferences',
            'text',
            'Use bounded nonempty list text',
          ),
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
    if (paymentConfirmed)
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
    "statementId": statementId,
    "orderId": orderId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "expected": expected.toJson(),
    "posted": posted.toJson(),
    "matched": matched,
    "missingReferences": missingReferences,
    "unexpectedReferences": unexpectedReferences,
    "reasonCodes": reasonCodes,
    "paymentConfirmed": paymentConfirmed,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentLedgerReconciliation &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentLedgerReconciliation(redacted)';
}
