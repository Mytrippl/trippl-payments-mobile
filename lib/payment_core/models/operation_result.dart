// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentOperationResult {
  PaymentOperationResult({
    required this.ticketId,
    required this.scopeFingerprint,
    required this.environment,
    required this.payloadFingerprint,
    required this.state,
    required this.observedAt,
    required this.expiresAt,
    this.referenceId,
    List<String> reasonCodes = const [],
    this.serverVerified = false,
    this.paymentMutationPerformed = false,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String ticketId;
  final String scopeFingerprint;
  final String environment;
  final String payloadFingerprint;
  final String state;
  final DateTime observedAt;
  final DateTime expiresAt;
  final String? referenceId;
  final List<String> reasonCodes;
  final bool serverVerified;
  final bool paymentMutationPerformed;

  factory PaymentOperationResult.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "ticketId",
      "scopeFingerprint",
      "environment",
      "payloadFingerprint",
      "state",
      "observedAt",
      "expiresAt",
      "referenceId",
      "reasonCodes",
      "serverVerified",
      "paymentMutationPerformed",
    });
    final value = PaymentOperationResult(
      ticketId: PaymentCodec.text(json, 'ticketId', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      payloadFingerprint: PaymentCodec.text(
        json,
        'payloadFingerprint',
        required: true,
      )!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      referenceId: PaymentCodec.text(json, 'referenceId'),
      reasonCodes:
          PaymentCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }, maximum: 100) ??
          [],
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      paymentMutationPerformed:
          PaymentCodec.boolean(json, 'paymentMutationPerformed') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentOperationResult> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentOperationResult.fromJson(PaymentCodec.object(input)),
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

  PaymentOperationResult copyWith({
    Set<String> clear = const {},
    String? ticketId,
    String? scopeFingerprint,
    String? environment,
    String? payloadFingerprint,
    String? state,
    DateTime? observedAt,
    DateTime? expiresAt,
    String? referenceId,
    List<String>? reasonCodes,
    bool? serverVerified,
    bool? paymentMutationPerformed,
  }) {
    final clearableFields = <String>{"referenceId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentOperationResult(
      ticketId: (ticketId ?? this.ticketId),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      payloadFingerprint: (payloadFingerprint ?? this.payloadFingerprint),
      state: (state ?? this.state),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      referenceId: clear.contains('referenceId')
          ? null
          : (referenceId ?? this.referenceId),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      serverVerified: (serverVerified ?? this.serverVerified),
      paymentMutationPerformed:
          (paymentMutationPerformed ?? this.paymentMutationPerformed),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (ticketId.trim().isEmpty || ticketId.length > 4000)
        validationIssues.add(
          const PaymentIssue('ticketId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (environment.trim().isEmpty || environment.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'environment',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (payloadFingerprint.trim().isEmpty || payloadFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'payloadFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const PaymentIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (referenceId != null) {
      if (referenceId!.trim().isEmpty || referenceId!.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'referenceId',
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
    if (!{'test', 'live'}.contains(environment) ||
        !expiresAt.isAfter(observedAt) ||
        !{
          'acceptedForReview',
          'rejected',
          'pending',
          'unknown',
        }.contains(state) ||
        paymentMutationPerformed)
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
    "ticketId": ticketId,
    "scopeFingerprint": scopeFingerprint,
    "environment": environment,
    "payloadFingerprint": payloadFingerprint,
    "state": state,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    if (referenceId != null) "referenceId": referenceId,
    "reasonCodes": reasonCodes,
    "serverVerified": serverVerified,
    "paymentMutationPerformed": paymentMutationPerformed,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentOperationResult &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentOperationResult(redacted)';
}
