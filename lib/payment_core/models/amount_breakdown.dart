// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentAmountBreakdown {
  PaymentAmountBreakdown({
    required this.orderId,
    required this.evaluatedAt,
    required this.subtotal,
    required this.tax,
    required this.fees,
    required this.discounts,
    required this.credits,
    required this.total,
    this.reconciled = false,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final DateTime evaluatedAt;
  final PaymentMoney subtotal;
  final PaymentMoney tax;
  final PaymentMoney fees;
  final PaymentMoney discounts;
  final PaymentMoney credits;
  final PaymentMoney total;
  final bool reconciled;
  final List<String> reasonCodes;

  factory PaymentAmountBreakdown.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "evaluatedAt",
      "subtotal",
      "tax",
      "fees",
      "discounts",
      "credits",
      "total",
      "reconciled",
      "reasonCodes",
    });
    final value = PaymentAmountBreakdown(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      subtotal: (json['subtotal'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['subtotal'])))!,
      tax: (json['tax'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['tax'])))!,
      fees: (json['fees'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['fees'])))!,
      discounts: (json['discounts'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['discounts'])))!,
      credits: (json['credits'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['credits'])))!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      reconciled: PaymentCodec.boolean(json, 'reconciled') ?? false,
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

  static PaymentResult<PaymentAmountBreakdown> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAmountBreakdown.fromJson(PaymentCodec.object(input)),
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

  PaymentAmountBreakdown copyWith({
    Set<String> clear = const {},
    String? orderId,
    DateTime? evaluatedAt,
    PaymentMoney? subtotal,
    PaymentMoney? tax,
    PaymentMoney? fees,
    PaymentMoney? discounts,
    PaymentMoney? credits,
    PaymentMoney? total,
    bool? reconciled,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAmountBreakdown(
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      subtotal: (subtotal ?? this.subtotal),
      tax: (tax ?? this.tax),
      fees: (fees ?? this.fees),
      discounts: (discounts ?? this.discounts),
      credits: (credits ?? this.credits),
      total: (total ?? this.total),
      reconciled: (reconciled ?? this.reconciled),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
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
      for (final issue in subtotal.validate())
        validationIssues.add(
          PaymentIssue(
            'subtotal.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in tax.validate())
        validationIssues.add(
          PaymentIssue(
            'tax.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in fees.validate())
        validationIssues.add(
          PaymentIssue(
            'fees.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in discounts.validate())
        validationIssues.add(
          PaymentIssue(
            'discounts.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in credits.validate())
        validationIssues.add(
          PaymentIssue(
            'credits.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
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
    "orderId": orderId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "subtotal": subtotal.toJson(),
    "tax": tax.toJson(),
    "fees": fees.toJson(),
    "discounts": discounts.toJson(),
    "credits": credits.toJson(),
    "total": total.toJson(),
    "reconciled": reconciled,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAmountBreakdown &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAmountBreakdown(redacted)';
}
