import '../../enums/content/documents_api_query_type.dart';

/// The DocumentsApiQuery class represents a query for a document API with a type, type value, and
/// optional version.
class DocumentsApiQuery {
  DocumentsApiQueryType type;
  String typeValue;
  String? version;

  DocumentsApiQuery({
    required this.type,
    required this.typeValue,
    this.version,
  });

  /// This is a constructor that creates a new instance of the `DocumentsApiQuery` class from a `Map`
  /// object.
  DocumentsApiQuery.fromMap(Map map)
      : this(
            type: map['type'],
            typeValue: map['typeValue'],
            version: map['version']);

  /// The function returns a map with the type, type value, and version as key-value pairs.
  Map asMap() => {
        'type': type.getDocumentsApiQueryTypeAsString(),
        'typeValue': typeValue,
        'version': version
      };
}
