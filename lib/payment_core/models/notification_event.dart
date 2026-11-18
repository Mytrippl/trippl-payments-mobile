// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentNotificationEvent {
  PaymentNotificationEvent({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.kind,
    required this.status,
    required this.occurredAt,
    required this.expiresAt,
    required this.sourceReference,
    this.delivered = false,
    this.serverVerified = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String kind;
  final String status;
  final DateTime occurredAt;
  final DateTime expiresAt;
  final String sourceReference;
  final bool delivered;
  final bool serverVerified;

  factory PaymentNotificationEvent.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "kind",
      "status",
      "occurredAt",
      "expiresAt",
      "sourceReference",
      "delivered",
      "serverVerified",
    });
    final value = PaymentNotificationEvent(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      occurredAt: PaymentCodec.date(json, 'occurredAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      sourceReference: PaymentCodec.text(
        json,
        'sourceReference',
        required: true,
      )!,
      delivered: PaymentCodec.boolean(json, 'delivered') ?? false,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentNotificationEvent> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentNotificationEvent.fromJson(PaymentCodec.object(input)),
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

  PaymentNotificationEvent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? kind,
    String? status,
    DateTime? occurredAt,
    DateTime? expiresAt,
    String? sourceReference,
    bool? delivered,
    bool? serverVerified,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentNotificationEvent(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      kind: (kind ?? this.kind),
      status: (status ?? this.status),
      occurredAt: (occurredAt ?? this.occurredAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      sourceReference: (sourceReference ?? this.sourceReference),
      delivered: (delivered ?? this.delivered),
      serverVerified: (serverVerified ?? this.serverVerified),
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
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (sourceReference.trim().isEmpty || sourceReference.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'sourceReference',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (!{'test', 'live'}.contains(environment) ||
        !expiresAt.isAfter(occurredAt) ||
        !{'payment', 'refund', 'invoice', 'plan', 'dispute'}.contains(kind) ||
        delivered)
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
    "kind": kind,
    "status": status,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "sourceReference": sourceReference,
    "delivered": delivered,
    "serverVerified": serverVerified,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentNotificationEvent &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentNotificationEvent(redacted)';
}
