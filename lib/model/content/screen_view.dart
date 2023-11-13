import '../../utils/synerise_utils.dart';
import 'screen_view_audience_info.dart';

/// The ScreenView class represents a screen view with various properties such as identifier, name,
/// hashString, path, priority, audience information, data, createdAt and updatedAt timestamps.
class ScreenView {
  final String identifier;
  final String name;
  final String hashString;
  final String path;
  final int priority;

  final ScreenViewAudienceInfo? audience;
  final Map<String, Object>? data;

  final DateTime createdAt;
  final DateTime updatedAt;

  ScreenView._(
      {required this.identifier,
      required this.name,
      required this.hashString,
      required this.path,
      required this.priority,
      this.audience,
      this.data,
      required this.updatedAt,
      required this.createdAt});

  /// `ScreenView.fromMap(Map map)` is a named constructor that takes a `Map` as an argument and creates
  /// a new `ScreenView` object from the data in the map.
  ScreenView.fromMap(Map map)
      : this._(
          name: map['name'],
          identifier: map['identifier'],
          hashString: map['hashString'],
          path: map['path'],
          priority: map['priority'],
          audience: map['audience'] != null
              ? ScreenViewAudienceInfo.fromMap(map['audience'])
              : null,
          data: map['data'] != null
              ? Map<String, Object>.from(map['data'])
              : null,
          updatedAt: SyneriseUtils.formatIntToDateTime(map['updatedAt']),
          createdAt: SyneriseUtils.formatIntToDateTime(map['createdAt']),
        );
}
