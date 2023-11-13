/// The ScreenViewAudienceInfo class represents information about the audience of a screen view,
/// including segments, query, and target type.
class ScreenViewAudienceInfo {
  final List<String>? segments;
  final String? query;
  final String? targetType;

  ScreenViewAudienceInfo._({this.segments, this.query, this.targetType});

  /// `ScreenViewAudienceInfo.fromMap(Map map)` is a constructor that takes a `Map` as input and creates a
  /// new instance of `ScreenViewAudienceInfo` based on the values in the `Map`.
  ScreenViewAudienceInfo.fromMap(Map map)
      : this._(
            segments: map['segments'] != null
                ? List<String>.from(map['segments'])
                : null,
            query: map['query'],
            targetType: map['targetType']);
}
