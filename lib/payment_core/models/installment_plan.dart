// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'installment.dart';
import 'money.dart';

class PaymentInstallmentPlan {
  PaymentInstallmentPlan({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.orderFingerprint,
    required this.total,
    required this.status,
    required this.termsRevision,
    required List<PaymentInstallment> installments,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : installments = List.unmodifiable(installments);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String orderFingerprint;
  final PaymentMoney total;
  final String status;
  final int termsRevision;
  final List<PaymentInstallment> installments;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentInstallmentPlan.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "orderFingerprint",
      "total",
      "status",
      "termsRevision",
      "installments",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentInstallmentPlan(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      termsRevision: PaymentCodec.integer(
        json,
        'termsRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      installments: PaymentCodec.list(
        json,
        'installments',
        (v) => PaymentInstallment.fromJson(PaymentCodec.object(v)),
        required: true,
        maximum: 100,
      )!,
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

  static PaymentResult<PaymentInstallmentPlan> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInstallmentPlan.fromJson(PaymentCodec.object(input)),
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

  PaymentInstallmentPlan copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? orderFingerprint,
    PaymentMoney? total,
    String? status,
    int? termsRevision,
    List<PaymentInstallment>? installments,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInstallmentPlan(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      total: (total ?? this.total),
      status: (status ?? this.status),
      termsRevision: (termsRevision ?? this.termsRevision),
      installments: (installments ?? this.installments),
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
      if (termsRevision < 0 || termsRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'termsRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (installments.length > 100 || installments.isEmpty)
        validationIssues.add(
          const PaymentIssue(
            'installments',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < installments.length; i++)
        for (final issue in installments[i].validate())
          validationIssues.add(
            PaymentIssue(
              'installments[$i].${issue.field}',
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
        !expiresAt.isAfter(observedAt) ||
        !{'test', 'live'}.contains(environment) ||
        termsRevision < 1 ||
        installments.length > 24 ||
        !{
          'proposed',
          'active',
          'completed',
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
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "orderId": orderId,
    "orderFingerprint": orderFingerprint,
    "total": total.toJson(),
    "status": status,
    "termsRevision": termsRevision,
    "installments": installments.map((item) => item.toJson()).toList(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInstallmentPlan &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInstallmentPlan(redacted)';
}
