// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentSupportHandoff {
  PaymentSupportHandoff({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.contextFingerprint,
    required this.orderId,
    required this.destination,
    required this.createdAt,
    required this.expiresAt,
    this.requiresUserAction = true,
    this.messageSent = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String contextFingerprint;
  final String orderId;
  final String destination;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool requiresUserAction;
  final bool messageSent;

  factory PaymentSupportHandoff.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "contextFingerprint",
      "orderId",
      "destination",
      "createdAt",
      "expiresAt",
      "requiresUserAction",
      "messageSent",
    });
    final value = PaymentSupportHandoff(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      contextFingerprint: PaymentCodec.text(
        json,
        'contextFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      destination: PaymentCodec.text(json, 'destination', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      requiresUserAction:
          PaymentCodec.boolean(json, 'requiresUserAction') ?? true,
      messageSent: PaymentCodec.boolean(json, 'messageSent') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentSupportHandoff> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentSupportHandoff.fromJson(PaymentCodec.object(input)),
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

  PaymentSupportHandoff copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? contextFingerprint,
    String? orderId,
    String? destination,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? requiresUserAction,
    bool? messageSent,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentSupportHandoff(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      contextFingerprint: (contextFingerprint ?? this.contextFingerprint),
      orderId: (orderId ?? this.orderId),
      destination: (destination ?? this.destination),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      requiresUserAction: (requiresUserAction ?? this.requiresUserAction),
      messageSent: (messageSent ?? this.messageSent),
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
      if (contextFingerprint.trim().isEmpty || contextFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'contextFingerprint',
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
      if (destination.trim().isEmpty || destination.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'destination',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        !expiresAt.isAfter(createdAt) ||
        messageSent ||
        !requiresUserAction)
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
    "contextFingerprint": contextFingerprint,
    "orderId": orderId,
    "destination": destination,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "requiresUserAction": requiresUserAction,
    "messageSent": messageSent,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentSupportHandoff &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentSupportHandoff(redacted)';
}
