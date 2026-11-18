// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentActivityEntry {
  PaymentActivityEntry({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.kind,
    required this.status,
    required this.occurredAt,
    this.amount,
    this.intentId,
    this.sourceReference,
    this.labelCode = "paymentUpdate",
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String kind;
  final String status;
  final DateTime occurredAt;
  final PaymentMoney? amount;
  final String? intentId;
  final String? sourceReference;
  final String labelCode;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentActivityEntry.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "kind",
      "status",
      "occurredAt",
      "amount",
      "intentId",
      "sourceReference",
      "labelCode",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentActivityEntry(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      amount: json['amount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amount'])),
      intentId: PaymentCodec.text(json, 'intentId'),
      sourceReference: PaymentCodec.text(json, 'sourceReference'),
      labelCode: PaymentCodec.text(json, 'labelCode') ?? "paymentUpdate",
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

  static PaymentResult<PaymentActivityEntry> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentActivityEntry.fromJson(PaymentCodec.object(input)),
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

  PaymentActivityEntry copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? kind,
    String? status,
    DateTime? occurredAt,
    PaymentMoney? amount,
    String? intentId,
    String? sourceReference,
    String? labelCode,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"amount", "intentId", "sourceReference"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentActivityEntry(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      kind: (kind ?? this.kind),
      status: (status ?? this.status),
      occurredAt: (occurredAt ?? this.occurredAt),
      amount: clear.contains('amount') ? null : (amount ?? this.amount),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      sourceReference: clear.contains('sourceReference')
          ? null
          : (sourceReference ?? this.sourceReference),
      labelCode: (labelCode ?? this.labelCode),
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
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    if (amount != null) {
      for (final issue in amount!.validate())
        validationIssues.add(
          PaymentIssue(
            'amount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
      if (labelCode.trim().isEmpty || labelCode.length > 4000)
        validationIssues.add(
          const PaymentIssue('labelCode', 'text', 'Use nonempty bounded text'),
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
          'payment',
          'refund',
          'invoice',
          'dispute',
          'plan',
          'receipt',
        }.contains(kind))
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
    "kind": kind,
    "status": status,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    if (amount != null) "amount": amount!.toJson(),
    if (intentId != null) "intentId": intentId,
    if (sourceReference != null) "sourceReference": sourceReference,
    "labelCode": labelCode,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentActivityEntry &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentActivityEntry(redacted)';
}
