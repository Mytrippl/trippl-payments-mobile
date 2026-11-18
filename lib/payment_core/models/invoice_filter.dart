// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentInvoiceFilter {
  PaymentInvoiceFilter({
    required this.customerId,
    List<String> orderIds = const [],
    List<String> statuses = const [],
    this.currency,
    this.issuedFrom,
    this.issuedUntil,
    this.includeDrafts = false,
    this.limit = 20,
  }) : orderIds = List.unmodifiable(orderIds),
       statuses = List.unmodifiable(statuses);

  final String customerId;
  final List<String> orderIds;
  final List<String> statuses;
  final String? currency;
  final DateTime? issuedFrom;
  final DateTime? issuedUntil;
  final bool includeDrafts;
  final int limit;

  factory PaymentInvoiceFilter.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "customerId",
      "orderIds",
      "statuses",
      "currency",
      "issuedFrom",
      "issuedUntil",
      "includeDrafts",
      "limit",
    });
    final value = PaymentInvoiceFilter(
      customerId: PaymentCodec.text(json, 'customerId', required: true)!,
      orderIds:
          PaymentCodec.list(json, 'orderIds', (v) {
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
      currency: PaymentCodec.text(json, 'currency'),
      issuedFrom: PaymentCodec.date(json, 'issuedFrom'),
      issuedUntil: PaymentCodec.date(json, 'issuedUntil'),
      includeDrafts: PaymentCodec.boolean(json, 'includeDrafts') ?? false,
      limit:
          PaymentCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentInvoiceFilter> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoiceFilter.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoiceFilter copyWith({
    Set<String> clear = const {},
    String? customerId,
    List<String>? orderIds,
    List<String>? statuses,
    String? currency,
    DateTime? issuedFrom,
    DateTime? issuedUntil,
    bool? includeDrafts,
    int? limit,
  }) {
    final clearableFields = <String>{"currency", "issuedFrom", "issuedUntil"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoiceFilter(
      customerId: (customerId ?? this.customerId),
      orderIds: (orderIds ?? this.orderIds),
      statuses: (statuses ?? this.statuses),
      currency: clear.contains('currency') ? null : (currency ?? this.currency),
      issuedFrom: clear.contains('issuedFrom')
          ? null
          : (issuedFrom ?? this.issuedFrom),
      issuedUntil: clear.contains('issuedUntil')
          ? null
          : (issuedUntil ?? this.issuedUntil),
      includeDrafts: (includeDrafts ?? this.includeDrafts),
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
        issuedFrom != null &&
            issuedUntil != null &&
            issuedUntil!.isBefore(issuedFrom!) ||
        statuses.any(
          (s) => !{
            'draft',
            'open',
            'paid',
            'void',
            'uncollectible',
            'unknown',
          }.contains(s),
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
    "customerId": customerId,
    "orderIds": orderIds,
    "statuses": statuses,
    if (currency != null) "currency": currency,
    if (issuedFrom != null) "issuedFrom": issuedFrom!.toUtc().toIso8601String(),
    if (issuedUntil != null)
      "issuedUntil": issuedUntil!.toUtc().toIso8601String(),
    "includeDrafts": includeDrafts,
    "limit": limit,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoiceFilter &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoiceFilter(redacted)';
}
