// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentInvoiceLine {
  PaymentInvoiceLine({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitAmount,
    required this.netAmount,
    required this.taxAmount,
    required this.total,
    this.taxInclusive = false,
    this.orderLineId,
  });

  final String id;
  final String description;
  final int quantity;
  final PaymentMoney unitAmount;
  final PaymentMoney netAmount;
  final PaymentMoney taxAmount;
  final PaymentMoney total;
  final bool taxInclusive;
  final String? orderLineId;

  factory PaymentInvoiceLine.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "description",
      "quantity",
      "unitAmount",
      "netAmount",
      "taxAmount",
      "total",
      "taxInclusive",
      "orderLineId",
    });
    final value = PaymentInvoiceLine(
      id: PaymentCodec.text(json, 'id', required: true)!,
      description: PaymentCodec.text(json, 'description', required: true)!,
      quantity: PaymentCodec.integer(
        json,
        'quantity',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      unitAmount: (json['unitAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['unitAmount'])))!,
      netAmount: (json['netAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['netAmount'])))!,
      taxAmount: (json['taxAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['taxAmount'])))!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      taxInclusive: PaymentCodec.boolean(json, 'taxInclusive') ?? false,
      orderLineId: PaymentCodec.text(json, 'orderLineId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentInvoiceLine> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoiceLine.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoiceLine copyWith({
    Set<String> clear = const {},
    String? id,
    String? description,
    int? quantity,
    PaymentMoney? unitAmount,
    PaymentMoney? netAmount,
    PaymentMoney? taxAmount,
    PaymentMoney? total,
    bool? taxInclusive,
    String? orderLineId,
  }) {
    final clearableFields = <String>{"orderLineId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoiceLine(
      id: (id ?? this.id),
      description: (description ?? this.description),
      quantity: (quantity ?? this.quantity),
      unitAmount: (unitAmount ?? this.unitAmount),
      netAmount: (netAmount ?? this.netAmount),
      taxAmount: (taxAmount ?? this.taxAmount),
      total: (total ?? this.total),
      taxInclusive: (taxInclusive ?? this.taxInclusive),
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
      if (description.trim().isEmpty || description.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'description',
            'text',
            'Use nonempty bounded text',
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
      for (final issue in netAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'netAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in taxAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'taxAmount.${issue.field}',
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
    if (quantity < 1 || quantity > 100)
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
    "description": description,
    "quantity": quantity,
    "unitAmount": unitAmount.toJson(),
    "netAmount": netAmount.toJson(),
    "taxAmount": taxAmount.toJson(),
    "total": total.toJson(),
    "taxInclusive": taxInclusive,
    if (orderLineId != null) "orderLineId": orderLineId,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoiceLine &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoiceLine(redacted)';
}
