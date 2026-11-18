// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentAdjustment {
  PaymentAdjustment({
    required this.id,
    required this.kind,
    required this.amount,
    this.included = true,
    this.label,
    this.sourceReference,
    this.confirmed = false,
    this.revision = 1,
  });

  final String id;
  final String kind;
  final PaymentMoney amount;
  final bool included;
  final String? label;
  final String? sourceReference;
  final bool confirmed;
  final int revision;

  factory PaymentAdjustment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "kind",
      "amount",
      "included",
      "label",
      "sourceReference",
      "confirmed",
      "revision",
    });
    final value = PaymentAdjustment(
      id: PaymentCodec.text(json, 'id', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      included: PaymentCodec.boolean(json, 'included') ?? true,
      label: PaymentCodec.text(json, 'label'),
      sourceReference: PaymentCodec.text(json, 'sourceReference'),
      confirmed: PaymentCodec.boolean(json, 'confirmed') ?? false,
      revision:
          PaymentCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentAdjustment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAdjustment.fromJson(PaymentCodec.object(input)),
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

  PaymentAdjustment copyWith({
    Set<String> clear = const {},
    String? id,
    String? kind,
    PaymentMoney? amount,
    bool? included,
    String? label,
    String? sourceReference,
    bool? confirmed,
    int? revision,
  }) {
    final clearableFields = <String>{"label", "sourceReference"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAdjustment(
      id: (id ?? this.id),
      kind: (kind ?? this.kind),
      amount: (amount ?? this.amount),
      included: (included ?? this.included),
      label: clear.contains('label') ? null : (label ?? this.label),
      sourceReference: clear.contains('sourceReference')
          ? null
          : (sourceReference ?? this.sourceReference),
      confirmed: (confirmed ?? this.confirmed),
      revision: (revision ?? this.revision),
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
    if (label != null) {
      if (label!.trim().isEmpty || label!.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    if (sourceReference != null) {
      if (sourceReference!.trim().isEmpty || sourceReference!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'sourceReference',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'revision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (revision < 1 || !{'tax', 'fee', 'discount', 'credit'}.contains(kind))
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
    "kind": kind,
    "amount": amount.toJson(),
    "included": included,
    if (label != null) "label": label,
    if (sourceReference != null) "sourceReference": sourceReference,
    "confirmed": confirmed,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAdjustment && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAdjustment(redacted)';
}
