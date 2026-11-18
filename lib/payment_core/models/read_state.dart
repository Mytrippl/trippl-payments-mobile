// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'read_failure.dart';
import 'read_page.dart';

class PaymentReadState {
  PaymentReadState({
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.updatedAt,
    required this.state,
    this.page,
    this.failure,
    this.generation = 1,
    this.attempt = 1,
  });

  final String scopeFingerprint;
  final String requestFingerprint;
  final DateTime updatedAt;
  final String state;
  final PaymentReadPage? page;
  final PaymentReadFailure? failure;
  final int generation;
  final int attempt;

  factory PaymentReadState.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "requestFingerprint",
      "updatedAt",
      "state",
      "page",
      "failure",
      "generation",
      "attempt",
    });
    final value = PaymentReadState(
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      requestFingerprint: PaymentCodec.text(
        json,
        'requestFingerprint',
        required: true,
      )!,
      updatedAt: PaymentCodec.date(json, 'updatedAt', required: true)!,
      state: PaymentCodec.text(json, 'state', required: true)!,
      page: json['page'] == null
          ? null
          : PaymentReadPage.fromJson(PaymentCodec.object(json['page'])),
      failure: json['failure'] == null
          ? null
          : PaymentReadFailure.fromJson(PaymentCodec.object(json['failure'])),
      generation:
          PaymentCodec.integer(
            json,
            'generation',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      attempt:
          PaymentCodec.integer(
            json,
            'attempt',
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

  static PaymentResult<PaymentReadState> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadState.fromJson(PaymentCodec.object(input)),
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

  PaymentReadState copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? requestFingerprint,
    DateTime? updatedAt,
    String? state,
    PaymentReadPage? page,
    PaymentReadFailure? failure,
    int? generation,
    int? attempt,
  }) {
    final clearableFields = <String>{"page", "failure"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadState(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      updatedAt: (updatedAt ?? this.updatedAt),
      state: (state ?? this.state),
      page: clear.contains('page') ? null : (page ?? this.page),
      failure: clear.contains('failure') ? null : (failure ?? this.failure),
      generation: (generation ?? this.generation),
      attempt: (attempt ?? this.attempt),
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
      if (requestFingerprint.trim().isEmpty || requestFingerprint.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'requestFingerprint',
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
    if (page != null) {
      for (final issue in page!.validate())
        validationIssues.add(
          PaymentIssue(
            'page.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (failure != null) {
      for (final issue in failure!.validate())
        validationIssues.add(
          PaymentIssue(
            'failure.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (generation < 0 || generation > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'generation',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (attempt < 0 || attempt > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'attempt',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    if (generation < 1 ||
        attempt < 1 ||
        attempt > 3 ||
        !{'loading', 'ready', 'failed', 'cancelled'}.contains(state) ||
        state == 'ready' && page == null ||
        state == 'failed' && failure == null)
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
    "requestFingerprint": requestFingerprint,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "state": state,
    if (page != null) "page": page!.toJson(),
    if (failure != null) "failure": failure!.toJson(),
    "generation": generation,
    "attempt": attempt,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadState && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadState(redacted)';
}
