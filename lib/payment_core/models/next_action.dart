// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentNextAction {
  PaymentNextAction({
    required this.intentId,
    required this.kind,
    required this.observedAt,
    required this.expiresAt,
    this.requiresSdk = true,
    this.returnUri,
    List<String> reasonCodes = const [],
    this.revision = 1,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String intentId;
  final String kind;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool requiresSdk;
  final String? returnUri;
  final List<String> reasonCodes;
  final int revision;

  factory PaymentNextAction.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "intentId",
      "kind",
      "observedAt",
      "expiresAt",
      "requiresSdk",
      "returnUri",
      "reasonCodes",
      "revision",
    });
    final value = PaymentNextAction(
      intentId: PaymentCodec.text(json, 'intentId', required: true)!,
      kind: PaymentCodec.text(json, 'kind', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      requiresSdk: PaymentCodec.boolean(json, 'requiresSdk') ?? true,
      returnUri: PaymentCodec.text(json, 'returnUri'),
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
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

  static PaymentResult<PaymentNextAction> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentNextAction.fromJson(PaymentCodec.object(input)),
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

  PaymentNextAction copyWith({
    Set<String> clear = const {},
    String? intentId,
    String? kind,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? requiresSdk,
    String? returnUri,
    List<String>? reasonCodes,
    int? revision,
  }) {
    final clearableFields = <String>{"returnUri"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentNextAction(
      intentId: (intentId ?? this.intentId),
      kind: (kind ?? this.kind),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      requiresSdk: (requiresSdk ?? this.requiresSdk),
      returnUri: clear.contains('returnUri')
          ? null
          : (returnUri ?? this.returnUri),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      revision: (revision ?? this.revision),
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
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const PaymentIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (returnUri != null) {
      if (returnUri!.trim().isEmpty || returnUri!.length > 4000)
        validationIssues.add(
          const PaymentIssue('returnUri', 'text', 'Use nonempty bounded text'),
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
        !{
          'authenticate',
          'awaitProcessing',
          'provideMethod',
          'confirm',
          'none',
          'unknown',
        }.contains(kind))
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
    "intentId": intentId,
    "kind": kind,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "requiresSdk": requiresSdk,
    if (returnUri != null) "returnUri": returnUri,
    "reasonCodes": reasonCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentNextAction && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentNextAction(redacted)';
}
