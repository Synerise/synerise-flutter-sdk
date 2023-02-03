import 'package:synerise_flutter_sdk/enums/content/documents_api_query_type.dart';

class DocumentsApiQuery {
  final DocumentsApiQueryType? type;
  final String typeValue;
  final String? version;

  DocumentsApiQuery({
    this.type,
    required this.typeValue,
    this.version,
  });

  DocumentsApiQuery.fromMap(Map map) : this(type: map['type'], typeValue: map['typeValue'], version: map['version']);

  Map asMap() => {'type': type, 'typeValue': typeValue, 'version': version};
}
