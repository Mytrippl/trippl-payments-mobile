// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'currency_catalog.dart';
import 'intent.dart';
import 'method_reference.dart';
import 'receipt.dart';
import 'refund_reference.dart';

class PaymentReadPage {
  PaymentReadPage({
    required this.id,
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.environment,
    required this.observedAt,
    required this.expiresAt,
    List<PaymentIntent> intents = const [],
    List<PaymentMethodReference> methods = const [],
    List<PaymentRefundReference> refunds = const [],
    this.cursor,
    this.complete = false,
    this.serverVerified = false,
    List<PaymentReceipt> receipts = const [],
    this.currencyCatalog,
  }) : intents = List.unmodifiable(intents),
       methods = List.unmodifiable(methods),
       refunds = List.unmodifiable(refunds),
       receipts = List.unmodifiable(receipts);

  final String id;
  final String scopeFingerprint;
  final String requestFingerprint;
  final String environment;
  final DateTime observedAt;
  final DateTime expiresAt;
  final List<PaymentIntent> intents;
  final List<PaymentMethodReference> methods;
  final List<PaymentRefundReference> refunds;
  final String? cursor;
  final bool complete;
  final bool serverVerified;
  final List<PaymentReceipt> receipts;
  final PaymentCurrencyCatalog? currencyCatalog;

  factory PaymentReadPage.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "requestFingerprint",
      "environment",
      "observedAt",
      "expiresAt",
      "intents",
      "methods",
      "refunds",
      "cursor",
      "complete",
      "serverVerified",
      "receipts",
      "currencyCatalog",
    });
    final value = PaymentReadPage(
      id: PaymentCodec.text(json, 'id', required: true)!,
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
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      intents:
          PaymentCodec.list(
            json,
            'intents',
            (v) => PaymentIntent.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      methods:
          PaymentCodec.list(
            json,
            'methods',
            (v) => PaymentMethodReference.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      refunds:
          PaymentCodec.list(
            json,
            'refunds',
            (v) => PaymentRefundReference.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      cursor: PaymentCodec.text(json, 'cursor'),
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
      receipts:
          PaymentCodec.list(
            json,
            'receipts',
            (v) => PaymentReceipt.fromJson(PaymentCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      currencyCatalog: json['currencyCatalog'] == null
          ? null
          : PaymentCurrencyCatalog.fromJson(
              PaymentCodec.object(json['currencyCatalog']),
            ),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentReadPage> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadPage.fromJson(PaymentCodec.object(input)),
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

  PaymentReadPage copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? requestFingerprint,
    String? environment,
    DateTime? observedAt,
    DateTime? expiresAt,
    List<PaymentIntent>? intents,
    List<PaymentMethodReference>? methods,
    List<PaymentRefundReference>? refunds,
    String? cursor,
    bool? complete,
    bool? serverVerified,
    List<PaymentReceipt>? receipts,
    PaymentCurrencyCatalog? currencyCatalog,
  }) {
    final clearableFields = <String>{"cursor", "currencyCatalog"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadPage(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      environment: (environment ?? this.environment),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      intents: (intents ?? this.intents),
      methods: (methods ?? this.methods),
      refunds: (refunds ?? this.refunds),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
      complete: (complete ?? this.complete),
      serverVerified: (serverVerified ?? this.serverVerified),
      receipts: (receipts ?? this.receipts),
      currencyCatalog: clear.contains('currencyCatalog')
          ? null
          : (currencyCatalog ?? this.currencyCatalog),
    );
  }

  List<PaymentIssue> validate() {
    final validationIssues = <PaymentIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const PaymentIssue('id', 'text', 'Use nonempty bounded text'),
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
      if (intents.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'intents',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < intents.length; i++)
        for (final issue in intents[i].validate())
          validationIssues.add(
            PaymentIssue(
              'intents[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (methods.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'methods',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < methods.length; i++)
        for (final issue in methods[i].validate())
          validationIssues.add(
            PaymentIssue(
              'methods[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (refunds.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'refunds',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < refunds.length; i++)
        for (final issue in refunds[i].validate())
          validationIssues.add(
            PaymentIssue(
              'refunds[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const PaymentIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (receipts.length > 100)
        validationIssues.add(
          const PaymentIssue(
            'receipts',
            'count',
            'Payment list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < receipts.length; i++)
        for (final issue in receipts[i].validate())
          validationIssues.add(
            PaymentIssue(
              'receipts[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (currencyCatalog != null) {
      for (final issue in currencyCatalog!.validate())
        validationIssues.add(
          PaymentIssue(
            'currencyCatalog.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (!expiresAt.isAfter(observedAt) ||
        complete && cursor != null ||
        !{'test', 'live'}.contains(environment))
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
    "id": id,
    "scopeFingerprint": scopeFingerprint,
    "requestFingerprint": requestFingerprint,
    "environment": environment,
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "intents": intents.map((item) => item.toJson()).toList(),
    "methods": methods.map((item) => item.toJson()).toList(),
    "refunds": refunds.map((item) => item.toJson()).toList(),
    if (cursor != null) "cursor": cursor,
    "complete": complete,
    "serverVerified": serverVerified,
    "receipts": receipts.map((item) => item.toJson()).toList(),
    if (currencyCatalog != null) "currencyCatalog": currencyCatalog!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadPage && PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadPage(redacted)';
}
