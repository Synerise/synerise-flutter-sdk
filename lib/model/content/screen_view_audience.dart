/// The ScreenViewAudience class represents an audience for a screen view with a query and a list of
/// IDs.
class ScreenViewAudience {
  final String? query;
  final List<String>? ids;

  ScreenViewAudience._({
    this.query,
    this.ids,
  });

  /// `ScreenViewAudience.fromMap(Map map)` is a constructor that takes a `Map` as input and creates a
  /// new instance of `ScreenViewAudience` based on the values in the `Map`.
  ScreenViewAudience.fromMap(Map map)
      : this._(
          query: map['query'],
          ids: map['IDs'] != null ? List<String>.from(map['IDs']) : null,
        );

  /// The function returns a map with 'query' and 'IDs' keys and their corresponding values.
  Map asMap() => {
        'query': query,
        'IDs': ids,
      };
}
