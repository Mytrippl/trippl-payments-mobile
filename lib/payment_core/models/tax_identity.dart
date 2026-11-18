// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentTaxIdentity {
  PaymentTaxIdentity({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    required this.countryCode,
    required this.type,
    required this.maskedValue,
    required this.status,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final String countryCode;
  final String type;
  final String maskedValue;
  final String status;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentTaxIdentity.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "countryCode",
      "type",
      "maskedValue",
      "status",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentTaxIdentity(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      countryCode: PaymentCodec.text(json, 'countryCode', required: true)!,
      type: PaymentCodec.text(json, 'type', required: true)!,
      maskedValue: PaymentCodec.text(json, 'maskedValue', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
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

  static PaymentResult<PaymentTaxIdentity> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentTaxIdentity.fromJson(PaymentCodec.object(input)),
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

  PaymentTaxIdentity copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    String? countryCode,
    String? type,
    String? maskedValue,
    String? status,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentTaxIdentity(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      countryCode: (countryCode ?? this.countryCode),
      type: (type ?? this.type),
      maskedValue: (maskedValue ?? this.maskedValue),
      status: (status ?? this.status),
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
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (countryCode.trim().isEmpty || countryCode.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'countryCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (type.trim().isEmpty || type.length > 4000)
        validationIssues.add(
          const PaymentIssue('type', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (maskedValue.trim().isEmpty || maskedValue.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'maskedValue',
            'text',
            'Use nonempty bounded text',
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
          'pending',
          'verified',
          'unverified',
          'unavailable',
        }.contains(status) ||
        !RegExp(r'^[A-Z]{2}$').hasMatch(countryCode))
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
    "customerId": customerId,
    "countryCode": countryCode,
    "type": type,
    "maskedValue": maskedValue,
    "status": status,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentTaxIdentity &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentTaxIdentity(redacted)';
}
