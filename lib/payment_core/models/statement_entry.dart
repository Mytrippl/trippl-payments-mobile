// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentStatementEntry {
  PaymentStatementEntry({
    required this.id,
    required this.orderId,
    required this.occurredAt,
    required this.kind,
    required this.amount,
    required this.status,
    this.intentId,
    this.invoiceId,
    this.refundId,
    this.label,
  });

  final String id;
  final String orderId;
  final DateTime occurredAt;
  final String kind;
  final PaymentMoney amount;
  final String status;
  final String? intentId;
  final String? invoiceId;
  final String? refundId;
  final String? label;

  factory PaymentStatementEntry.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "orderId",
      "occurredAt",
      "kind",
      "amount",
      "status",
      "intentId",
      "invoiceId",
      "refundId",
      "label",
    });
    final value = PaymentStatementEntry(
      id: PaymentCodec.text(json, 'id', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      invoiceId: PaymentCodec.text(json, 'invoiceId'),
      refundId: PaymentCodec.text(json, 'refundId'),
      label: PaymentCodec.text(json, 'label'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentStatementEntry> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentStatementEntry.fromJson(PaymentCodec.object(input)),
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

  PaymentStatementEntry copyWith({
    Set<String> clear = const {},
    String? id,
    String? orderId,
    DateTime? occurredAt,
    String? kind,
    PaymentMoney? amount,
    String? status,
    String? intentId,
    String? invoiceId,
    String? refundId,
    String? label,
  }) {
    final clearableFields = <String>{
      "intentId",
      "invoiceId",
      "refundId",
      "label",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentStatementEntry(
      id: (id ?? this.id),
      orderId: (orderId ?? this.orderId),
      occurredAt: (occurredAt ?? this.occurredAt),
      kind: (kind ?? this.kind),
      amount: (amount ?? this.amount),
      status: (status ?? this.status),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      invoiceId: clear.contains('invoiceId')
          ? null
          : (invoiceId ?? this.invoiceId),
      refundId: clear.contains('refundId') ? null : (refundId ?? this.refundId),
      label: clear.contains('label') ? null : (label ?? this.label),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const PaymentIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in amount.validate())
        validationIssues.add(
          PaymentIssue(
            'amount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (invoiceId != null) {
      if (invoiceId!.trim().isEmpty || invoiceId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('invoiceId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (refundId != null) {
      if (refundId!.trim().isEmpty || refundId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('refundId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (label != null) {
      if (label!.trim().isEmpty || label!.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'charge', 'refund', 'authorization', 'adjustment'}.contains(kind) ||
        !{'pending', 'posted', 'reversed', 'unknown'}.contains(status))
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
    "id": id,
    "orderId": orderId,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "kind": kind,
    "amount": amount.toJson(),
    "status": status,
    if (intentId != null) "intentId": intentId,
    if (invoiceId != null) "invoiceId": invoiceId,
    if (refundId != null) "refundId": refundId,
    if (label != null) "label": label,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentStatementEntry &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentStatementEntry(redacted)';
}
