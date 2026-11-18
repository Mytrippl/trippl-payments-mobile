// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentCheckoutResult {
  PaymentCheckoutResult({
    required this.orderId,
    required this.attemptId,
    required this.evaluatedAt,
    required this.state,
    this.intentId,
    this.sdkCompleted = false,
    this.serverVerified = false,
    this.paid = false,
    this.bookingConfirmed = false,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String orderId;
  final String attemptId;
  final DateTime evaluatedAt;
  final String state;
  final String? intentId;
  final bool sdkCompleted;
  final bool serverVerified;
  final bool paid;
  final bool bookingConfirmed;
  final List<String> reasonCodes;

  factory PaymentCheckoutResult.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "orderId",
      "attemptId",
      "evaluatedAt",
      "state",
      "intentId",
      "sdkCompleted",
      "serverVerified",
      "paid",
      "bookingConfirmed",
      "reasonCodes",
    });
    final value = PaymentCheckoutResult(
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      attemptId: PaymentCodec.text(json, 'attemptId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      sdkCompleted: PaymentCodec.boolean(json, 'sdkCompleted') ?? false,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      paid: PaymentCodec.boolean(json, 'paid') ?? false,
      bookingConfirmed: PaymentCodec.boolean(json, 'bookingConfirmed') ?? false,
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

  static PaymentResult<PaymentCheckoutResult> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCheckoutResult.fromJson(PaymentCodec.object(input)),
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

  PaymentCheckoutResult copyWith({
    Set<String> clear = const {},
    String? orderId,
    String? attemptId,
    DateTime? evaluatedAt,
    String? state,
    String? intentId,
    bool? sdkCompleted,
    bool? serverVerified,
    bool? paid,
    bool? bookingConfirmed,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{"intentId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCheckoutResult(
      orderId: (orderId ?? this.orderId),
      attemptId: (attemptId ?? this.attemptId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      state: (state ?? this.state),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      sdkCompleted: (sdkCompleted ?? this.sdkCompleted),
      serverVerified: (serverVerified ?? this.serverVerified),
      paid: (paid ?? this.paid),
      bookingConfirmed: (bookingConfirmed ?? this.bookingConfirmed),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
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
      if (attemptId.trim().isEmpty || attemptId.length > 4000)
        validationIssues.add(
          const PaymentIssue('attemptId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
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
    if (paid && !serverVerified || bookingConfirmed && !paid)
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
    "attemptId": attemptId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "state": state,
    if (intentId != null) "intentId": intentId,
    "sdkCompleted": sdkCompleted,
    "serverVerified": serverVerified,
    "paid": paid,
    "bookingConfirmed": bookingConfirmed,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCheckoutResult &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCheckoutResult(redacted)';
}
