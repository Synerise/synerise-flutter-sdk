import '../../enums/content/documents_api_query_type.dart';

class DocumentsApiQuery {
  DocumentsApiQueryType type;
  String typeValue;
  String? version;

  DocumentsApiQuery({
    required this.type,
    required this.typeValue,
    this.version,
  });

  DocumentsApiQuery.fromMap(Map map) : this(type: map['type'], typeValue: map['typeValue'], version: map['version']);

  Map asMap() => {'type': type.getDocumentsApiQueryTypeAsString(), 'typeValue': typeValue, 'version': version};
}
