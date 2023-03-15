import 'recommendation.dart';

class RecommendationResponse {
  final String campaignHash;
  final String campaignId;
  final String schema;
  final String slug;
  final String uuid;

  final List<Recommendation> items;

  RecommendationResponse({
    required this.campaignHash,
    required this.campaignId,
    required this.schema,
    required this.slug,
    required this.uuid,
    required this.items,
  });

  RecommendationResponse.fromMap(Map map)
      : this(
          campaignHash: map['type'],
          campaignId: map['type'],
          schema: map['type'],
          slug: map['type'],
          uuid: map['type'],
          items: map['type'],
        );
}
