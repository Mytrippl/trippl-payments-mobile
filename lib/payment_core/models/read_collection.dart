// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';
import 'currency_catalog.dart';
import 'intent.dart';
import 'method_reference.dart';
import 'receipt.dart';
import 'refund_reference.dart';

class PaymentReadCollection {
  PaymentReadCollection({
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.mode,
    required this.environment,
    required this.collectedAt,
    required this.expiresAt,
    List<PaymentIntent> intents = const [],
    List<PaymentMethodReference> methods = const [],
    List<PaymentReceipt> receipts = const [],
    List<PaymentRefundReference> refunds = const [],
    this.currencyCatalog,
    this.pages = 1,
    this.complete = false,
    List<String> reasonCodes = const [],
  }) : intents = List.unmodifiable(intents),
       methods = List.unmodifiable(methods),
       receipts = List.unmodifiable(receipts),
       refunds = List.unmodifiable(refunds),
       reasonCodes = List.unmodifiable(reasonCodes);

  final String scopeFingerprint;
  final String requestFingerprint;
  final String mode;
  final String environment;
  final DateTime collectedAt;
  final DateTime expiresAt;
  final List<PaymentIntent> intents;
  final List<PaymentMethodReference> methods;
  final List<PaymentReceipt> receipts;
  final List<PaymentRefundReference> refunds;
  final PaymentCurrencyCatalog? currencyCatalog;
  final int pages;
  final bool complete;
  final List<String> reasonCodes;

  factory PaymentReadCollection.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "scopeFingerprint",
      "requestFingerprint",
      "mode",
      "environment",
      "collectedAt",
      "expiresAt",
      "intents",
      "methods",
      "receipts",
      "refunds",
      "currencyCatalog",
      "pages",
      "complete",
      "reasonCodes",
    });
    final value = PaymentReadCollection(
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
      mode: PaymentCodec.text(json, 'mode', required: true)!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      collectedAt: PaymentCodec.date(json, 'collectedAt', required: true)!,
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
      receipts:
          PaymentCodec.list(
            json,
            'receipts',
            (v) => PaymentReceipt.fromJson(PaymentCodec.object(v)),
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
      currencyCatalog: json['currencyCatalog'] == null
          ? null
          : PaymentCurrencyCatalog.fromJson(
              PaymentCodec.object(json['currencyCatalog']),
            ),
      pages:
          PaymentCodec.integer(
            json,
            'pages',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      complete: PaymentCodec.boolean(json, 'complete') ?? false,
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

  static PaymentResult<PaymentReadCollection> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentReadCollection.fromJson(PaymentCodec.object(input)),
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

  PaymentReadCollection copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? requestFingerprint,
    String? mode,
    String? environment,
    DateTime? collectedAt,
    DateTime? expiresAt,
    List<PaymentIntent>? intents,
    List<PaymentMethodReference>? methods,
    List<PaymentReceipt>? receipts,
    List<PaymentRefundReference>? refunds,
    PaymentCurrencyCatalog? currencyCatalog,
    int? pages,
    bool? complete,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{"currencyCatalog"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentReadCollection(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      mode: (mode ?? this.mode),
      environment: (environment ?? this.environment),
      collectedAt: (collectedAt ?? this.collectedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      intents: (intents ?? this.intents),
      methods: (methods ?? this.methods),
      receipts: (receipts ?? this.receipts),
      refunds: (refunds ?? this.refunds),
      currencyCatalog: clear.contains('currencyCatalog')
          ? null
          : (currencyCatalog ?? this.currencyCatalog),
      pages: (pages ?? this.pages),
      complete: (complete ?? this.complete),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
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
      if (mode.trim().isEmpty || mode.length > 4000)
        validationIssues.add(
          const PaymentIssue('mode', 'text', 'Use nonempty bounded text'),
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
    {
      if (pages < 0 || pages > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'pages',
            'range',
            'Number is outside the payment limits',
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
    if (pages < 1 ||
        pages > 20 ||
        !expiresAt.isAfter(collectedAt) ||
        !{
          'intent',
          'methods',
          'receipt',
          'refunds',
          'currencies',
        }.contains(mode) ||
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
    "scopeFingerprint": scopeFingerprint,
    "requestFingerprint": requestFingerprint,
    "mode": mode,
    "environment": environment,
    "collectedAt": collectedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "intents": intents.map((item) => item.toJson()).toList(),
    "methods": methods.map((item) => item.toJson()).toList(),
    "receipts": receipts.map((item) => item.toJson()).toList(),
    "refunds": refunds.map((item) => item.toJson()).toList(),
    if (currencyCatalog != null) "currencyCatalog": currencyCatalog!.toJson(),
    "pages": pages,
    "complete": complete,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentReadCollection &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentReadCollection(redacted)';
}
