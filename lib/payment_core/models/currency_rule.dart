// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCurrencyRule {
  PaymentCurrencyRule({
    required this.currency,
    required this.decimals,
    this.operation = "charge",
    this.stepMinor = 1,
    this.minimumMinor,
    this.maximumMinor,
    this.enabled = true,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String currency;
  final int decimals;
  final String operation;
  final int stepMinor;
  final int? minimumMinor;
  final int? maximumMinor;
  final bool enabled;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentCurrencyRule.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "currency",
      "decimals",
      "operation",
      "stepMinor",
      "minimumMinor",
      "maximumMinor",
      "enabled",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentCurrencyRule(
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      decimals: PaymentCodec.integer(
        json,
        'decimals',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      operation: PaymentCodec.text(json, 'operation') ?? "charge",
      stepMinor:
          PaymentCodec.integer(
            json,
            'stepMinor',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      minimumMinor: PaymentCodec.integer(
        json,
        'minimumMinor',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximumMinor: PaymentCodec.integer(
        json,
        'maximumMinor',
        minimum: 0,
        maximum: 9000000000000,
      ),
      enabled: PaymentCodec.boolean(json, 'enabled') ?? true,
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

  static PaymentResult<PaymentCurrencyRule> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCurrencyRule.fromJson(PaymentCodec.object(input)),
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

  PaymentCurrencyRule copyWith({
    Set<String> clear = const {},
    String? currency,
    int? decimals,
    String? operation,
    int? stepMinor,
    int? minimumMinor,
    int? maximumMinor,
    bool? enabled,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{"minimumMinor", "maximumMinor"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCurrencyRule(
      currency: (currency ?? this.currency),
      decimals: (decimals ?? this.decimals),
      operation: (operation ?? this.operation),
      stepMinor: (stepMinor ?? this.stepMinor),
      minimumMinor: clear.contains('minimumMinor')
          ? null
          : (minimumMinor ?? this.minimumMinor),
      maximumMinor: clear.contains('maximumMinor')
          ? null
          : (maximumMinor ?? this.maximumMinor),
      enabled: (enabled ?? this.enabled),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (decimals < 0 || decimals > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'decimals',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (operation.trim().isEmpty || operation.length > 4000)
        validationIssues.add(
          const PaymentIssue('operation', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (stepMinor < 0 || stepMinor > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'stepMinor',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (minimumMinor != null) {
      if (minimumMinor! < 0 || minimumMinor! > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'minimumMinor',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (maximumMinor != null) {
      if (maximumMinor! < 0 || maximumMinor! > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'maximumMinor',
            'range',
            'Number is outside the payment limits',
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
        decimals > 4 ||
        stepMinor < 1 ||
        operation != 'charge' ||
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency) ||
        !expiresAt.isAfter(observedAt) ||
        minimumMinor != null &&
            maximumMinor != null &&
            minimumMinor! > maximumMinor!)
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
    "currency": currency,
    "decimals": decimals,
    "operation": operation,
    "stepMinor": stepMinor,
    if (minimumMinor != null) "minimumMinor": minimumMinor,
    if (maximumMinor != null) "maximumMinor": maximumMinor,
    "enabled": enabled,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCurrencyRule &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCurrencyRule(redacted)';
}
