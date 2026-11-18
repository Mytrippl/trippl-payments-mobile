// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentStatementQuery {
  PaymentStatementQuery({
    required this.customerId,
    required this.currency,
    required this.periodStart,
    required this.periodEnd,
    this.includePending = false,
    List<String> orderIds = const [],
    this.limit = 100,
  }) : orderIds = List.unmodifiable(orderIds);

  final String customerId;
  final String currency;
  final DateTime periodStart;
  final DateTime periodEnd;
  final bool includePending;
  final List<String> orderIds;
  final int limit;

  factory PaymentStatementQuery.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "customerId",
      "currency",
      "periodStart",
      "periodEnd",
      "includePending",
      "orderIds",
      "limit",
    });
    final value = PaymentStatementQuery(
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      currency: PaymentCodec.text(json, 'currency', required: true)!,
      periodStart: PaymentCodec.date(json, 'periodStart', required: true)!,
      periodEnd: PaymentCodec.date(json, 'periodEnd', required: true)!,
      includePending: PaymentCodec.boolean(json, 'includePending') ?? false,
      orderIds:
          PaymentCodec.list(json, 'orderIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      limit:
          PaymentCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentStatementQuery> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentStatementQuery.fromJson(PaymentCodec.object(input)),
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

  PaymentStatementQuery copyWith({
    Set<String> clear = const {},
    String? customerId,
    String? currency,
    DateTime? periodStart,
    DateTime? periodEnd,
    bool? includePending,
    List<String>? orderIds,
    int? limit,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentStatementQuery(
      customerId: (customerId ?? this.customerId),
      currency: (currency ?? this.currency),
      periodStart: (periodStart ?? this.periodStart),
      periodEnd: (periodEnd ?? this.periodEnd),
      includePending: (includePending ?? this.includePending),
      orderIds: (orderIds ?? this.orderIds),
      limit: (limit ?? this.limit),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (customerId.trim().isEmpty || customerId.length > 4000)
        validationIssues.add(
          const PaymentIssue('customerId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderIds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'orderIds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (orderIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'orderIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (limit < 0 || limit > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'limit',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (periodEnd.isBefore(periodStart) ||
        periodEnd.difference(periodStart).inDays > 366 ||
        limit < 1 ||
        limit > 100)
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
    "customerId": customerId,
    "currency": currency,
    "periodStart": periodStart.toUtc().toIso8601String(),
    "periodEnd": periodEnd.toUtc().toIso8601String(),
    "includePending": includePending,
    "orderIds": orderIds,
    "limit": limit,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentStatementQuery &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentStatementQuery(redacted)';
}
