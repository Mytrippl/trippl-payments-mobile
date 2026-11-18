// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentRefundPreview {
  PaymentRefundPreview({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.draftFingerprint,
    required this.orderId,
    required this.intentId,
    required this.requested,
    required this.fee,
    required this.net,
    required this.status,
    List<String> warningCodes = const [],
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String draftFingerprint;
  final String orderId;
  final String intentId;
  final PaymentMoney requested;
  final PaymentMoney fee;
  final PaymentMoney net;
  final String status;
  final List<String> warningCodes;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentRefundPreview.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "draftFingerprint",
      "orderId",
      "intentId",
      "requested",
      "fee",
      "net",
      "status",
      "warningCodes",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentRefundPreview(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      draftFingerprint: PaymentCodec.text(
        json,
        'draftFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      requested: (json['requested'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['requested'])))!,
      fee: (json['fee'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['fee'])))!,
      net: (json['net'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['net'])))!,
      status: PaymentCodec.text(json, 'status', required: true)!,
      warningCodes:
          PaymentCodec.list(json, 'warningCodes', (v) {
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

  static PaymentResult<PaymentRefundPreview> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentRefundPreview.fromJson(PaymentCodec.object(input)),
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

  PaymentRefundPreview copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? draftFingerprint,
    String? orderId,
    String? intentId,
    PaymentMoney? requested,
    PaymentMoney? fee,
    PaymentMoney? net,
    String? status,
    List<String>? warningCodes,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentRefundPreview(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      draftFingerprint: (draftFingerprint ?? this.draftFingerprint),
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      requested: (requested ?? this.requested),
      fee: (fee ?? this.fee),
      net: (net ?? this.net),
      status: (status ?? this.status),
      warningCodes: (warningCodes ?? this.warningCodes),
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
      if (draftFingerprint.trim().isEmpty || draftFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'draftFingerprint',
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
      for (final issue in requested.validate())
        validationIssues.add(
          PaymentIssue(
            'requested.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in fee.validate())
        validationIssues.add(
          PaymentIssue(
            'fee.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in net.validate())
        validationIssues.add(
          PaymentIssue(
            'net.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (status.trim().isEmpty || status.length > 4000)
        validationIssues.add(
          const PaymentIssue('status', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'warningCodes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'warningCodes',
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
        !{'test', 'live'}.contains(environment) ||
        !{'review', 'blocked', 'unknown'}.contains(status))
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
    "draftFingerprint": draftFingerprint,
    "orderId": orderId,
    "intentId": intentId,
    "requested": requested.toJson(),
    "fee": fee.toJson(),
    "net": net.toJson(),
    "status": status,
    "warningCodes": warningCodes,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentRefundPreview &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentRefundPreview(redacted)';
}
