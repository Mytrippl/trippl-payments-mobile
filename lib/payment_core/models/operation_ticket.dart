// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentOperationTicket {
  PaymentOperationTicket({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.sessionId,
    required this.sessionGeneration,
    required this.kind,
    required this.payloadFingerprint,
    required this.idempotencyKey,
    required this.createdAt,
    required this.expiresAt,
    this.requiresUserReview = true,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String sessionId;
  final int sessionGeneration;
  final String kind;
  final String payloadFingerprint;
  final String idempotencyKey;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool requiresUserReview;

  factory PaymentOperationTicket.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "sessionId",
      "sessionGeneration",
      "kind",
      "payloadFingerprint",
      "idempotencyKey",
      "createdAt",
      "expiresAt",
      "requiresUserReview",
    });
    final value = PaymentOperationTicket(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      sessionId: PaymentCodec.text(json, 'sessionId', required: true)!,
      sessionGeneration: PaymentCodec.integer(
        json,
        'sessionGeneration',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      payloadFingerprint: PaymentCodec.text(
        json,
        'payloadFingerprint',
        required: true,
      )!,
      idempotencyKey: PaymentCodec.text(
        json,
        'idempotencyKey',
        required: true,
      )!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      requiresUserReview:
          PaymentCodec.boolean(json, 'requiresUserReview') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentOperationTicket> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentOperationTicket.fromJson(PaymentCodec.object(input)),
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

  PaymentOperationTicket copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? sessionId,
    int? sessionGeneration,
    String? kind,
    String? payloadFingerprint,
    String? idempotencyKey,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? requiresUserReview,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentOperationTicket(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      sessionId: (sessionId ?? this.sessionId),
      sessionGeneration: (sessionGeneration ?? this.sessionGeneration),
      kind: (kind ?? this.kind),
      payloadFingerprint: (payloadFingerprint ?? this.payloadFingerprint),
      idempotencyKey: (idempotencyKey ?? this.idempotencyKey),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      requiresUserReview: (requiresUserReview ?? this.requiresUserReview),
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
      if (sessionId.trim().isEmpty || sessionId.length > 4000)
        validationIssues.add(
          const PaymentIssue('sessionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (sessionGeneration < 0 || sessionGeneration > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'sessionGeneration',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (payloadFingerprint.trim().isEmpty || payloadFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'payloadFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (idempotencyKey.trim().isEmpty || idempotencyKey.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'idempotencyKey',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        sessionGeneration < 1 ||
        !expiresAt.isAfter(createdAt) ||
        !{
          'billingReview',
          'refundReview',
          'planReview',
          'supportReview',
        }.contains(kind) ||
        !requiresUserReview)
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
    "sessionId": sessionId,
    "sessionGeneration": sessionGeneration,
    "kind": kind,
    "payloadFingerprint": payloadFingerprint,
    "idempotencyKey": idempotencyKey,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "requiresUserReview": requiresUserReview,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentOperationTicket &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentOperationTicket(redacted)';
}
