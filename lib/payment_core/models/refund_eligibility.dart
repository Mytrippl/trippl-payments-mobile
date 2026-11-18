// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';
import 'refund_reason.dart';

class PaymentRefundEligibility {
  PaymentRefundEligibility({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.intentId,
    required this.available,
    required this.maximumRequest,
    required this.eligible,
    List<PaymentRefundReason> reasons = const [],
    List<String> reasonCodes = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : reasons = List.unmodifiable(reasons),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final String intentId;
  final PaymentMoney available;
  final PaymentMoney maximumRequest;
  final bool eligible;
  final List<PaymentRefundReason> reasons;
  final List<String> reasonCodes;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentRefundEligibility.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "intentId",
      "available",
      "maximumRequest",
      "eligible",
      "reasons",
      "reasonCodes",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentRefundEligibility(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      available: (json['available'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['available'])))!,
      maximumRequest: (json['maximumRequest'] == null
          ? null
          : PaymentMoney.fromJson(
              PaymentCodec.object(json['maximumRequest']),
            ))!,
      eligible: PaymentCodec.boolean(json, 'eligible', required: true)!,
      reasons:
          PaymentCodec.list(
            json,
            'reasons',
            (v) => PaymentRefundReason.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
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

  static PaymentResult<PaymentRefundEligibility> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundEligibility.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundEligibility copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    String? intentId,
    PaymentMoney? available,
    PaymentMoney? maximumRequest,
    bool? eligible,
    List<PaymentRefundReason>? reasons,
    List<String>? reasonCodes,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundEligibility(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      available: (available ?? this.available),
      maximumRequest: (maximumRequest ?? this.maximumRequest),
      eligible: (eligible ?? this.eligible),
      reasons: (reasons ?? this.reasons),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
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
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in available.validate())
        validationIssues.add(
          PaymentIssue(
            'available.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in maximumRequest.validate())
        validationIssues.add(
          PaymentIssue(
            'maximumRequest.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (reasons.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'reasons',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < reasons.length; i++)
        for (final issue in reasons[i].validate())
          validationIssues.add(
            PaymentIssue(
              'reasons[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'reasonCodes',
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
    if (revision < 1 ||
        !expiresAt.isAfter(observedAt) ||
        !{'test', 'live'}.contains(environment))
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
    "intentId": intentId,
    "available": available.toJson(),
    "maximumRequest": maximumRequest.toJson(),
    "eligible": eligible,
    "reasons": reasons.map((item) => item.toJson()).toList(),
    "reasonCodes": reasonCodes,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundEligibility &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundEligibility(redacted)';
}
