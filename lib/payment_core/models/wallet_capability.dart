// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentWalletCapability {
  PaymentWalletCapability({
    required this.kind,
    required this.supported,
    required this.checkedAt,
    required this.expiresAt,
    required this.environment,
    this.merchantCountry,
    this.currency,
    this.source = "sdk",
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String kind;
  final bool supported;
  final DateTime checkedAt;
  final DateTime expiresAt;
  final String environment;
  final String? merchantCountry;
  final String? currency;
  final String source;
  final List<String> reasonCodes;

  factory PaymentWalletCapability.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "kind",
      "supported",
      "checkedAt",
      "expiresAt",
      "environment",
      "merchantCountry",
      "currency",
      "source",
      "reasonCodes",
    });
    final value = PaymentWalletCapability(
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      supported: PaymentCodec.boolean(json, 'supported', required: true)!,
      checkedAt: PaymentCodec.date(json, 'checkedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      merchantCountry: PaymentCodec.text(json, 'merchantCountry'),
      currency: PaymentCodec.text(json, 'currency'),
      source: PaymentCodec.text(json, 'source') ?? "sdk",
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentWalletCapability> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentWalletCapability.fromJson(PaymentCodec.object(input)),
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

  PaymentWalletCapability copyWith({
    Set<String> clear = const {},
    String? kind,
    bool? supported,
    DateTime? checkedAt,
    DateTime? expiresAt,
    String? environment,
    String? merchantCountry,
    String? currency,
    String? source,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{"merchantCountry", "currency"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentWalletCapability(
      kind: (kind ?? this.kind),
      supported: (supported ?? this.supported),
      checkedAt: (checkedAt ?? this.checkedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      environment: (environment ?? this.environment),
      merchantCountry: clear.contains('merchantCountry')
          ? null
          : (merchantCountry ?? this.merchantCountry),
      currency: clear.contains('currency') ? null : (currency ?? this.currency),
      source: (source ?? this.source),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
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
    if (merchantCountry != null) {
      if (merchantCountry!.trim().isEmpty || merchantCountry!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'merchantCountry',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (currency != null) {
      if (currency!.trim().isEmpty || currency!.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (source.trim().isEmpty || source.length > 4000)
        validationIssues.add(
          const PaymentIssue('source', 'text', 'Use nonempty bounded text'),
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
    if (!{'applePay', 'googlePay', 'card'}.contains(kind) ||
        !expiresAt.isAfter(checkedAt) ||
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
    "kind": kind,
    "supported": supported,
    "checkedAt": checkedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "environment": environment,
    if (merchantCountry != null) "merchantCountry": merchantCountry,
    if (currency != null) "currency": currency,
    "source": source,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentWalletCapability &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentWalletCapability(redacted)';
}
