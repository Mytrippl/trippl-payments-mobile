// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentInvoiceSummary {
  PaymentInvoiceSummary({
    required this.customerId,
    required this.currency,
    required this.evaluatedAt,
    required this.total,
    required this.paid,
    required this.remaining,
    required this.count,
    this.complete = false,
    List<String> overdueIds = const [],
    List<String> reasonCodes = const [],
  }) : overdueIds = List.unmodifiable(overdueIds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String customerId;
  final String currency;
  final DateTime evaluatedAt;
  final PaymentMoney total;
  final PaymentMoney paid;
  final PaymentMoney remaining;
  final int count;
  final bool complete;
  final List<String> overdueIds;
  final List<String> reasonCodes;

  factory PaymentInvoiceSummary.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "customerId",
      "currency",
      "evaluatedAt",
      "total",
      "paid",
      "remaining",
      "count",
      "complete",
      "overdueIds",
      "reasonCodes",
    });
    final value = PaymentInvoiceSummary(
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      paid: (json['paid'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['paid'])))!,
      remaining: (json['remaining'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['remaining'])))!,
      count: PaymentCodec.integer(
        json,
        'count',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      overdueIds:
          PaymentCodec.list(json, 'overdueIds', (v) {
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
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentInvoiceSummary> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoiceSummary.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoiceSummary copyWith({
    Set<String> clear = const {},
    String? customerId,
    String? currency,
    DateTime? evaluatedAt,
    PaymentMoney? total,
    PaymentMoney? paid,
    PaymentMoney? remaining,
    int? count,
    bool? complete,
    List<String>? overdueIds,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoiceSummary(
      customerId: (customerId ?? this.customerId),
      currency: (currency ?? this.currency),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      total: (total ?? this.total),
      paid: (paid ?? this.paid),
      remaining: (remaining ?? this.remaining),
      count: (count ?? this.count),
      complete: (complete ?? this.complete),
      overdueIds: (overdueIds ?? this.overdueIds),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in total.validate())
        validationIssues.add(
          PaymentIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in paid.validate())
        validationIssues.add(
          PaymentIssue(
            'paid.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in remaining.validate())
        validationIssues.add(
          PaymentIssue(
            'remaining.${issue.field}',
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
      if (overdueIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'overdueIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (overdueIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'overdueIds',
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
    "customerId": customerId,
    "currency": currency,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "total": total.toJson(),
    "paid": paid.toJson(),
    "remaining": remaining.toJson(),
    "count": count,
    "complete": complete,
    "overdueIds": overdueIds,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoiceSummary &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoiceSummary(redacted)';
}
