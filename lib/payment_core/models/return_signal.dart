// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentReturnSignal {
  PaymentReturnSignal({
    required this.receivedAt,
    required this.kind,
    this.intentId,
    this.stateFingerprint,
    this.needsVerification = true,
    this.paymentConfirmed = false,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final DateTime receivedAt;
  final String kind;
  final String? intentId;
  final String? stateFingerprint;
  final bool needsVerification;
  final bool paymentConfirmed;
  final List<String> reasonCodes;

  factory PaymentReturnSignal.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "receivedAt",
      "kind",
      "intentId",
      "stateFingerprint",
      "needsVerification",
      "paymentConfirmed",
      "reasonCodes",
    });
    final value = PaymentReturnSignal(
      receivedAt: PaymentCodec.date(json, 'receivedAt', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      intentId: PaymentCodec.text(json, 'intentId'),
      stateFingerprint: PaymentCodec.text(json, 'stateFingerprint'),
      needsVerification:
          PaymentCodec.boolean(json, 'needsVerification') ?? true,
      paymentConfirmed: PaymentCodec.boolean(json, 'paymentConfirmed') ?? false,
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

  static PaymentResult<PaymentReturnSignal> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReturnSignal.fromJson(PaymentCodec.object(input)),
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

  PaymentReturnSignal copyWith({
    Set<String> clear = const {},
    DateTime? receivedAt,
    String? kind,
    String? intentId,
    String? stateFingerprint,
    bool? needsVerification,
    bool? paymentConfirmed,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{"intentId", "stateFingerprint"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReturnSignal(
      receivedAt: (receivedAt ?? this.receivedAt),
      kind: (kind ?? this.kind),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
      stateFingerprint: clear.contains('stateFingerprint')
          ? null
          : (stateFingerprint ?? this.stateFingerprint),
      needsVerification: (needsVerification ?? this.needsVerification),
      paymentConfirmed: (paymentConfirmed ?? this.paymentConfirmed),
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
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const PaymentIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (stateFingerprint != null) {
      if (stateFingerprint!.trim().isEmpty || stateFingerprint!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'stateFingerprint',
            'text',
            'Use nonempty bounded text',
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
    if (paymentConfirmed ||
        !{'successMarker', 'cancelMarker', 'unknown'}.contains(kind))
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
    "receivedAt": receivedAt.toUtc().toIso8601String(),
    "kind": kind,
    if (intentId != null) "intentId": intentId,
    if (stateFingerprint != null) "stateFingerprint": stateFingerprint,
    "needsVerification": needsVerification,
    "paymentConfirmed": paymentConfirmed,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReturnSignal &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReturnSignal(redacted)';
}
