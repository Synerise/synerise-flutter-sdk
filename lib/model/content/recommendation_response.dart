import 'recommendation.dart';

class RecommendationResponse {
  final String campaignHash;
  final String campaignID;
  final String schema;
  final String slug;
  final String uuid;
  final String name;

  final List<Recommendation> items;

  RecommendationResponse._(
      {required this.campaignHash,
      required this.campaignID,
      required this.schema,
      required this.slug,
      required this.uuid,
      required this.items,
      required this.name});

  RecommendationResponse.fromMap(Map map)
      : this._(
            campaignHash: map['campaignHash'],
            campaignID: map['campaignID'],
            schema: map['schema'],
            slug: map['slug'],
            uuid: map['uuid'],
            items: _convertObjectListToRecoList(map['items']),
            name: map['name']);

  Map asMap() =>
      {'campaignHash': campaignHash, 'campaignID': campaignID, 'schema': schema, 'slug': slug, 'uuid': uuid, 'items': items, 'name': name};
}

List<Recommendation> _convertObjectListToRecoList(List<Object?> list) {
  List<Recommendation> recommendationList = [];
  for (var recoObject in list) {
    recoObject as Map<Object?, Object?>;
    Recommendation recommendation = Recommendation.fromMap(recoObject);
    recommendationList.add(recommendation);
  }
  return recommendationList;
}
