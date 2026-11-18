// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentFxRate {
  PaymentFxRate({
    required this.id,
    required this.baseCurrency,
    required this.quoteCurrency,
    required this.numerator,
    required this.denominator,
    required this.source,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String baseCurrency;
  final String quoteCurrency;
  final int numerator;
  final int denominator;
  final String source;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentFxRate.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "baseCurrency",
      "quoteCurrency",
      "numerator",
      "denominator",
      "source",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentFxRate(
      id: PaymentCodec.text(json, 'id', required: true)!,
      baseCurrency: PaymentCodec.text(json, 'baseCurrency', required: true)!,
      quoteCurrency: PaymentCodec.text(json, 'quoteCurrency', required: true)!,
      numerator: PaymentCodec.integer(
        json,
        'numerator',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      denominator: PaymentCodec.integer(
        json,
        'denominator',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      source: PaymentCodec.text(json, 'source', required: true)!,
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

  static PaymentResult<PaymentFxRate> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentFxRate.fromJson(PaymentCodec.object(input)),
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

  PaymentFxRate copyWith({
    Set<String> clear = const {},
    String? id,
    String? baseCurrency,
    String? quoteCurrency,
    int? numerator,
    int? denominator,
    String? source,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentFxRate(
      id: (id ?? this.id),
      baseCurrency: (baseCurrency ?? this.baseCurrency),
      quoteCurrency: (quoteCurrency ?? this.quoteCurrency),
      numerator: (numerator ?? this.numerator),
      denominator: (denominator ?? this.denominator),
      source: (source ?? this.source),
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
      if (baseCurrency.trim().isEmpty || baseCurrency.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'baseCurrency',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (quoteCurrency.trim().isEmpty || quoteCurrency.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'quoteCurrency',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (numerator < 0 || numerator > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'numerator',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (denominator < 0 || denominator > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'denominator',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (source.trim().isEmpty || source.length > 4000)
        validationIssues.add(
          const PaymentIssue('source', 'text', 'Use nonempty bounded text'),
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
        numerator < 1 ||
        numerator > 100000000 ||
        denominator < 1 ||
        denominator > 100000000 ||
        baseCurrency == quoteCurrency)
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
    "baseCurrency": baseCurrency,
    "quoteCurrency": quoteCurrency,
    "numerator": numerator,
    "denominator": denominator,
    "source": source,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentFxRate && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentFxRate(redacted)';
}
