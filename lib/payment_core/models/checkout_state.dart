// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'allocation.dart';
import 'attempt.dart';
import 'error.dart';
import 'verification.dart';

class PaymentCheckoutState {
  PaymentCheckoutState({
    required this.scopeFingerprint,
    required this.orderId,
    required this.updatedAt,
    required this.state,
    this.attempt,
    this.allocation,
    this.verification,
    this.error,
    this.busy = false,
    this.revision = 1,
  });

  final String scopeFingerprint;
  final String orderId;
  final DateTime updatedAt;
  final String state;
  final PaymentAttempt? attempt;
  final PaymentAllocation? allocation;
  final PaymentVerification? verification;
  final PaymentError? error;
  final bool busy;
  final int revision;

  factory PaymentCheckoutState.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "orderId",
      "updatedAt",
      "state",
      "attempt",
      "allocation",
      "verification",
      "error",
      "busy",
      "revision",
    });
    final value = PaymentCheckoutState(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      orderId: PaymentCodec.text(json, 'orderId', required: true)!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      attempt: json['attempt'] == null
          ? null
          : PaymentAttempt.fromJson(PaymentCodec.object(json['attempt'])),
      allocation: json['allocation'] == null
          ? null
          : PaymentAllocation.fromJson(PaymentCodec.object(json['allocation'])),
      verification: json['verification'] == null
          ? null
          : PaymentVerification.fromJson(
              PaymentCodec.object(json['verification']),
            ),
      error: json['error'] == null
          ? null
          : PaymentError.fromJson(PaymentCodec.object(json['error'])),
      busy: PaymentCodec.boolean(json, 'busy') ?? false,
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

  static PaymentResult<PaymentCheckoutState> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentCheckoutState.fromJson(PaymentCodec.object(input)),
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

  PaymentCheckoutState copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? orderId,
    DateTime? updatedAt,
    String? state,
    PaymentAttempt? attempt,
    PaymentAllocation? allocation,
    PaymentVerification? verification,
    PaymentError? error,
    bool? busy,
    int? revision,
  }) {
    final clearableFields = <String>{
      "attempt",
      "allocation",
      "verification",
      "error",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentCheckoutState(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      orderId: (orderId ?? this.orderId),
      updatedAt: (updatedAt ?? this.updatedAt),
      state: (state ?? this.state),
      attempt: clear.contains('attempt') ? null : (attempt ?? this.attempt),
      allocation: clear.contains('allocation')
          ? null
          : (allocation ?? this.allocation),
      verification: clear.contains('verification')
          ? null
          : (verification ?? this.verification),
      error: clear.contains('error') ? null : (error ?? this.error),
      busy: (busy ?? this.busy),
      revision: (revision ?? this.revision),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
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
    if (attempt != null) {
      for (final issue in attempt!.validate())
        validationIssues.add(
          PaymentIssue(
            'attempt.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (allocation != null) {
      for (final issue in allocation!.validate())
        validationIssues.add(
          PaymentIssue(
            'allocation.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (verification != null) {
      for (final issue in verification!.validate())
        validationIssues.add(
          PaymentIssue(
            'verification.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (error != null) {
      for (final issue in error!.validate())
        validationIssues.add(
          PaymentIssue(
            'error.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
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
        !{
          'idle',
          'preparing',
          'ready',
          'presenting',
          'verifying',
          'paid',
          'pending',
          'authorized',
          'cancelled',
          'failed',
          'uncertain',
        }.contains(state))
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
    "scopeFingerprint": scopeFingerprint,
    "orderId": orderId,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "state": state,
    if (attempt != null) "attempt": attempt!.toJson(),
    if (allocation != null) "allocation": allocation!.toJson(),
    if (verification != null) "verification": verification!.toJson(),
    if (error != null) "error": error!.toJson(),
    "busy": busy,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentCheckoutState &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentCheckoutState(redacted)';
}
