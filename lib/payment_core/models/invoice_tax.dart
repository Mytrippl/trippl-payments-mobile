// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentInvoiceTax {
  PaymentInvoiceTax({
    required this.id,
    required this.label,
    required this.jurisdictionCode,
    required this.taxableAmount,
    required this.amount,
    required this.rateBasisPoints,
    this.inclusive = false,
    this.taxIdentityId,
  });

  final String id;
  final String label;
  final String jurisdictionCode;
  final PaymentMoney taxableAmount;
  final PaymentMoney amount;
  final int rateBasisPoints;
  final bool inclusive;
  final String? taxIdentityId;

  factory PaymentInvoiceTax.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "label",
      "jurisdictionCode",
      "taxableAmount",
      "amount",
      "rateBasisPoints",
      "inclusive",
      "taxIdentityId",
    });
    final value = PaymentInvoiceTax(
      id: PaymentCodec.text(json, 'id', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      jurisdictionCode: PaymentCodec.text(
        json,
        'jurisdictionCode',
        required: true,
      )!,
      taxableAmount: (json['taxableAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['taxableAmount'])))!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      rateBasisPoints: PaymentCodec.integer(
        json,
        'rateBasisPoints',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      inclusive: PaymentCodec.boolean(json, 'inclusive') ?? false,
      taxIdentityId: PaymentCodec.text(json, 'taxIdentityId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentInvoiceTax> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoiceTax.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoiceTax copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    String? jurisdictionCode,
    PaymentMoney? taxableAmount,
    PaymentMoney? amount,
    int? rateBasisPoints,
    bool? inclusive,
    String? taxIdentityId,
  }) {
    final clearableFields = <String>{"taxIdentityId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoiceTax(
      id: (id ?? this.id),
      label: (label ?? this.label),
      jurisdictionCode: (jurisdictionCode ?? this.jurisdictionCode),
      taxableAmount: (taxableAmount ?? this.taxableAmount),
      amount: (amount ?? this.amount),
      rateBasisPoints: (rateBasisPoints ?? this.rateBasisPoints),
      inclusive: (inclusive ?? this.inclusive),
      taxIdentityId: clear.contains('taxIdentityId')
          ? null
          : (taxIdentityId ?? this.taxIdentityId),
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
      if (jurisdictionCode.trim().isEmpty || jurisdictionCode.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'jurisdictionCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      for (final issue in taxableAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'taxableAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
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
      if (rateBasisPoints < 0 || rateBasisPoints > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'rateBasisPoints',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (taxIdentityId != null) {
      if (taxIdentityId!.trim().isEmpty || taxIdentityId!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'taxIdentityId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (rateBasisPoints > 10000)
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
    "jurisdictionCode": jurisdictionCode,
    "taxableAmount": taxableAmount.toJson(),
    "amount": amount.toJson(),
    "rateBasisPoints": rateBasisPoints,
    "inclusive": inclusive,
    if (taxIdentityId != null) "taxIdentityId": taxIdentityId,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoiceTax && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoiceTax(redacted)';
}
