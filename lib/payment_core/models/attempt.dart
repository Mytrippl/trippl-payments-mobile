// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentAttempt {
  PaymentAttempt({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.quoteId,
    required this.idempotencyKey,
    required this.environment,
    required this.createdAt,
    required this.updatedAt,
    this.state = "created",
    this.intentId,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final String quoteId;
  final String idempotencyKey;
  final String environment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String state;
  final String? intentId;
  final int revision;

  factory PaymentAttempt.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "quoteId",
      "idempotencyKey",
      "environment",
      "createdAt",
      "updatedAt",
      "state",
      "intentId",
      "revision",
    });
    final value = PaymentAttempt(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      quoteId: PaymentCodec.text(json, 'quoteId', required: true)!,
      idempotencyKey: PaymentCodec.text(
        json,
        'idempotencyKey',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state') ?? "created",
      intentId: PaymentCodec.text(json, 'intentId'),
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

  static PaymentResult<PaymentAttempt> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAttempt.fromJson(PaymentCodec.object(input)),
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

  PaymentAttempt copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    String? quoteId,
    String? idempotencyKey,
    String? environment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? state,
    String? intentId,
    int? revision,
  }) {
    final clearableFields = <String>{"intentId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAttempt(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      quoteId: (quoteId ?? this.quoteId),
      idempotencyKey: (idempotencyKey ?? this.idempotencyKey),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      state: (state ?? this.state),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
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
      if (orderFingerprint.trim().isEmpty || orderFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'orderFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (quoteId.trim().isEmpty || quoteId.length > 4000)
        validationIssues.add(
          const PaymentIssue('quoteId', 'text', 'Use nonempty bounded text'),
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
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
        updatedAt.isBefore(createdAt) ||
        !{
          'created',
          'allocating',
          'allocated',
          'presenting',
          'verifying',
          'pending',
          'completed',
          'cancelled',
          'failed',
          'uncertain',
        }.contains(state))
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
    "orderFingerprint": orderFingerprint,
    "quoteId": quoteId,
    "idempotencyKey": idempotencyKey,
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "state": state,
    if (intentId != null) "intentId": intentId,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAttempt && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAttempt(redacted)';
}
