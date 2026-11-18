// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReadRequest {
  PaymentReadRequest({
    required this.id,
    required this.scopeFingerprint,
    required this.mode,
    required this.environment,
    required this.createdAt,
    this.orderId,
    this.intentId,
    this.customerId,
    this.cursor,
    this.limit = 20,
  });

  final String id;
  final String scopeFingerprint;
  final String mode;
  final String environment;
  final DateTime createdAt;
  final String? orderId;
  final String? intentId;
  final String? customerId;
  final String? cursor;
  final int limit;

  factory PaymentReadRequest.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "mode",
      "environment",
      "createdAt",
      "orderId",
      "intentId",
      "customerId",
      "cursor",
      "limit",
    });
    final value = PaymentReadRequest(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      mode: PaymentCodec.text(json, 'mode', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId'),
      intentId: PaymentCodec.text(json, 'intentId'),
      customerId: PaymentCodec.text(json, 'customerId'),
      cursor: PaymentCodec.text(json, 'cursor'),
      limit:
          PaymentCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentReadRequest> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadRequest.fromJson(PaymentCodec.object(input)),
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

  PaymentReadRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? mode,
    String? environment,
    DateTime? createdAt,
    String? orderId,
    String? intentId,
    String? customerId,
    String? cursor,
    int? limit,
  }) {
    final clearableFields = <String>{
      "orderId",
      "intentId",
      "customerId",
      "cursor",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadRequest(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      mode: (mode ?? this.mode),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      orderId: clear.contains('orderId') ? null : (orderId ?? this.orderId),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      customerId: clear.contains('customerId')
          ? null
          : (customerId ?? this.customerId),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
      limit: (limit ?? this.limit),
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
      if (mode.trim().isEmpty || mode.length > 4000)
        validationIssues.add(
          const PaymentIssue('mode', 'text', 'Use nonempty bounded text'),
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
    if (orderId != null) {
      if (orderId!.trim().isEmpty || orderId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (customerId != null) {
      if (customerId!.trim().isEmpty || customerId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const PaymentIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (limit < 0 || limit > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'limit',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (!{
          'intent',
          'methods',
          'receipt',
          'currencies',
          'refunds',
        }.contains(mode) ||
        !{'test', 'live'}.contains(environment) ||
        limit < 1 ||
        limit > 100)
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
    "mode": mode,
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    if (orderId != null) "orderId": orderId,
    if (intentId != null) "intentId": intentId,
    if (customerId != null) "customerId": customerId,
    if (cursor != null) "cursor": cursor,
    "limit": limit,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadRequest &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadRequest(redacted)';
}
