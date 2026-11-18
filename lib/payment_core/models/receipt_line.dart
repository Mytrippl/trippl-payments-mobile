// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentReceiptLine {
  PaymentReceiptLine({
    required this.id,
    required this.label,
    required this.amount,
    this.quantity = 1,
    this.kind = "item",
    this.orderLineId,
  });

  final String id;
  final String label;
  final PaymentMoney amount;
  final int quantity;
  final String kind;
  final String? orderLineId;

  factory PaymentReceiptLine.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "label",
      "amount",
      "quantity",
      "kind",
      "orderLineId",
    });
    final value = PaymentReceiptLine(
      id: PaymentCodec.text(json, 'id', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      quantity:
          PaymentCodec.integer(
            json,
            'quantity',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      kind: PaymentCodec.text(json, 'kind') ?? "item",
      orderLineId: PaymentCodec.text(json, 'orderLineId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentReceiptLine> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReceiptLine.fromJson(PaymentCodec.object(input)),
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

  PaymentReceiptLine copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    PaymentMoney? amount,
    int? quantity,
    String? kind,
    String? orderLineId,
  }) {
    final clearableFields = <String>{"orderLineId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReceiptLine(
      id: (id ?? this.id),
      label: (label ?? this.label),
      amount: (amount ?? this.amount),
      quantity: (quantity ?? this.quantity),
      kind: (kind ?? this.kind),
      orderLineId: clear.contains('orderLineId')
          ? null
          : (orderLineId ?? this.orderLineId),
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
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
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
      if (quantity < 0 || quantity > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'quantity',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (orderLineId != null) {
      if (orderLineId!.trim().isEmpty || orderLineId!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'orderLineId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (quantity < 1 ||
        quantity > 100 ||
        !{'item', 'tax', 'fee', 'discount', 'credit'}.contains(kind))
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
    "label": label,
    "amount": amount.toJson(),
    "quantity": quantity,
    "kind": kind,
    if (orderLineId != null) "orderLineId": orderLineId,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReceiptLine &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReceiptLine(redacted)';
}
