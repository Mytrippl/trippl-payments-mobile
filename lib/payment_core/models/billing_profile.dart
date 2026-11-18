// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'billing_address.dart';

class PaymentBillingProfile {
  PaymentBillingProfile({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    required this.address,
    this.displayName,
    this.emailCollected = false,
    this.phoneCollected = false,
    List<String> taxIdentityIds = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : taxIdentityIds = List.unmodifiable(taxIdentityIds);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final PaymentBillingAddress address;
  final String? displayName;
  final bool emailCollected;
  final bool phoneCollected;
  final List<String> taxIdentityIds;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentBillingProfile.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "address",
      "displayName",
      "emailCollected",
      "phoneCollected",
      "taxIdentityIds",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentBillingProfile(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      address: (json['address'] == null
          ? null
          : PaymentBillingAddress.fromJson(
              PaymentCodec.object(json['address']),
            ))!,
      displayName: PaymentCodec.text(json, 'displayName'),
      emailCollected: PaymentCodec.boolean(json, 'emailCollected') ?? false,
      phoneCollected: PaymentCodec.boolean(json, 'phoneCollected') ?? false,
      taxIdentityIds:
          PaymentCodec.list(json, 'taxIdentityIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
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

  static PaymentResult<PaymentBillingProfile> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentBillingProfile.fromJson(PaymentCodec.object(input)),
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

  PaymentBillingProfile copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    PaymentBillingAddress? address,
    String? displayName,
    bool? emailCollected,
    bool? phoneCollected,
    List<String>? taxIdentityIds,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"displayName"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentBillingProfile(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      address: (address ?? this.address),
      displayName: clear.contains('displayName')
          ? null
          : (displayName ?? this.displayName),
      emailCollected: (emailCollected ?? this.emailCollected),
      phoneCollected: (phoneCollected ?? this.phoneCollected),
      taxIdentityIds: (taxIdentityIds ?? this.taxIdentityIds),
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
    if (displayName != null) {
      if (displayName!.trim().isEmpty || displayName!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'displayName',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (taxIdentityIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'taxIdentityIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (taxIdentityIds.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const PaymentIssue(
            'taxIdentityIds',
            'text',
            'Use bounded nonempty list text',
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
    "customerId": customerId,
    "address": address.toJson(),
    if (displayName != null) "displayName": displayName,
    "emailCollected": emailCollected,
    "phoneCollected": phoneCollected,
    "taxIdentityIds": taxIdentityIds,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentBillingProfile &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentBillingProfile(redacted)';
}
