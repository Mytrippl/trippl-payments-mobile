// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'credentials_reference.dart';
import 'money.dart';

class PaymentAllocation {
  PaymentAllocation({
    required this.id,
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.orderId,
    required this.quoteId,
    required this.intentId,
    required this.total,
    required this.credentials,
    required this.environment,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String requestFingerprint;
  final String orderId;
  final String quoteId;
  final String intentId;
  final PaymentMoney total;
  final PaymentCredentialsReference credentials;
  final String environment;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentAllocation.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "requestFingerprint",
      "orderId",
      "quoteId",
      "intentId",
      "total",
      "credentials",
      "environment",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentAllocation(
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
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      quoteId: PaymentCodec.text(json, 'quoteId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      total: (json['total'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['total'])))!,
      credentials: (json['credentials'] == null
          ? null
          : PaymentCredentialsReference.fromJson(
              PaymentCodec.object(json['credentials']),
            ))!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
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

  static PaymentResult<PaymentAllocation> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentAllocation.fromJson(PaymentCodec.object(input)),
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

  PaymentAllocation copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? requestFingerprint,
    String? orderId,
    String? quoteId,
    String? intentId,
    PaymentMoney? total,
    PaymentCredentialsReference? credentials,
    String? environment,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentAllocation(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      orderId: (orderId ?? this.orderId),
      quoteId: (quoteId ?? this.quoteId),
      intentId: (intentId ?? this.intentId),
      total: (total ?? this.total),
      credentials: (credentials ?? this.credentials),
      environment: (environment ?? this.environment),
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
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (quoteId.trim().isEmpty || quoteId.length > 4000)
        validationIssues.add(
          const PaymentIssue('quoteId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
      for (final issue in credentials.validate())
        validationIssues.add(
          PaymentIssue(
            'credentials.${issue.field}',
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
    "requestFingerprint": requestFingerprint,
    "orderId": orderId,
    "quoteId": quoteId,
    "intentId": intentId,
    "total": total.toJson(),
    "credentials": credentials.toJson(),
    "environment": environment,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentAllocation && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentAllocation(redacted)';
}
