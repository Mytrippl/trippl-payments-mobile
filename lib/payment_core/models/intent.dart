// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentIntent {
  PaymentIntent({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderRevision,
    required this.total,
    required this.status,
    required this.environment,
    required this.observedAt,
    required this.expiresAt,
    this.customerId,
    this.methodId,
    this.amountReceived,
    this.amountCapturable,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final int orderRevision;
  final PaymentMoney total;
  final String status;
  final String environment;
  final DateTime observedAt;
  final DateTime expiresAt;
  final String? customerId;
  final String? methodId;
  final PaymentMoney? amountReceived;
  final PaymentMoney? amountCapturable;
  final bool serverVerified;
  final int revision;

  factory PaymentIntent.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "orderRevision",
      "total",
      "status",
      "environment",
      "observedAt",
      "expiresAt",
      "customerId",
      "methodId",
      "amountReceived",
      "amountCapturable",
      "serverVerified",
      "revision",
    });
    final value = PaymentIntent(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderRevision: PaymentCodec.integer(
        json,
        'orderRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId'),
      methodId: PaymentCodec.text(json, 'methodId'),
      amountReceived: json['amountReceived'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['amountReceived'])),
      amountCapturable: json['amountCapturable'] == null
          ? null
          : PaymentMoney.fromJson(
              PaymentCodec.object(json['amountCapturable']),
            ),
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

  static PaymentResult<PaymentIntent> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentIntent.fromJson(PaymentCodec.object(input)),
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

  PaymentIntent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    int? orderRevision,
    PaymentMoney? total,
    String? status,
    String? environment,
    DateTime? observedAt,
    DateTime? expiresAt,
    String? customerId,
    String? methodId,
    PaymentMoney? amountReceived,
    PaymentMoney? amountCapturable,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{
      "customerId",
      "methodId",
      "amountReceived",
      "amountCapturable",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentIntent(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderRevision: (orderRevision ?? this.orderRevision),
      total: (total ?? this.total),
      status: (status ?? this.status),
      environment: (environment ?? this.environment),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      customerId: clear.contains('customerId')
          ? null
          : (customerId ?? this.customerId),
      methodId: clear.contains('methodId') ? null : (methodId ?? this.methodId),
      amountReceived: clear.contains('amountReceived')
          ? null
          : (amountReceived ?? this.amountReceived),
      amountCapturable: clear.contains('amountCapturable')
          ? null
          : (amountCapturable ?? this.amountCapturable),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderRevision < 0 || orderRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'orderRevision',
            'range',
            'Number is outside the payment limits',
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
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
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
    if (customerId != null) {
      if (customerId!.trim().isEmpty || customerId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (methodId != null) {
      if (methodId!.trim().isEmpty || methodId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('methodId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (amountReceived != null) {
      for (final issue in amountReceived!.validate())
        validationIssues.add(
          PaymentIssue(
            'amountReceived.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (amountCapturable != null) {
      for (final issue in amountCapturable!.validate())
        validationIssues.add(
          PaymentIssue(
            'amountCapturable.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
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
        orderRevision < 1 ||
        !expiresAt.isAfter(observedAt) ||
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
    "orderRevision": orderRevision,
    "total": total.toJson(),
    "status": status,
    "environment": environment,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    if (customerId != null) "customerId": customerId,
    if (methodId != null) "methodId": methodId,
    if (amountReceived != null) "amountReceived": amountReceived!.toJson(),
    if (amountCapturable != null)
      "amountCapturable": amountCapturable!.toJson(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentIntent && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentIntent(redacted)';
}
