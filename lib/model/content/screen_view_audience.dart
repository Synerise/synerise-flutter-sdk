class ScreenViewAudience {
  final String? query;
  final List<String>? ids;

  ScreenViewAudience._({
    this.query,
    this.ids,
  });

  ScreenViewAudience.fromMap(Map map)
      : this._(
          query: map['query'],
          ids: map['IDs'],
        );

  Map asMap() => {
        'query': query,
        'IDs': ids,
      };
}
