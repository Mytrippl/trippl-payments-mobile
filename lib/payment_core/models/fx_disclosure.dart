// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentFxDisclosure {
  PaymentFxDisclosure({
    required this.quoteId,
    required this.orderId,
    required this.sourceAmount,
    required this.displayAmount,
    required this.fee,
    required this.expiresAt,
    required this.label,
    this.displayOnly = true,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String quoteId;
  final String orderId;
  final PaymentMoney sourceAmount;
  final PaymentMoney displayAmount;
  final PaymentMoney fee;
  final DateTime expiresAt;
  final String label;
  final bool displayOnly;
  final List<String> reasonCodes;

  factory PaymentFxDisclosure.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "quoteId",
      "orderId",
      "sourceAmount",
      "displayAmount",
      "fee",
      "expiresAt",
      "label",
      "displayOnly",
      "reasonCodes",
    });
    final value = PaymentFxDisclosure(
      quoteId: PaymentCodec.text(json, 'quoteId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      sourceAmount: (json['sourceAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['sourceAmount'])))!,
      displayAmount: (json['displayAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['displayAmount'])))!,
      fee: (json['fee'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['fee'])))!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      displayOnly: PaymentCodec.boolean(json, 'displayOnly') ?? true,
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

  static PaymentResult<PaymentFxDisclosure> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentFxDisclosure.fromJson(PaymentCodec.object(input)),
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

  PaymentFxDisclosure copyWith({
    Set<String> clear = const {},
    String? quoteId,
    String? orderId,
    PaymentMoney? sourceAmount,
    PaymentMoney? displayAmount,
    PaymentMoney? fee,
    DateTime? expiresAt,
    String? label,
    bool? displayOnly,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentFxDisclosure(
      quoteId: (quoteId ?? this.quoteId),
      orderId: (orderId ?? this.orderId),
      sourceAmount: (sourceAmount ?? this.sourceAmount),
      displayAmount: (displayAmount ?? this.displayAmount),
      fee: (fee ?? this.fee),
      expiresAt: (expiresAt ?? this.expiresAt),
      label: (label ?? this.label),
      displayOnly: (displayOnly ?? this.displayOnly),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (quoteId.trim().isEmpty || quoteId.length > 4000)
        validationIssues.add(
          const PaymentIssue('quoteId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in sourceAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'sourceAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in displayAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'displayAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in fee.validate())
        validationIssues.add(
          PaymentIssue(
            'fee.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
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
    if (!displayOnly)
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
    "quoteId": quoteId,
    "orderId": orderId,
    "sourceAmount": sourceAmount.toJson(),
    "displayAmount": displayAmount.toJson(),
    "fee": fee.toJson(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "label": label,
    "displayOnly": displayOnly,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentFxDisclosure &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentFxDisclosure(redacted)';
}
