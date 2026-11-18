// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentVerificationRequest {
  PaymentVerificationRequest({
    required this.id,
    required this.scopeFingerprint,
    required this.orderId,
    required this.orderFingerprint,
    required this.intentId,
    required this.attemptId,
    required this.expectedTotal,
    required this.environment,
    required this.createdAt,
    this.minimumRevision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String orderId;
  final String orderFingerprint;
  final String intentId;
  final String attemptId;
  final PaymentMoney expectedTotal;
  final String environment;
  final DateTime createdAt;
  final int minimumRevision;

  factory PaymentVerificationRequest.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "orderId",
      "orderFingerprint",
      "intentId",
      "attemptId",
      "expectedTotal",
      "environment",
      "createdAt",
      "minimumRevision",
    });
    final value = PaymentVerificationRequest(
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
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      attemptId: PaymentCodec.text(json, 'attemptId', required: true)!,
      expectedTotal: (json['expectedTotal'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['expectedTotal'])))!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      minimumRevision:
          PaymentCodec.integer(
            json,
            'minimumRevision',
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

  static PaymentResult<PaymentVerificationRequest> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentVerificationRequest.fromJson(PaymentCodec.object(input)),
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

  PaymentVerificationRequest copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? orderId,
    String? orderFingerprint,
    String? intentId,
    String? attemptId,
    PaymentMoney? expectedTotal,
    String? environment,
    DateTime? createdAt,
    int? minimumRevision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentVerificationRequest(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      orderFingerprint: (orderFingerprint ?? this.orderFingerprint),
      intentId: (intentId ?? this.intentId),
      attemptId: (attemptId ?? this.attemptId),
      expectedTotal: (expectedTotal ?? this.expectedTotal),
      environment: (environment ?? this.environment),
      createdAt: (createdAt ?? this.createdAt),
      minimumRevision: (minimumRevision ?? this.minimumRevision),
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
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (attemptId.trim().isEmpty || attemptId.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in expectedTotal.validate())
        validationIssues.add(
          PaymentIssue(
            'expectedTotal.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
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
      if (minimumRevision < 0 || minimumRevision > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'minimumRevision',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (minimumRevision < 1 || !{'test', 'live'}.contains(environment))
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
    "intentId": intentId,
    "attemptId": attemptId,
    "expectedTotal": expectedTotal.toJson(),
    "environment": environment,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "minimumRevision": minimumRevision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentVerificationRequest &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentVerificationRequest(redacted)';
}
