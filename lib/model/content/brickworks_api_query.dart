class BrickworksApiQuery {
  final String schemaSlug;
  final String? recordSlug;
  final String? recordId;
  Map<String, Object>? context;
  Map<String, Object>? fieldContext;

  BrickworksApiQuery._({
    required this.schemaSlug,
    this.recordSlug,
    this.recordId,
    this.context,
    this.fieldContext
  });

  factory BrickworksApiQuery.byRecordSlug({
    required String schemaSlug,
    required String recordSlug,
    Map<String, Object>? context,
    Map<String, Object>? fieldContext
  }) {
    return BrickworksApiQuery._(
      schemaSlug: schemaSlug,
      recordSlug: recordSlug,
      context: context,
      fieldContext: fieldContext
    );
  }

  factory BrickworksApiQuery.byRecordId({
    required String schemaSlug,
    required String recordId,
    Map<String, Object>? context,
    Map<String, Object>? fieldContext
  }) {
    return BrickworksApiQuery._(
      schemaSlug: schemaSlug,
      recordId: recordId,
      context: context,
      fieldContext: fieldContext
    );
  }

  /// `Map asMap()` is a method that returns a `Map` object containing the properties of the
  /// `BrickworksApiQuery` class as key-value pairs.
  Map asMap() => {
    'schemaSlug': schemaSlug,
    'recordSlug': recordSlug,
    'recordId': recordId,
    'context': context,
    'fieldContext': fieldContext
  };
}