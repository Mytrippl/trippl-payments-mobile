// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'fx_rate.dart';
import 'money.dart';

class PaymentFxQuote {
  PaymentFxQuote({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.orderId,
    required this.sourceAmount,
    required this.targetAmount,
    required this.rate,
    required this.fee,
    this.rounding = "halfUp",
    this.chargeCurrencyUnchanged = true,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String orderId;
  final PaymentMoney sourceAmount;
  final PaymentMoney targetAmount;
  final PaymentFxRate rate;
  final PaymentMoney fee;
  final String rounding;
  final bool chargeCurrencyUnchanged;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentFxQuote.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "orderId",
      "sourceAmount",
      "targetAmount",
      "rate",
      "fee",
      "rounding",
      "chargeCurrencyUnchanged",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentFxQuote(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      sourceAmount: (json['sourceAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['sourceAmount'])))!,
      targetAmount: (json['targetAmount'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['targetAmount'])))!,
      rate: (json['rate'] == null
          ? null
          : PaymentFxRate.fromJson(PaymentCodec.object(json['rate'])))!,
      fee: (json['fee'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['fee'])))!,
      rounding: PaymentCodec.text(json, 'rounding') ?? "halfUp",
      chargeCurrencyUnchanged:
          PaymentCodec.boolean(json, 'chargeCurrencyUnchanged') ?? true,
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

  static PaymentResult<PaymentFxQuote> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentFxQuote.fromJson(PaymentCodec.object(input)),
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

  PaymentFxQuote copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? orderId,
    PaymentMoney? sourceAmount,
    PaymentMoney? targetAmount,
    PaymentFxRate? rate,
    PaymentMoney? fee,
    String? rounding,
    bool? chargeCurrencyUnchanged,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentFxQuote(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      orderId: (orderId ?? this.orderId),
      sourceAmount: (sourceAmount ?? this.sourceAmount),
      targetAmount: (targetAmount ?? this.targetAmount),
      rate: (rate ?? this.rate),
      fee: (fee ?? this.fee),
      rounding: (rounding ?? this.rounding),
      chargeCurrencyUnchanged:
          (chargeCurrencyUnchanged ?? this.chargeCurrencyUnchanged),
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
      for (final issue in sourceAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'sourceAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in targetAmount.validate())
        validationIssues.add(
          PaymentIssue(
            'targetAmount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in rate.validate())
        validationIssues.add(
          PaymentIssue(
            'rate.${issue.field}',
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
      if (rounding.trim().isEmpty || rounding.length > 4000)
        validationIssues.add(
          const PaymentIssue('rounding', 'text', 'Use nonempty bounded text'),
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
        !{'floor', 'halfUp', 'ceil'}.contains(rounding) ||
        !chargeCurrencyUnchanged)
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
    "sourceAmount": sourceAmount.toJson(),
    "targetAmount": targetAmount.toJson(),
    "rate": rate.toJson(),
    "fee": fee.toJson(),
    "rounding": rounding,
    "chargeCurrencyUnchanged": chargeCurrencyUnchanged,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentFxQuote && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentFxQuote(redacted)';
}
