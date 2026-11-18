// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentDispute {
  PaymentDispute({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.intentId,
    required this.amount,
    required this.reasonCode,
    required this.status,
    required this.openedAt,
    this.responseDueAt,
    this.evidenceAllowed = false,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String intentId;
  final PaymentMoney amount;
  final String reasonCode;
  final String status;
  final DateTime openedAt;
  final DateTime? responseDueAt;
  final bool evidenceAllowed;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentDispute.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "intentId",
      "amount",
      "reasonCode",
      "status",
      "openedAt",
      "responseDueAt",
      "evidenceAllowed",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentDispute(
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
      status: PaymentCodec.text(json, 'status', required: true)!,
      openedAt: PaymentCodec.date(json, 'openedAt', required: true)!,
      responseDueAt: PaymentCodec.date(json, 'responseDueAt'),
      evidenceAllowed: PaymentCodec.boolean(json, 'evidenceAllowed') ?? false,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
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

  static PaymentResult<PaymentDispute> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentDispute.fromJson(PaymentCodec.object(input)),
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

  PaymentDispute copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? intentId,
    PaymentMoney? amount,
    String? reasonCode,
    String? status,
    DateTime? openedAt,
    DateTime? responseDueAt,
    bool? evidenceAllowed,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"responseDueAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentDispute(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      amount: (amount ?? this.amount),
      reasonCode: (reasonCode ?? this.reasonCode),
      status: (status ?? this.status),
      openedAt: (openedAt ?? this.openedAt),
      responseDueAt: clear.contains('responseDueAt')
          ? null
          : (responseDueAt ?? this.responseDueAt),
      evidenceAllowed: (evidenceAllowed ?? this.evidenceAllowed),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
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
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
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
        !{'test', 'live'}.contains(environment) ||
        !{
          'warning',
          'needs_response',
          'under_review',
          'won',
          'lost',
          'closed',
          'unknown',
        }.contains(status) ||
        responseDueAt != null && responseDueAt!.isBefore(openedAt))
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
    "status": status,
    "openedAt": openedAt.toUtc().toIso8601String(),
    if (responseDueAt != null)
      "responseDueAt": responseDueAt!.toUtc().toIso8601String(),
    "evidenceAllowed": evidenceAllowed,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentDispute && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentDispute(redacted)';
}
