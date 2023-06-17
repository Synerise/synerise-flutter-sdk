import 'recommendation.dart';

/// The code defines a Dart class for a recommendation response and includes a function to convert a
/// list of objects to a list of recommendations.
class RecommendationResponse {
  final String name;
  final String campaignHash;
  final String campaignID;
  final String correlationID;
  final String schema;
  final String slug;
  final String uuid;

  final List<Recommendation> items;

  RecommendationResponse._(
      {required this.name,
      required this.campaignHash,
      required this.campaignID,
      required this.correlationID,
      required this.schema,
      required this.slug,
      required this.uuid,
      required this.items});

  /// This is a named constructor in the `RecommendationResponse` class that takes a `Map` as input and
  /// initializes the properties of a `RecommendationResponse` object.
  RecommendationResponse.fromMap(Map map)
      : this._(
          name: map['name'],
          campaignHash: map['campaignHash'],
          campaignID: map['campaignID'],
          correlationID: map['correlationID'],
          schema: map['schema'],
          slug: map['slug'],
          uuid: map['uuid'],
          items: _convertObjectListToRecoList(map['items']),
        );
}

/// This function converts a list of objects to a list of Recommendation objects.
List<Recommendation> _convertObjectListToRecoList(List<Object?> list) {
  List<Recommendation> recommendationList = [];
  for (var recoObject in list) {
    recoObject as Map<Object?, Object?>;
    Recommendation recommendation = Recommendation.fromMap(recoObject);
    recommendationList.add(recommendation);
  }
  return recommendationList;
}
