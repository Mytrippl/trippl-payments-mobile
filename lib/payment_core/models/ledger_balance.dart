// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'money.dart';

class PaymentLedgerBalance {
  PaymentLedgerBalance({
    required this.currency,
    required this.openingMinor,
    required this.closingMinor,
    required this.debit,
    required this.credit,
    required this.calculatedAt,
    this.reconciled = false,
    this.complete = false,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String currency;
  final int openingMinor;
  final int closingMinor;
  final PaymentMoney debit;
  final PaymentMoney credit;
  final DateTime calculatedAt;
  final bool reconciled;
  final bool complete;
  final List<String> reasonCodes;

  factory PaymentLedgerBalance.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "currency",
      "openingMinor",
      "closingMinor",
      "debit",
      "credit",
      "calculatedAt",
      "reconciled",
      "complete",
      "reasonCodes",
    });
    final value = PaymentLedgerBalance(
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      openingMinor: PaymentCodec.integer(
        json,
        'openingMinor',
        required: true,
        minimum: -9000000000000,
        maximum: 9000000000000,
      )!,
      closingMinor: PaymentCodec.integer(
        json,
        'closingMinor',
        required: true,
        minimum: -9000000000000,
        maximum: 9000000000000,
      )!,
      debit: (json['debit'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['debit'])))!,
      credit: (json['credit'] == null
          ? null
          : PaymentMoney.fromJson(PaymentCodec.object(json['credit'])))!,
      calculatedAt: PaymentCodec.date(json, 'calculatedAt', required: true)!,
      reconciled: PaymentCodec.boolean(json, 'reconciled') ?? false,
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
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

  static PaymentResult<PaymentLedgerBalance> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentLedgerBalance.fromJson(PaymentCodec.object(input)),
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

  PaymentLedgerBalance copyWith({
    Set<String> clear = const {},
    String? currency,
    int? openingMinor,
    int? closingMinor,
    PaymentMoney? debit,
    PaymentMoney? credit,
    DateTime? calculatedAt,
    bool? reconciled,
    bool? complete,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentLedgerBalance(
      currency: (currency ?? this.currency),
      openingMinor: (openingMinor ?? this.openingMinor),
      closingMinor: (closingMinor ?? this.closingMinor),
      debit: (debit ?? this.debit),
      credit: (credit ?? this.credit),
      calculatedAt: (calculatedAt ?? this.calculatedAt),
      reconciled: (reconciled ?? this.reconciled),
      complete: (complete ?? this.complete),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
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
      if (openingMinor < -9000000000000 || openingMinor > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'openingMinor',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (closingMinor < -9000000000000 || closingMinor > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'closingMinor',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      for (final issue in debit.validate())
        validationIssues.add(
          PaymentIssue(
            'debit.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in credit.validate())
        validationIssues.add(
          PaymentIssue(
            'credit.${issue.field}',
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
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "currency": currency,
    "openingMinor": openingMinor,
    "closingMinor": closingMinor,
    "debit": debit.toJson(),
    "credit": credit.toJson(),
    "calculatedAt": calculatedAt.toUtc().toIso8601String(),
    "reconciled": reconciled,
    "complete": complete,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentLedgerBalance &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentLedgerBalance(redacted)';
}
