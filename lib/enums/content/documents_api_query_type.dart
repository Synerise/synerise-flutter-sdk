enum DocumentsApiQueryType {
  schema('by-schema');

  const DocumentsApiQueryType(this.documentApiQueryType);

  final String documentApiQueryType;

  String? getDocumentsApiQueryType() {
    return documentApiQueryType;
  }
}
