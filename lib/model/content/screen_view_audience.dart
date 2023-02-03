class ScreenViewAudience {
  final String? query;
  final List<String>? ids;

  ScreenViewAudience({
    this.query,
    this.ids,
  });

  ScreenViewAudience.fromMap(Map map)
      : this(
          query: map['query'],
          ids: map['IDs'],
        );

  Map asMap() => {
        'query': query,
        'IDs': ids,
      };
}
