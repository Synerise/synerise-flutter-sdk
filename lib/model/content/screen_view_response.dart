import '../../utils/synerise_utils.dart';
import 'screen_view_audience.dart';

class ScreenViewResponse {
  final ScreenViewAudience audience;
  
  final String identifier;
  final String hashString;
  final String name;
  final String path;
  final int priority;
  final String? descriptionText;
  
  final Map<String, Object> data;

  final String version;
  final String? parentVersion;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  ScreenViewResponse._(
      {required this.audience,
      required this.createdAt,
      required this.identifier,
      required this.hashString,
      required this.name,
      required this.path,
      required this.priority,
      required this.updatedAt,
      required this.version,
      required this.data,
      this.parentVersion,
      this.descriptionText,
      this.deletedAt});

  ScreenViewResponse.fromMap(Map map)
      : this._(
            audience: ScreenViewAudience.fromMap(map['audience']),
            createdAt: SyneriseUtils.formatIntToDateTime(map['createdAt']),
            identifier: map['identifier'],
            hashString: map['hashString'],
            name: map['name'],
            path: map['path'],
            priority: map['priority'],
            updatedAt: SyneriseUtils.formatIntToDateTime(map['updatedAt']),
            version: map['version'],
            data: Map<String, Object>.from(map['data']),
            parentVersion: map['parentVersion'],
            descriptionText: map['descriptionText'],
            deletedAt: map['deletedAt'] != null ? SyneriseUtils.formatIntToDateTime(map['deletedAt']) : null);

  Map asMap() => {
        'audience': audience,
        'createdAt': createdAt,
        'identifier': identifier,
        'hashString': hashString,
        'name': name,
        'path': path,
        'priority': priority,
        'updatedAt': updatedAt,
        'version': version,
        'data': data,
        'parentVersion': parentVersion,
        'descriptionText': descriptionText,
        'deletedAt': deletedAt
      };
}
