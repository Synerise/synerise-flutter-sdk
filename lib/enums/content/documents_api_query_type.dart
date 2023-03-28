enum DocumentsApiQueryType {
  schema('by-schema');

  const DocumentsApiQueryType(this.documentApiQueryType);

  final String documentApiQueryType;

  String? getDocumentsApiQueryTypeAsString() {
    return documentApiQueryType;
  }
}
