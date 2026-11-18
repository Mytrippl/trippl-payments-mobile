// Generated typed payment records. Edit tool/payment_models.json and regenerate.
import '../payment_codec.dart';
import '../payment_issue.dart';

class PaymentDisputeEvidenceReference {
  PaymentDisputeEvidenceReference({
    required this.id,
    required this.scopeFingerprint,
    required this.environment,
    required this.disputeId,
    required this.category,
    required this.fileReference,
    required this.mediaType,
    required this.byteCount,
    required this.checksum,
    required this.createdAt,
    this.uploaded = false,
  });

  final String id;
  final String scopeFingerprint;
  final String environment;
  final String disputeId;
  final String category;
  final String fileReference;
  final String mediaType;
  final int byteCount;
  final String checksum;
  final DateTime createdAt;
  final bool uploaded;

  factory PaymentDisputeEvidenceReference.fromJson(Map<String, Object?> json) {
    PaymentCodec.keys(json, {
      "id",
      "scopeFingerprint",
      "environment",
      "disputeId",
      "category",
      "fileReference",
      "mediaType",
      "byteCount",
      "checksum",
      "createdAt",
      "uploaded",
    });
    final value = PaymentDisputeEvidenceReference(
      id: PaymentCodec.text(json, 'id', required: true)!,
      scopeFingerprint: PaymentCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      environment: PaymentCodec.text(json, 'environment', required: true)!,
      disputeId: PaymentCodec.text(json, 'disputeId', required: true)!,
      category: PaymentCodec.text(json, 'category', required: true)!,
      fileReference: PaymentCodec.text(json, 'fileReference', required: true)!,
      mediaType: PaymentCodec.text(json, 'mediaType', required: true)!,
      byteCount: PaymentCodec.integer(
        json,
        'byteCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      checksum: PaymentCodec.text(json, 'checksum', required: true)!,
      createdAt: PaymentCodec.date(json, 'createdAt', required: true)!,
      uploaded: PaymentCodec.boolean(json, 'uploaded') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == PaymentSeverity.error))
      throw PaymentValidationException(issues);
    return value;
  }

  static PaymentResult<PaymentDisputeEvidenceReference> tryDecode(
    Object? input,
  ) {
    try {
      return PaymentResult(
        value: PaymentDisputeEvidenceReference.fromJson(
          PaymentCodec.object(input),
        ),
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

  PaymentDisputeEvidenceReference copyWith({
    Set<String> clear = const {},
    String? id,
    String? scopeFingerprint,
    String? environment,
    String? disputeId,
    String? category,
    String? fileReference,
    String? mediaType,
    int? byteCount,
    String? checksum,
    DateTime? createdAt,
    bool? uploaded,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return PaymentDisputeEvidenceReference(
      id: (id ?? this.id),
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      environment: (environment ?? this.environment),
      disputeId: (disputeId ?? this.disputeId),
      category: (category ?? this.category),
      fileReference: (fileReference ?? this.fileReference),
      mediaType: (mediaType ?? this.mediaType),
      byteCount: (byteCount ?? this.byteCount),
      checksum: (checksum ?? this.checksum),
      createdAt: (createdAt ?? this.createdAt),
      uploaded: (uploaded ?? this.uploaded),
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
      if (disputeId.trim().isEmpty || disputeId.length > 4000)
        validationIssues.add(
          const PaymentIssue('disputeId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (category.trim().isEmpty || category.length > 4000)
        validationIssues.add(
          const PaymentIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (fileReference.trim().isEmpty || fileReference.length > 4000)
        validationIssues.add(
          const PaymentIssue(
            'fileReference',
            'text',
            'Use nonempty bounded text',
          ),
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
    if (!{'test', 'live'}.contains(environment) ||
        byteCount < 1 ||
        byteCount > 10000000 ||
        !{'application/pdf', 'image/jpeg', 'image/png'}.contains(mediaType) ||
        !{'receipt', 'booking', 'correspondence', 'other'}.contains(category) ||
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
    "disputeId": disputeId,
    "category": category,
    "fileReference": fileReference,
    "mediaType": mediaType,
    "byteCount": byteCount,
    "checksum": checksum,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "uploaded": uploaded,
  };

  @override
  bool operator ==(Object other) =>
      other is PaymentDisputeEvidenceReference &&
      PaymentCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => PaymentCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'PaymentDisputeEvidenceReference(redacted)';
}
