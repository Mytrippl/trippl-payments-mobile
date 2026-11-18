// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentCheckoutRequest {
  PaymentCheckoutRequest({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderRevision,
    required this.orderFingerprint,
    required this.quoteId,
    required this.total,
    required this.attemptId,
    required this.idempotencyKey,
    required this.environment,
    required this.createdAt,
    this.customerId,
    this.methodId,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final int orderRevision;
  final String orderFingerprint;
  final String quoteId;
  final PaymentMoney total;
  final String attemptId;
  final String idempotencyKey;
  final String environment;
  final DateTime createdAt;
  final String? customerId;
  final String? methodId;
  final int revision;

  factory PaymentCheckoutRequest.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "orderRevision",
      "orderFingerprint",
      "quoteId",
      "total",
      "attemptId",
      "idempotencyKey",
      "environment",
      "createdAt",
      "customerId",
      "methodId",
      "revision",
    });
    final value = PaymentCheckoutRequest(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      orderRevision: PaymentCodec.integer(
        json,
        'orderRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      orderFingerprint: PaymentCodec.text(
        json,
        'orderFingerprint',
        required: true,
      )!,
      quoteId: PaymentCodec.text(json, 'quoteId', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      attemptId: PaymentCodec.text(json, 'attemptId', required: true)!,
      idempotencyKey: PaymentCodec.text(
        json,
        'idempotencyKey',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      customerId: PaymentCodec.text(json, 'customerId'),
      methodId: PaymentCodec.text(json, 'methodId'),
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

  static PaymentResult<PaymentCheckoutRequest> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCheckoutRequest.fromJson(PaymentCodec.object(input)),
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

  PaymentCheckoutRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    int? orderRevision,
    String? orderFingerprint,
    String? quoteId,
    PaymentMoney? total,
    String? attemptId,
    String? idempotencyKey,
    String? environment,
    DateTime? createdAt,
    String? customerId,
    String? methodId,
    int? revision,
  }) {
    final clearableFields = <String>{"customerId", "methodId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCheckoutRequest(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderRevision: (orderRevision ?? this.orderRevision),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      quoteId: (quoteId ?? this.quoteId),
      total: (total ?? this.total),
      attemptId: (attemptId ?? this.attemptId),
      idempotencyKey: (idempotencyKey ?? this.idempotencyKey),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      customerId: clear.contains('customerId')
          ? null
          : (customerId ?? this.customerId),
      methodId: clear.contains('methodId') ? null : (methodId ?? this.methodId),
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
      if (orderRevision < 0 || orderRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'orderRevision',
            'range',
            'Number is outside the payment limits',
          ),
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
      for (final issue in total.validate())
        validationIssues.add(
          PaymentIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (attemptId.trim().isEmpty || attemptId.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
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
    if (customerId != null) {
      if (customerId!.trim().isEmpty || customerId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (methodId != null) {
      if (methodId!.trim().isEmpty || methodId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('methodId', 'text', 'Use nonempty bounded text'),
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
        orderRevision < 1 ||
        !{'test', 'live'}.contains(environment) ||
        idempotencyKey.length > 200)
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
    "orderRevision": orderRevision,
    "orderFingerprint": orderFingerprint,
    "quoteId": quoteId,
    "total": total.toJson(),
    "attemptId": attemptId,
    "idempotencyKey": idempotencyKey,
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    if (customerId != null) "customerId": customerId,
    if (methodId != null) "methodId": methodId,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCheckoutRequest &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCheckoutRequest(redacted)';
}
