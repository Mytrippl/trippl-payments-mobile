// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentInvoiceDocument {
  PaymentInvoiceDocument({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.invoiceId,
    required this.uri,
    required this.mediaType,
    required this.byteCount,
    required this.checksum,
    required this.issuedAt,
    required this.observedAt,
    required this.expiresAt,
    this.serverVerified = false,
    this.revision = 1,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String invoiceId;
  final String uri;
  final String mediaType;
  final int byteCount;
  final String checksum;
  final DateTime issuedAt;
  final DateTime observedAt;
  final DateTime expiresAt;
  final bool serverVerified;
  final int revision;

  factory PaymentInvoiceDocument.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "invoiceId",
      "uri",
      "mediaType",
      "byteCount",
      "checksum",
      "issuedAt",
      "observedAt",
      "expiresAt",
      "serverVerified",
      "revision",
    });
    final value = PaymentInvoiceDocument(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      invoiceId: PaymentCodec.text(json, 'invoiceId', required: true)!,
      uri: PaymentCodec.text(json, 'uri', required: true)!,
      mediaType: PaymentCodec.text(json, 'mediaType', required: true)!,
      byteCount: PaymentCodec.integer(
        json,
        'byteCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      checksum: PaymentCodec.text(json, 'checksum', required: true)!,
      issuedAt: PaymentCodec.date(json, 'issuedAt', required: true)!,
      observedAt: PaymentCodec.date(json, 'observedAt', required: true)!,
      expiresAt: PaymentCodec.date(json, 'expiresAt', required: true)!,
      serverVerified: PaymentCodec.boolean(json, 'serverVerified') ?? false,
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

  static PaymentResult<PaymentInvoiceDocument> tryDecode(Object? input) {
    try {
      return PaymentResult(
        value: PaymentInvoiceDocument.fromJson(PaymentCodec.object(input)),
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

  PaymentInvoiceDocument copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? invoiceId,
    String? uri,
    String? mediaType,
    int? byteCount,
    String? checksum,
    DateTime? issuedAt,
    DateTime? observedAt,
    DateTime? expiresAt,
    bool? serverVerified,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentInvoiceDocument(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      invoiceId: (invoiceId ?? this.invoiceId),
      uri: (uri ?? this.uri),
      mediaType: (mediaType ?? this.mediaType),
      byteCount: (byteCount ?? this.byteCount),
      checksum: (checksum ?? this.checksum),
      issuedAt: (issuedAt ?? this.issuedAt),
      observedAt: (observedAt ?? this.observedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      serverVerified: (serverVerified ?? this.serverVerified),
      revision: (revision ?? this.revision),
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
      if (invoiceId.trim().isEmpty || invoiceId.length > 4000)
        validationIssues.add(
          const PaymentIssue('invoiceId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (uri.trim().isEmpty || uri.length > 4000)
        validationIssues.add(
          const PaymentIssue('uri', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (mediaType.trim().isEmpty || mediaType.length > 4000)
        validationIssues.add(
          const PaymentIssue('mediaType', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (byteCount < 0 || byteCount > 9000000000000)
        validationIssues.add(
          const PaymentIssue(
            'byteCount',
            'range',
            'Number is outside the payment limits',
          ),
        );
    }
    {
      if (checksum.trim().isEmpty || checksum.length > 4000)
        validationIssues.add(
          const PaymentIssue('checksum', 'text', 'Use nonempty bounded text'),
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
        !{'test', 'live'}.contains(environment) ||
        mediaType != 'application/pdf' ||
        byteCount < 1 ||
        byteCount > 20000000 ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(checksum))
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
    "environment": environment,
    "invoiceId": invoiceId,
    "uri": uri,
    "mediaType": mediaType,
    "byteCount": byteCount,
    "checksum": checksum,
    "issuedAt": issuedAt.toUtc().toIso8601String(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "serverVerified": serverVerified,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentInvoiceDocument &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentInvoiceDocument(redacted)';
}
