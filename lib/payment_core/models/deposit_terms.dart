// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentDepositTerms {
  PaymentDepositTerms({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.serviceType,
    required this.depositBasisPoints,
    required this.minimumDeposit,
    required this.balanceDueAt,
    this.refundable = false,
    this.cancellationPolicyId = "unknown",
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String serviceType;
  final int depositBasisPoints;
  final PaymentMoney minimumDeposit;
  final DateTime balanceDueAt;
  final bool refundable;
  final String cancellationPolicyId;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentDepositTerms.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "serviceType",
      "depositBasisPoints",
      "minimumDeposit",
      "balanceDueAt",
      "refundable",
      "cancellationPolicyId",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentDepositTerms(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      serviceType: PaymentCodec.text(json, 'serviceType', required: true)!,
      depositBasisPoints: PaymentCodec.integer(
        json,
        'depositBasisPoints',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      minimumDeposit: (json['minimumDeposit'] == null
          ? null
          : PaymentMoney.fromJson(
              PaymentCodec.object(json['minimumDeposit']),
            ))!,
      balanceDueAt: PaymentCodec.date(json, 'balanceDueAt', required: true)!,
      refundable: PaymentCodec.boolean(json, 'refundable') ?? false,
      cancellationPolicyId:
          PaymentCodec.text(json, 'cancellationPolicyId') ?? "unknown",
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

  static PaymentResult<PaymentDepositTerms> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentDepositTerms.fromJson(PaymentCodec.object(input)),
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

  PaymentDepositTerms copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? serviceType,
    int? depositBasisPoints,
    PaymentMoney? minimumDeposit,
    DateTime? balanceDueAt,
    bool? refundable,
    String? cancellationPolicyId,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentDepositTerms(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      serviceType: (serviceType ?? this.serviceType),
      depositBasisPoints: (depositBasisPoints ?? this.depositBasisPoints),
      minimumDeposit: (minimumDeposit ?? this.minimumDeposit),
      balanceDueAt: (balanceDueAt ?? this.balanceDueAt),
      refundable: (refundable ?? this.refundable),
      cancellationPolicyId: (cancellationPolicyId ?? this.cancellationPolicyId),
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
      if (serviceType.trim().isEmpty || serviceType.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'serviceType',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (depositBasisPoints < 0 || depositBasisPoints > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'depositBasisPoints',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      for (final issue in minimumDeposit.validate())
        validationIssues.add(
          PaymentIssue(
            'minimumDeposit.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (cancellationPolicyId.trim().isEmpty ||
          cancellationPolicyId.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'cancellationPolicyId',
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
        !{'test', 'live'}.contains(environment) ||
        depositBasisPoints < 1 ||
        depositBasisPoints > 10000)
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
    "serviceType": serviceType,
    "depositBasisPoints": depositBasisPoints,
    "minimumDeposit": minimumDeposit.toJson(),
    "balanceDueAt": balanceDueAt.toUtc().toIso8601String(),
    "refundable": refundable,
    "cancellationPolicyId": cancellationPolicyId,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentDepositTerms &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentDepositTerms(redacted)';
}
