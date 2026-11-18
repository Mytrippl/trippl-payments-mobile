// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'intent.dart';
import 'order_binding.dart';
import 'webhook_acknowledgement.dart';

class PaymentVerification {
  PaymentVerification({
    required this.id,
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.binding,
    required this.intent,
    required this.observedAt,
    required this.expiresAt,
    this.webhook,
    this.receiptId,
    this.serverVerified = false,
    this.bookingConfirmed = false,
    this.bookingReference,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String requestFingerprint;
  final PaymentOrderBinding binding;
  final PaymentIntent intent;
  final DateTime observedAt;
  final DateTime expiresAt;
  final PaymentWebhookAcknowledgement? webhook;
  final String? receiptId;
  final bool serverVerified;
  final bool bookingConfirmed;
  final String? bookingReference;
  final int revision;

  factory PaymentVerification.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "requestFingerprint",
      "binding",
      "intent",
      "observedAt",
      "expiresAt",
      "webhook",
      "receiptId",
      "serverVerified",
      "bookingConfirmed",
      "bookingReference",
      "revision",
    });
    final value = PaymentVerification(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      requestFingerprint: PaymentCodec.text(
        json,
        'requestFingerprint',
        required: true,
      )!,
      binding: (json['binding'] == null
          ? null
          : PaymentOrderBinding.fromJson(
              PaymentCodec.object(json['binding']),
            ))!,
      intent: (json['intent'] == null
          ? null
          : PaymentIntent.fromJson(PaymentCodec.object(json['intent'])))!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      webhook: json['webhook'] == null
          ? null
          : PaymentWebhookAcknowledgement.fromJson(
              PaymentCodec.object(json['webhook']),
            ),
      receiptId: PaymentCodec.text(json, 'receiptId'),
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      bookingConfirmed: PaymentCodec.boolean(json, 'bookingConfirmed') ?? false,
      bookingReference: PaymentCodec.text(json, 'bookingReference'),
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

  static PaymentResult<PaymentVerification> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentVerification.fromJson(PaymentCodec.object(input)),
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

  PaymentVerification copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? requestFingerprint,
    PaymentOrderBinding? binding,
    PaymentIntent? intent,
    DateTime? observedAt,
    DateTime? expiresAt,
    PaymentWebhookAcknowledgement? webhook,
    String? receiptId,
    bool? serverVerified,
    bool? bookingConfirmed,
    String? bookingReference,
    int? revision,
  }) {
    final clearableFields = <String>{
      "webhook",
      "receiptId",
      "bookingReference",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentVerification(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      binding: (binding ?? this.binding),
      intent: (intent ?? this.intent),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      webhook: clear.contains('webhook') ? null : (webhook ?? this.webhook),
      receiptId: clear.contains('receiptId')
          ? null
          : (receiptId ?? this.receiptId),
      serverVerified: (serverVerified ?? this.serverVerified),
      bookingConfirmed: (bookingConfirmed ?? this.bookingConfirmed),
      bookingReference: clear.contains('bookingReference')
          ? null
          : (bookingReference ?? this.bookingReference),
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
      if (requestFingerprint.trim().isEmpty || requestFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'requestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      for (final issue in binding.validate())
        validationIssues.add(
          PaymentIssue(
            'binding.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in intent.validate())
        validationIssues.add(
          PaymentIssue(
            'intent.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (webhook != null) {
      for (final issue in webhook!.validate())
        validationIssues.add(
          PaymentIssue(
            'webhook.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (receiptId != null) {
      if (receiptId!.trim().isEmpty || receiptId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('receiptId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (bookingReference != null) {
      if (bookingReference!.trim().isEmpty || bookingReference!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'bookingReference',
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
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "requestFingerprint": requestFingerprint,
    "binding": binding.toJson(),
    "intent": intent.toJson(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    if (webhook != null) "webhook": webhook!.toJson(),
    if (receiptId != null) "receiptId": receiptId,
    "serverVerified": serverVerified,
    "bookingConfirmed": bookingConfirmed,
    if (bookingReference != null) "bookingReference": bookingReference,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentVerification &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentVerification(redacted)';
}
