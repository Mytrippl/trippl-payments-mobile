// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentRefundReference {
  PaymentRefundReference({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.intentId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.reasonCode,
    required this.environment,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String intentId;
  final PaymentMoney amount;
  final String status;
  final DateTime createdAt;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final String? reasonCode;
  final String environment;
  final int revision;

  factory PaymentRefundReference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "intentId",
      "amount",
      "status",
      "createdAt",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "reasonCode",
      "environment",
      "revision",
    });
    final value = PaymentRefundReference(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      amount: (json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])))!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      reasonCode: PaymentCodec.text(json, 'reasonCode'),
      environment: PaymentCodec.text(json, 'environment', required: true)!,
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

  static PaymentResult<PaymentRefundReference> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundReference.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundReference copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? intentId,
    PaymentMoney? amount,
    String? status,
    DateTime? createdAt,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    String? reasonCode,
    String? environment,
    int? revision,
  }) {
    final clearableFields = <String>{"reasonCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundReference(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      amount: (amount ?? this.amount),
      status: (status ?? this.status),
      createdAt: (createdAt ?? this.createdAt),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      reasonCode: clear.contains('reasonCode')
          ? null
          : (reasonCode ?? this.reasonCode),
      environment: (environment ?? this.environment),
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
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    if (reasonCode != null) {
      if (reasonCode!.trim().isEmpty || reasonCode!.length > 4000)
        validationIssues.add(
          const PaymentIssue('reasonCode', 'text', 'Use nonempty bounded text'),
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
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'revision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (revision < 1 ||
        !expiresAt.isAfter(observedAt) ||
        !{
          'pending',
          'requires_action',
          'succeeded',
          'failed',
          'canceled',
          'unknown',
        }.contains(status) ||
        !{'test', 'live'}.contains(environment))
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
    "orderId": orderId,
    "intentId": intentId,
    "amount": amount.toJson(),
    "status": status,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    if (reasonCode != null) "reasonCode": reasonCode,
    "environment": environment,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundReference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundReference(redacted)';
}
