// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentRefundReason {
  PaymentRefundReason({
    required this.code,
    required this.label,
    this.requiresLineSelection = false,
    this.requiresSupport = false,
    this.partialAllowed = false,
    this.enabled = true,
    List<String> serviceTypes = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : serviceTypes = List.unmodifiable(serviceTypes);

  final String code;
  final String label;
  final bool requiresLineSelection;
  final bool requiresSupport;
  final bool partialAllowed;
  final bool enabled;
  final List<String> serviceTypes;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentRefundReason.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "code",
      "label",
      "requiresLineSelection",
      "requiresSupport",
      "partialAllowed",
      "enabled",
      "serviceTypes",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentRefundReason(
      code: PaymentCodec.text(json, 'code', required: true)!,
      label: PaymentCodec.text(json, 'label', required: true)!,
      requiresLineSelection:
          PaymentCodec.boolean(json, 'requiresLineSelection') ?? false,
      requiresSupport: PaymentCodec.boolean(json, 'requiresSupport') ?? false,
      partialAllowed: PaymentCodec.boolean(json, 'partialAllowed') ?? false,
      enabled: PaymentCodec.boolean(json, 'enabled') ?? true,
      serviceTypes:
          PaymentCodec.list(json, 'serviceTypes', (v) {
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

  static PaymentResult<PaymentRefundReason> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundReason.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundReason copyWith({
    Set<String> clear = const {},
    String? code,
    String? label,
    bool? requiresLineSelection,
    bool? requiresSupport,
    bool? partialAllowed,
    bool? enabled,
    List<String>? serviceTypes,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundReason(
      code: (code ?? this.code),
      label: (label ?? this.label),
      requiresLineSelection:
          (requiresLineSelection ?? this.requiresLineSelection),
      requiresSupport: (requiresSupport ?? this.requiresSupport),
      partialAllowed: (partialAllowed ?? this.partialAllowed),
      enabled: (enabled ?? this.enabled),
      serviceTypes: (serviceTypes ?? this.serviceTypes),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const PaymentIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const PaymentIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (serviceTypes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'serviceTypes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (serviceTypes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'serviceTypes',
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
    if (revision < 1 || !expiresAt.isAfter(observedAt))
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
    "code": code,
    "label": label,
    "requiresLineSelection": requiresLineSelection,
    "requiresSupport": requiresSupport,
    "partialAllowed": partialAllowed,
    "enabled": enabled,
    "serviceTypes": serviceTypes,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundReason &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundReason(redacted)';
}
