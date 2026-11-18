// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentRefundRequestDraft {
  PaymentRefundRequestDraft({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.intentId,
    required this.amount,
    required this.reasonCode,
    required this.createdAt,
    required this.expectedOrderRevision,
    List<String> lineIds = const [],
    this.submitted = false,
  }) : lineIds = List.unmodifiable(lineIds);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String intentId;
  final PaymentMoney amount;
  final String reasonCode;
  final DateTime createdAt;
  final int expectedOrderRevision;
  final List<String> lineIds;
  final bool submitted;

  factory PaymentRefundRequestDraft.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "intentId",
      "amount",
      "reasonCode",
      "createdAt",
      "expectedOrderRevision",
      "lineIds",
      "submitted",
    });
    final value = PaymentRefundRequestDraft(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      reasonCode: PaymentCodec.text(json, 'reasonCode', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expectedOrderRevision: PaymentCodec.integer(
        json,
        'expectedOrderRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      lineIds:
          PaymentCodec.list(json, 'lineIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      submitted: PaymentCodec.boolean(json, 'submitted') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentRefundRequestDraft> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundRequestDraft.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundRequestDraft copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? intentId,
    PaymentMoney? amount,
    String? reasonCode,
    DateTime? createdAt,
    int? expectedOrderRevision,
    List<String>? lineIds,
    bool? submitted,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundRequestDraft(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      amount: (amount ?? this.amount),
      reasonCode: (reasonCode ?? this.reasonCode),
      createdAt: (createdAt ?? this.createdAt),
      expectedOrderRevision:
          (expectedOrderRevision ?? this.expectedOrderRevision),
      lineIds: (lineIds ?? this.lineIds),
      submitted: (submitted ?? this.submitted),
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
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (environment.trim().isEmpty || environment.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'environment',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
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
      if (reasonCode.trim().isEmpty || reasonCode.length > 4000)
        validationIssues.add(
          const PaymentIssue('reasonCode', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (expectedOrderRevision < 0 || expectedOrderRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'expectedOrderRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (lineIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'lineIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (lineIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'lineIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        expectedOrderRevision < 1 ||
        submitted)
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
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "orderId": orderId,
    "intentId": intentId,
    "amount": amount.toJson(),
    "reasonCode": reasonCode,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expectedOrderRevision": expectedOrderRevision,
    "lineIds": lineIds,
    "submitted": submitted,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundRequestDraft &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundRequestDraft(redacted)';
}
