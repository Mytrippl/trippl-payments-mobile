// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentMoney {
  PaymentMoney({
    required this.currency,
    required this.amountMinor,
    this.decimals = 2,
  });

  final String currency;
  final int amountMinor;
  final int decimals;

  factory PaymentMoney.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {"currency", "amountMinor", "decimals"});
    final value = PaymentMoney(
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      amountMinor: PaymentCodec.integer(
        json,
        'amountMinor',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      decimals:
          PaymentCodec.integer(
            json,
            'decimals',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          2,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentMoney> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentMoney.fromJson(PaymentCodec.object(input)),
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

  PaymentMoney copyWith({
    Set<String> clear = const {},
    String? currency,
    int? amountMinor,
    int? decimals,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentMoney(
      currency: (currency ?? this.currency),
      amountMinor: (amountMinor ?? this.amountMinor),
      decimals: (decimals ?? this.decimals),
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
      if (amountMinor < 0 || amountMinor > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'amountMinor',
            'range',
            'Number is outside the payment limits',
          ),
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
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency) || decimals > 4)
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
    "amountMinor": amountMinor,
    "decimals": decimals,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentMoney && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentMoney(redacted)';
}
