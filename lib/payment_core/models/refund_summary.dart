// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentRefundSummary {
  PaymentRefundSummary({
    required this.orderId,
    required this.intentId,
    required this.evaluatedAt,
    required this.paid,
    this.refunded,
    this.pending,
    this.remaining,
    List<String> refundIds = const [],
    this.complete = false,
    List<String> reasonCodes = const [],
    this.refundInitiated = false,
  }) : refundIds = List.unmodifiable(refundIds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final String intentId;
  final DateTime evaluatedAt;
  final PaymentMoney paid;
  final PaymentMoney? refunded;
  final PaymentMoney? pending;
  final PaymentMoney? remaining;
  final List<String> refundIds;
  final bool complete;
  final List<String> reasonCodes;
  final bool refundInitiated;

  factory PaymentRefundSummary.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "intentId",
      "evaluatedAt",
      "paid",
      "refunded",
      "pending",
      "remaining",
      "refundIds",
      "complete",
      "reasonCodes",
      "refundInitiated",
    });
    final value = PaymentRefundSummary(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      paid: (json['paid'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['paid'])))!,
      refunded: json['refunded'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['refunded'])),
      pending: json['pending'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['pending'])),
      remaining: json['remaining'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['remaining'])),
      refundIds:
          PaymentCodec.list(json, 'refundIds', (v) {
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
      refundInitiated: PaymentCodec.boolean(json, 'refundInitiated') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentRefundSummary> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundSummary.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundSummary copyWith({
    Set<String> clear = const {},
    String? orderId,
    String? intentId,
    DateTime? evaluatedAt,
    PaymentMoney? paid,
    PaymentMoney? refunded,
    PaymentMoney? pending,
    PaymentMoney? remaining,
    List<String>? refundIds,
    bool? complete,
    List<String>? reasonCodes,
    bool? refundInitiated,
  }) {
    final clearableFields = <String>{"refunded", "pending", "remaining"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundSummary(
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      paid: (paid ?? this.paid),
      refunded: clear.contains('refunded') ? null : (refunded ?? this.refunded),
      pending: clear.contains('pending') ? null : (pending ?? this.pending),
      remaining: clear.contains('remaining')
          ? null
          : (remaining ?? this.remaining),
      refundIds: (refundIds ?? this.refundIds),
      complete: (complete ?? this.complete),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      refundInitiated: (refundInitiated ?? this.refundInitiated),
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
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
    if (refunded != null) {
      for (final issue in refunded!.validate())
        validationIssues.add(
          PaymentIssue(
            'refunded.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (pending != null) {
      for (final issue in pending!.validate())
        validationIssues.add(
          PaymentIssue(
            'pending.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (remaining != null) {
      for (final issue in remaining!.validate())
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
      if (refundIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'refundIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (refundIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'refundIds',
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
    if (refundInitiated)
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
    "orderId": orderId,
    "intentId": intentId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "paid": paid.toJson(),
    if (refunded != null) "refunded": refunded!.toJson(),
    if (pending != null) "pending": pending!.toJson(),
    if (remaining != null) "remaining": remaining!.toJson(),
    "refundIds": refundIds,
    "complete": complete,
    "reasonCodes": reasonCodes,
    "refundInitiated": refundInitiated,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundSummary &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundSummary(redacted)';
}
