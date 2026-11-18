// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReconciliation {
  PaymentReconciliation({
    required this.orderId,
    required this.intentId,
    required this.evaluatedAt,
    required this.state,
    this.amountMatched = false,
    this.currencyMatched = false,
    this.customerMatched = false,
    this.orderRevisionMatched = false,
    this.serverVerified = false,
    List<String> reasonCodes = const [],
    this.bookingConfirmed = false,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final String intentId;
  final DateTime evaluatedAt;
  final String state;
  final bool amountMatched;
  final bool currencyMatched;
  final bool customerMatched;
  final bool orderRevisionMatched;
  final bool serverVerified;
  final List<String> reasonCodes;
  final bool bookingConfirmed;

  factory PaymentReconciliation.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "intentId",
      "evaluatedAt",
      "state",
      "amountMatched",
      "currencyMatched",
      "customerMatched",
      "orderRevisionMatched",
      "serverVerified",
      "reasonCodes",
      "bookingConfirmed",
    });
    final value = PaymentReconciliation(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      amountMatched: PaymentCodec.boolean(json, 'amountMatched') ?? false,
      currencyMatched: PaymentCodec.boolean(json, 'currencyMatched') ?? false,
      customerMatched: PaymentCodec.boolean(json, 'customerMatched') ?? false,
      orderRevisionMatched:
          PaymentCodec.boolean(json, 'orderRevisionMatched') ?? false,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      bookingConfirmed: PaymentCodec.boolean(json, 'bookingConfirmed') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentReconciliation> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReconciliation.fromJson(PaymentCodec.object(input)),
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

  PaymentReconciliation copyWith({
    Set<String> clear = const {},
    String? orderId,
    String? intentId,
    DateTime? evaluatedAt,
    String? state,
    bool? amountMatched,
    bool? currencyMatched,
    bool? customerMatched,
    bool? orderRevisionMatched,
    bool? serverVerified,
    List<String>? reasonCodes,
    bool? bookingConfirmed,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReconciliation(
      orderId: (orderId ?? this.orderId),
      intentId: (intentId ?? this.intentId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      state: (state ?? this.state),
      amountMatched: (amountMatched ?? this.amountMatched),
      currencyMatched: (currencyMatched ?? this.currencyMatched),
      customerMatched: (customerMatched ?? this.customerMatched),
      orderRevisionMatched: (orderRevisionMatched ?? this.orderRevisionMatched),
      serverVerified: (serverVerified ?? this.serverVerified),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      bookingConfirmed: (bookingConfirmed ?? this.bookingConfirmed),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
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
    if (!{'matched', 'mismatch', 'pending', 'unknown'}.contains(state))
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
    "orderId": orderId,
    "intentId": intentId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "state": state,
    "amountMatched": amountMatched,
    "currencyMatched": currencyMatched,
    "customerMatched": customerMatched,
    "orderRevisionMatched": orderRevisionMatched,
    "serverVerified": serverVerified,
    "reasonCodes": reasonCodes,
    "bookingConfirmed": bookingConfirmed,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReconciliation &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReconciliation(redacted)';
}
