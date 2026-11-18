// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentSessionContext {
  PaymentSessionContext({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.customerId,
    required this.authenticatedAt,
    required this.expiresAt,
    required this.generation,
    List<String> permissions = const [],
    this.active = true,
  }) : permissions = List.unmodifiable(permissions);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String customerId;
  final DateTime authenticatedAt;
  final DateTime expiresAt;
  final int generation;
  final List<String> permissions;
  final bool active;

  factory PaymentSessionContext.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "customerId",
      "authenticatedAt",
      "expiresAt",
      "generation",
      "permissions",
      "active",
    });
    final value = PaymentSessionContext(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      authenticatedAt: PaymentCodec.date(
        json,
        'authenticatedAt',
        required: true,
      )!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      generation: PaymentCodec.integer(
        json,
        'generation',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      permissions:
          PaymentCodec.list(json, 'permissions', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      active: PaymentCodec.boolean(json, 'active') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentSessionContext> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentSessionContext.fromJson(PaymentCodec.object(input)),
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

  PaymentSessionContext copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? customerId,
    DateTime? authenticatedAt,
    DateTime? expiresAt,
    int? generation,
    List<String>? permissions,
    bool? active,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentSessionContext(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      customerId: (customerId ?? this.customerId),
      authenticatedAt: (authenticatedAt ?? this.authenticatedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      generation: (generation ?? this.generation),
      permissions: (permissions ?? this.permissions),
      active: (active ?? this.active),
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
      if (generation < 0 || generation > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'generation',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (permissions.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'permissions',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (permissions.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'permissions',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        generation < 1 ||
        !expiresAt.isAfter(authenticatedAt))
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
    "authenticatedAt": authenticatedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "generation": generation,
    "permissions": permissions,
    "active": active,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentSessionContext &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentSessionContext(redacted)';
}
