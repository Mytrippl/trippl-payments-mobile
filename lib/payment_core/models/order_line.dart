// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentOrderLine {
  PaymentOrderLine({
    required this.id,
    required this.label,
    required this.unitAmount,
    this.quantity = 1,
    this.kind = "item",
    this.serviceId,
    this.taxIncluded = false,
    this.description,
  });

  final String id;
  final String label;
  final PaymentMoney unitAmount;
  final int quantity;
  final String kind;
  final String? serviceId;
  final bool taxIncluded;
  final String? description;

  factory PaymentOrderLine.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "label",
      "unitAmount",
      "quantity",
      "kind",
      "serviceId",
      "taxIncluded",
      "description",
    });
    final value = PaymentOrderLine(
      id: PaymentCodec.text(json, 'id', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      unitAmount: (json['unitAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['unitAmount'])))!,
      quantity:
          PaymentCodec.integer(
            json,
            'quantity',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      kind: PaymentCodec.text(json, 'kind') ?? "item",
      serviceId: PaymentCodec.text(json, 'serviceId'),
      taxIncluded: PaymentCodec.boolean(json, 'taxIncluded') ?? false,
      description: PaymentCodec.text(json, 'description'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentOrderLine> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentOrderLine.fromJson(PaymentCodec.object(input)),
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

  PaymentOrderLine copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    PaymentMoney? unitAmount,
    int? quantity,
    String? kind,
    String? serviceId,
    bool? taxIncluded,
    String? description,
  }) {
    final clearableFields = <String>{"serviceId", "description"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentOrderLine(
      id: (id ?? this.id),
      label: (label ?? this.label),
      unitAmount: (unitAmount ?? this.unitAmount),
      quantity: (quantity ?? this.quantity),
      kind: (kind ?? this.kind),
      serviceId: clear.contains('serviceId')
          ? null
          : (serviceId ?? this.serviceId),
      taxIncluded: (taxIncluded ?? this.taxIncluded),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
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
      for (final issue in unitAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'unitAmount.${issue.field}',
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
    if (serviceId != null) {
      if (serviceId!.trim().isEmpty || serviceId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('serviceId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (description != null) {
      if (description!.trim().isEmpty || description!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'description',
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
    "unitAmount": unitAmount.toJson(),
    "quantity": quantity,
    "kind": kind,
    if (serviceId != null) "serviceId": serviceId,
    "taxIncluded": taxIncluded,
    if (description != null) "description": description,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentOrderLine && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentOrderLine(redacted)';
}
