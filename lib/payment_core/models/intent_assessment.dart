// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentIntentAssessment {
  PaymentIntentAssessment({
    required this.intentId,
    required this.orderId,
    required this.evaluatedAt,
    required this.state,
    this.paid = false,
    this.pending = false,
    this.authorized = false,
    this.requiresAction = false,
    this.terminal = false,
    List<String> reasonCodes = const [],
    this.serverVerified = false,
    this.bookingConfirmed = false,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String intentId;
  final String orderId;
  final DateTime evaluatedAt;
  final String state;
  final bool paid;
  final bool pending;
  final bool authorized;
  final bool requiresAction;
  final bool terminal;
  final List<String> reasonCodes;
  final bool serverVerified;
  final bool bookingConfirmed;

  factory PaymentIntentAssessment.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "intentId",
      "orderId",
      "evaluatedAt",
      "state",
      "paid",
      "pending",
      "authorized",
      "requiresAction",
      "terminal",
      "reasonCodes",
      "serverVerified",
      "bookingConfirmed",
    });
    final value = PaymentIntentAssessment(
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      evaluatedAt: PaymentCodec.date(json, 'evaluatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      paid: PaymentCodec.boolean(json, 'paid') ?? false,
      pending: PaymentCodec.boolean(json, 'pending') ?? false,
      authorized: PaymentCodec.boolean(json, 'authorized') ?? false,
      requiresAction: PaymentCodec.boolean(json, 'requiresAction') ?? false,
      terminal: PaymentCodec.boolean(json, 'terminal') ?? false,
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      bookingConfirmed: PaymentCodec.boolean(json, 'bookingConfirmed') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentIntentAssessment> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentIntentAssessment.fromJson(PaymentCodec.object(input)),
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

  PaymentIntentAssessment copyWith({
    Set<String> clear = const {},
    String? intentId,
    String? orderId,
    DateTime? evaluatedAt,
    String? state,
    bool? paid,
    bool? pending,
    bool? authorized,
    bool? requiresAction,
    bool? terminal,
    List<String>? reasonCodes,
    bool? serverVerified,
    bool? bookingConfirmed,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentIntentAssessment(
      intentId: (intentId ?? this.intentId),
      orderId: (orderId ?? this.orderId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      state: (state ?? this.state),
      paid: (paid ?? this.paid),
      pending: (pending ?? this.pending),
      authorized: (authorized ?? this.authorized),
      requiresAction: (requiresAction ?? this.requiresAction),
      terminal: (terminal ?? this.terminal),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      serverVerified: (serverVerified ?? this.serverVerified),
      bookingConfirmed: (bookingConfirmed ?? this.bookingConfirmed),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (orderId.trim().isEmpty || orderId.length > 4000)
        validationIssues.add(
          const PaymentIssue('orderId', 'text', 'Use nonempty bounded text'),
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
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "intentId": intentId,
    "orderId": orderId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "state": state,
    "paid": paid,
    "pending": pending,
    "authorized": authorized,
    "requiresAction": requiresAction,
    "terminal": terminal,
    "reasonCodes": reasonCodes,
    "serverVerified": serverVerified,
    "bookingConfirmed": bookingConfirmed,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentIntentAssessment &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentIntentAssessment(redacted)';
}
