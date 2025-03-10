/// The `Document` class represents a document with an identifier, slug, schema, and optional content
/// stored as a map.
class Document {
  final String uuid;
  final String slug;
  final String schema;
  final Map<String, Object>? content;

  Document._({
    required this.uuid,
    required this.slug,
    required this.schema,
    this.content,
  });

  /// `Document.fromMap(Map map)` is a constructor that takes a `Map` as an argument and creates a new
  /// `Document` object from it.
  Document.fromMap(Map map)
      : this._(
          uuid: map['uuid'],
          slug: map['slug'],
          schema: map['schema'],
          content: map['content'] != null
              ? Map<String, Object>.from(map['content'])
              : null,
        );

  /// The function returns a map containing the identifier, slug, schema, and content properties.
  Map asMap() => {
        'uuid': uuid,
        'slug': slug,
        'schema': schema,
        'content': content,
      };
}
