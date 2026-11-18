// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'billing_address.dart';

class PaymentBillingPatch {
  PaymentBillingPatch({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.profileId,
    required this.customerId,
    required this.expectedRevision,
    required this.address,
    required this.createdAt,
    List<String> changedFields = const [],
    this.submitted = false,
  }) : changedFields = List.unmodifiable(changedFields);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String profileId;
  final String customerId;
  final int expectedRevision;
  final PaymentBillingAddress address;
  final DateTime createdAt;
  final List<String> changedFields;
  final bool submitted;

  factory PaymentBillingPatch.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "profileId",
      "customerId",
      "expectedRevision",
      "address",
      "createdAt",
      "changedFields",
      "submitted",
    });
    final value = PaymentBillingPatch(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      profileId: PaymentCodec.text(json, 'profileId', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      expectedRevision: PaymentCodec.integer(
        json,
        'expectedRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      address: (json['address'] == null
          ? null
          : PaymentBillingAddress.fromJson(
              PaymentCodec.object(json['address']),
            ))!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      changedFields:
          PaymentCodec.list(json, 'changedFields', (v) {
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

  static PaymentResult<PaymentBillingPatch> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentBillingPatch.fromJson(PaymentCodec.object(input)),
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

  PaymentBillingPatch copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? profileId,
    String? customerId,
    int? expectedRevision,
    PaymentBillingAddress? address,
    DateTime? createdAt,
    List<String>? changedFields,
    bool? submitted,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentBillingPatch(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      profileId: (profileId ?? this.profileId),
      customerId: (customerId ?? this.customerId),
      expectedRevision: (expectedRevision ?? this.expectedRevision),
      address: (address ?? this.address),
      createdAt: (createdAt ?? this.createdAt),
      changedFields: (changedFields ?? this.changedFields),
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
      if (profileId.trim().isEmpty || profileId.length > 4000)
        validationIssues.add(
          const PaymentIssue('profileId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (expectedRevision < 0 || expectedRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'expectedRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      for (final issue in address.validate())
        validationIssues.add(
          PaymentIssue(
            'address.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (changedFields.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'changedFields',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (changedFields.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'changedFields',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (expectedRevision < 1 ||
        submitted ||
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
    "environment": environment,
    "profileId": profileId,
    "customerId": customerId,
    "expectedRevision": expectedRevision,
    "address": address.toJson(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "changedFields": changedFields,
    "submitted": submitted,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentBillingPatch &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentBillingPatch(redacted)';
}
