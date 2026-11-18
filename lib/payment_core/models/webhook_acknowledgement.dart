// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentWebhookAcknowledgement {
  PaymentWebhookAcknowledgement({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.intentId,
    required this.eventId,
    required this.eventType,
    required this.receivedAt,
    required this.verifiedAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String intentId;
  final String eventId;
  final String eventType;
  final DateTime receivedAt;
  final DateTime verifiedAt;
  final bool serverVerified;
  final int revision;

  factory PaymentWebhookAcknowledgement.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "intentId",
      "eventId",
      "eventType",
      "receivedAt",
      "verifiedAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentWebhookAcknowledgement(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      eventId: PaymentCodec.text(json, 'eventId', required: true)!,
      eventType: PaymentCodec.text(json, 'eventType', required: true)!,
      receivedAt: PaymentCodec.date(json, 'receivedAt', required: true)!,
      verifiedAt: PaymentCodec.date(json, 'verifiedAt', required: true)!,
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

  static PaymentResult<PaymentWebhookAcknowledgement> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentWebhookAcknowledgement.fromJson(
          PaymentCodec.object(input),
        ),
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

  PaymentWebhookAcknowledgement copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? intentId,
    String? eventId,
    String? eventType,
    DateTime? receivedAt,
    DateTime? verifiedAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentWebhookAcknowledgement(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      eventId: (eventId ?? this.eventId),
      eventType: (eventType ?? this.eventType),
      receivedAt: (receivedAt ?? this.receivedAt),
      verifiedAt: (verifiedAt ?? this.verifiedAt),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (eventId.trim().isEmpty || eventId.length > 4000)
        validationIssues.add(
          const PaymentIssue('eventId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (eventType.trim().isEmpty || eventType.length > 4000)
        validationIssues.add(
          const PaymentIssue('eventType', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 || verifiedAt.isBefore(receivedAt))
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
    "orderId": orderId,
    "intentId": intentId,
    "eventId": eventId,
    "eventType": eventType,
    "receivedAt": receivedAt.toUtc().toIso8601String(),
    "verifiedAt": verifiedAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentWebhookAcknowledgement &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentWebhookAcknowledgement(redacted)';
}
