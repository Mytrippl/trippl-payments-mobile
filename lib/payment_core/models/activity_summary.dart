// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentActivitySummary {
  PaymentActivitySummary({
    required this.evaluatedAt,
    required this.currency,
    required this.charges,
    required this.refunds,
    required this.count,
    List<String> pendingIds = const [],
    List<String> attentionIds = const [],
    this.complete = false,
    List<String> reasonCodes = const [],
  }) : pendingIds = List.unmodifiable(pendingIds),
       attentionIds = List.unmodifiable(attentionIds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final DateTime evaluatedAt;
  final String currency;
  final PaymentMoney charges;
  final PaymentMoney refunds;
  final int count;
  final List<String> pendingIds;
  final List<String> attentionIds;
  final bool complete;
  final List<String> reasonCodes;

  factory PaymentActivitySummary.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "evaluatedAt",
      "currency",
      "charges",
      "refunds",
      "count",
      "pendingIds",
      "attentionIds",
      "complete",
      "reasonCodes",
    });
    final value = PaymentActivitySummary(
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      charges: (json['charges'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['charges'])))!,
      refunds: (json['refunds'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['refunds'])))!,
      count: PaymentCodec.integer(
        json,
        'count',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      pendingIds:
          PaymentCodec.list(json, 'pendingIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      attentionIds:
          PaymentCodec.list(json, 'attentionIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentActivitySummary> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentActivitySummary.fromJson(PaymentCodec.object(input)),
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

  PaymentActivitySummary copyWith({
    Set<String> clear = const {},
    DateTime? evaluatedAt,
    String? currency,
    PaymentMoney? charges,
    PaymentMoney? refunds,
    int? count,
    List<String>? pendingIds,
    List<String>? attentionIds,
    bool? complete,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentActivitySummary(
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      currency: (currency ?? this.currency),
      charges: (charges ?? this.charges),
      refunds: (refunds ?? this.refunds),
      count: (count ?? this.count),
      pendingIds: (pendingIds ?? this.pendingIds),
      attentionIds: (attentionIds ?? this.attentionIds),
      complete: (complete ?? this.complete),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in charges.validate())
        validationIssues.add(
          PaymentIssue(
            'charges.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in refunds.validate())
        validationIssues.add(
          PaymentIssue(
            'refunds.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (count < 0 || count > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'count',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (pendingIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'pendingIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (pendingIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'pendingIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (attentionIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'attentionIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (attentionIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'attentionIds',
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
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "currency": currency,
    "charges": charges.toJson(),
    "refunds": refunds.toJson(),
    "count": count,
    "pendingIds": pendingIds,
    "attentionIds": attentionIds,
    "complete": complete,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentActivitySummary &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentActivitySummary(redacted)';
}
