// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'currency_rule.dart';

class PaymentCurrencyCatalog {
  PaymentCurrencyCatalog({
    required this.id,
    required this.scopeFingerprint,
    required this.merchantCountry,
    required this.observedAt,
    required this.expiresAt,
    List<PaymentCurrencyRule> rules = const [],
    this.serverVerified = false,
    this.revision = 1,
  }) : rules = List.unmodifiable(rules);

  final String id;
  final String scopeFingerprint;
  final String merchantCountry;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<PaymentCurrencyRule> rules;
  final bool serverVerified;
  final int revision;

  factory PaymentCurrencyCatalog.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "merchantCountry",
      "observedAt",
      "expiresAt",
      "rules",
      "serverVerified",
      "revision",
    });
    final value = PaymentCurrencyCatalog(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      merchantCountry: PaymentCodec.text(
        json,
        'merchantCountry',
        required: true,
      )!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      rules:
          PaymentCodec.list(
            json,
            'rules',
            (v) => PaymentCurrencyRule.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
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

  static PaymentResult<PaymentCurrencyCatalog> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCurrencyCatalog.fromJson(PaymentCodec.object(input)),
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

  PaymentCurrencyCatalog copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? merchantCountry,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<PaymentCurrencyRule>? rules,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCurrencyCatalog(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      merchantCountry: (merchantCountry ?? this.merchantCountry),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      rules: (rules ?? this.rules),
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
      if (merchantCountry.trim().isEmpty || merchantCountry.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'merchantCountry',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (rules.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'rules',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < rules.length; i++)
        for (final issue in rules[i].validate())
          validationIssues.add(
            PaymentIssue(
              'rules[$i].${issue.field}',
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
        !RegExp(r'^[A-Z]{2}$').hasMatch(merchantCountry) ||
        rules.map((r) => r.currency).toSet().length != rules.length)
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
    "merchantCountry": merchantCountry,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "rules": rules.map((item) => item.toJson()).toList(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCurrencyCatalog &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCurrencyCatalog(redacted)';
}
