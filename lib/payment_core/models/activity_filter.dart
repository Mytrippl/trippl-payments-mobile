// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentActivityFilter {
  PaymentActivityFilter({
    List<String> kinds = const [],
    List<String> statuses = const [],
    List<String> orderIds = const [],
    this.from,
    this.until,
    this.currency,
    this.limit = 50,
    this.newestFirst = true,
  }) : kinds = List.unmodifiable(kinds),
       statuses = List.unmodifiable(statuses),
       orderIds = List.unmodifiable(orderIds);

  final List<String> kinds;
  final List<String> statuses;
  final List<String> orderIds;
  final DateTime? from;
  final DateTime? until;
  final String? currency;
  final int limit;
  final bool newestFirst;

  factory PaymentActivityFilter.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "kinds",
      "statuses",
      "orderIds",
      "from",
      "until",
      "currency",
      "limit",
      "newestFirst",
    });
    final value = PaymentActivityFilter(
      kinds:
          PaymentCodec.list(json, 'kinds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      statuses:
          PaymentCodec.list(json, 'statuses', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      orderIds:
          PaymentCodec.list(json, 'orderIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      from: PaymentCodec.date(json, 'from'),
      until: PaymentCodec.date(json, 'until'),
      currency: PaymentCodec.text(json, 'currency'),
      limit:
          PaymentCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          50,
      newestFirst: PaymentCodec.boolean(json, 'newestFirst') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentActivityFilter> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentActivityFilter.fromJson(PaymentCodec.object(input)),
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

  PaymentActivityFilter copyWith({
    Set<String> clear = const {},
    List<String>? kinds,
    List<String>? statuses,
    List<String>? orderIds,
    DateTime? from,
    DateTime? until,
    String? currency,
    int? limit,
    bool? newestFirst,
  }) {
    final clearableFields = <String>{"from", "until", "currency"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentActivityFilter(
      kinds: (kinds ?? this.kinds),
      statuses: (statuses ?? this.statuses),
      orderIds: (orderIds ?? this.orderIds),
      from: clear.contains('from') ? null : (from ?? this.from),
      until: clear.contains('until') ? null : (until ?? this.until),
      currency: clear.contains('currency') ? null : (currency ?? this.currency),
      limit: (limit ?? this.limit),
      newestFirst: (newestFirst ?? this.newestFirst),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (kinds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'kinds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (kinds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue('kinds', 'text', 'Use bounded nonempty list text'),
        );
    }
    {
      if (statuses.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'statuses',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (statuses.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const PaymentIssue(
            'statuses',
            'text',
            'Use bounded nonempty list text',
          ),
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
    if (currency != null) {
      if (currency!.trim().isEmpty || currency!.length > 4000)
        validationIssues.add(
          const PaymentIssue('currency', 'text', 'Use nonempty bounded text'),
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
    if (limit < 1 ||
        limit > 100 ||
        from != null && until != null && until!.isBefore(from!) ||
        kinds.any(
          (k) => !{
            'payment',
            'refund',
            'invoice',
            'dispute',
            'plan',
            'receipt',
          }.contains(k),
        ))
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
    "kinds": kinds,
    "statuses": statuses,
    "orderIds": orderIds,
    if (from != null) "from": from!.toUtc().toIso8601String(),
    if (until != null) "until": until!.toUtc().toIso8601String(),
    if (currency != null) "currency": currency,
    "limit": limit,
    "newestFirst": newestFirst,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentActivityFilter &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentActivityFilter(redacted)';
}
