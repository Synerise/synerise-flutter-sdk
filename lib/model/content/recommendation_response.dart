import 'dart:ffi';

import 'package:synerise_flutter_sdk/model/content/screen_view_audience.dart';

class RecommendationResponse {
  final ScreenViewAudience? audience;
  final String? identifier;
  final String? hashString;
  final String? path;
  final String? name;
  final Double? priority;
  final String? descriptionText;
  final dynamic data;
  final String? version;
  final String? parentVersion;
  final Double? createdAt;
  final Double? updatedAt;
  final Double? deletedAt;

  RecommendationResponse({
    this.audience,
    this.identifier,
    this.hashString,
    this.path,
    this.name,
    this.priority,
    this.descriptionText,
    this.data,
    this.version,
    this.parentVersion,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  RecommendationResponse.fromMap(Map map)
      : this(
          audience: map['audience'],
          identifier: map['identifier'],
          hashString: map['hashString'],
          path: map['path'],
          name: map['name'],
          priority: map['priority'],
          descriptionText: map['descriptionText'],
          data: map['data'],
          version: map['version'],
          parentVersion: map['parentVersion'],
          createdAt: map['createdAt'],
          updatedAt: map['updatedAt'],
          deletedAt: map['deletedAt'],
        );

  Map asMap() => {
        'audience': audience,
        'identifier': identifier,
        'hashString': hashString,
        'path': path,
        'name': name,
        'priority': priority,
        'descriptionText': descriptionText,
        'data': data,
        'version': version,
        'parentVersion': parentVersion,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt
      };
}
