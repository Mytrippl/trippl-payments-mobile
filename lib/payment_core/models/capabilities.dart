// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'wallet_capability.dart';

class PaymentCapabilities {
  PaymentCapabilities({
    required this.scopeFingerprint,
    required this.environment,
    required this.observedAt,
    required this.expiresAt,
    List<String> currencies = const [],
    List<String> methodTypes = const [],
    List<PaymentWalletCapability> wallets = const [],
    this.delayedMethodsEnabled = false,
    this.serverVerified = false,
    this.revision = 1,
  }) : currencies = List.unmodifiable(currencies),
       methodTypes = List.unmodifiable(methodTypes),
       wallets = List.unmodifiable(wallets);

  final String scopeFingerprint;
  final String environment;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<String> currencies;
  final List<String> methodTypes;
  final List<PaymentWalletCapability> wallets;
  final bool delayedMethodsEnabled;
  final bool serverVerified;
  final int revision;

  factory PaymentCapabilities.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "environment",
      "observedAt",
      "expiresAt",
      "currencies",
      "methodTypes",
      "wallets",
      "delayedMethodsEnabled",
      "serverVerified",
      "revision",
    });
    final value = PaymentCapabilities(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      currencies:
          PaymentCodec.list(json, 'currencies', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      methodTypes:
          PaymentCodec.list(json, 'methodTypes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      wallets:
          PaymentCodec.list(
            json,
            'wallets',
            (v) => PaymentWalletCapability.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      delayedMethodsEnabled:
          PaymentCodec.boolean(json, 'delayedMethodsEnabled') ?? false,
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

  static PaymentResult<PaymentCapabilities> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCapabilities.fromJson(PaymentCodec.object(input)),
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

  PaymentCapabilities copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? environment,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<String>? currencies,
    List<String>? methodTypes,
    List<PaymentWalletCapability>? wallets,
    bool? delayedMethodsEnabled,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCapabilities(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      currencies: (currencies ?? this.currencies),
      methodTypes: (methodTypes ?? this.methodTypes),
      wallets: (wallets ?? this.wallets),
      delayedMethodsEnabled:
          (delayedMethodsEnabled ?? this.delayedMethodsEnabled),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
      if (currencies.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'currencies',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (currencies.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'currencies',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (methodTypes.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'methodTypes',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (methodTypes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'methodTypes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (wallets.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'wallets',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < wallets.length; i++)
        for (final issue in wallets[i].validate())
          validationIssues.add(
            PaymentIssue(
              'wallets[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
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
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "currencies": currencies,
    "methodTypes": methodTypes,
    "wallets": wallets.map((item) => item.toJson()).toList(),
    "delayedMethodsEnabled": delayedMethodsEnabled,
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCapabilities &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCapabilities(redacted)';
}
