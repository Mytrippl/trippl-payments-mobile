// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentOrderBinding {
  PaymentOrderBinding({
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderRevision,
    required this.orderFingerprint,
    required this.intentId,
    required this.total,
    required this.environment,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
  });

  final String scopeFingerprint;
  final String orderId;
  final int orderRevision;
  final String orderFingerprint;
  final String intentId;
  final PaymentMoney total;
  final String environment;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;

  factory PaymentOrderBinding.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "orderId",
      "orderRevision",
      "orderFingerprint",
      "intentId",
      "total",
      "environment",
      "observedAt",
      "expiresAt",
      "serverVerified",
    });
    final value = PaymentOrderBinding(
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
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentOrderBinding> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentOrderBinding.fromJson(PaymentCodec.object(input)),
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

  PaymentOrderBinding copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? orderId,
    int? orderRevision,
    String? orderFingerprint,
    String? intentId,
    PaymentMoney? total,
    String? environment,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentOrderBinding(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderRevision: (orderRevision ?? this.orderRevision),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      intentId: (intentId ?? this.intentId),
      total: (total ?? this.total),
      environment: (environment ?? this.environment),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (orderFingerprint.trim().isEmpty || orderFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'orderFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
      if (environment.trim().isEmpty || environment.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'environment',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (orderRevision < 1 ||
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
    "scopeFingerprint": scopeFingerprint,
    "orderId": orderId,
    "orderRevision": orderRevision,
    "orderFingerprint": orderFingerprint,
    "intentId": intentId,
    "total": total.toJson(),
    "environment": environment,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentOrderBinding &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentOrderBinding(redacted)';
}
