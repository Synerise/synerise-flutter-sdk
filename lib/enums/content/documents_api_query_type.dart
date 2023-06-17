/// This code defines an enumeration called `DocumentsApiQueryType`.
/// The value is initialized with the string `'by-schema'`.
enum DocumentsApiQueryType {
  schema('by-schema');

  const DocumentsApiQueryType(this.documentApiQueryType);

  final String documentApiQueryType;

  /// This function returns the document API query type as a string.
  String? getDocumentsApiQueryTypeAsString() {
    return documentApiQueryType;
  }
}
