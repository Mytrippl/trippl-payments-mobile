// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentInstallment {
  PaymentInstallment({
    required this.id,
    required this.sequence,
    required this.amount,
    required this.dueAt,
    required this.status,
    this.intentId,
    this.paidAt,
    this.requiresCustomerAction = true,
    this.automaticCharge = false,
  });

  final String id;
  final int sequence;
  final PaymentMoney amount;
  final DateTime dueAt;
  final String status;
  final String? intentId;
  final DateTime? paidAt;
  final bool requiresCustomerAction;
  final bool automaticCharge;

  factory PaymentInstallment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "sequence",
      "amount",
      "dueAt",
      "status",
      "intentId",
      "paidAt",
      "requiresCustomerAction",
      "automaticCharge",
    });
    final value = PaymentInstallment(
      id: PaymentCodec.text(json, 'id', required: true)!,
      sequence: PaymentCodec.integer(
        json,
        'sequence',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      dueAt: PaymentCodec.date(json, 'dueAt', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      paidAt: PaymentCodec.date(json, 'paidAt'),
      requiresCustomerAction:
          PaymentCodec.boolean(json, 'requiresCustomerAction') ?? true,
      automaticCharge: PaymentCodec.boolean(json, 'automaticCharge') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentInstallment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInstallment.fromJson(PaymentCodec.object(input)),
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

  PaymentInstallment copyWith({
    Set<String> clear = const {},
    String? id,
    int? sequence,
    PaymentMoney? amount,
    DateTime? dueAt,
    String? status,
    String? intentId,
    DateTime? paidAt,
    bool? requiresCustomerAction,
    bool? automaticCharge,
  }) {
    final clearableFields = <String>{"intentId", "paidAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInstallment(
      id: (id ?? this.id),
      sequence: (sequence ?? this.sequence),
      amount: (amount ?? this.amount),
      dueAt: (dueAt ?? this.dueAt),
      status: (status ?? this.status),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      paidAt: clear.contains('paidAt') ? null : (paidAt ?? this.paidAt),
      requiresCustomerAction:
          (requiresCustomerAction ?? this.requiresCustomerAction),
      automaticCharge: (automaticCharge ?? this.automaticCharge),
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
      if (sequence < 0 || sequence > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'sequence',
            'range',
            'Number is outside the payment limits',
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
    if (sequence < 1 ||
        sequence > 24 ||
        automaticCharge ||
        !{
          'scheduled',
          'due',
          'processing',
          'paid',
          'failed',
          'cancelled',
          'unknown',
        }.contains(status))
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
    "sequence": sequence,
    "amount": amount.toJson(),
    "dueAt": dueAt.toUtc().toIso8601String(),
    "status": status,
    if (intentId != null) "intentId": intentId,
    if (paidAt != null) "paidAt": paidAt!.toUtc().toIso8601String(),
    "requiresCustomerAction": requiresCustomerAction,
    "automaticCharge": automaticCharge,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInstallment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInstallment(redacted)';
}
