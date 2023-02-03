import 'recommendation.dart';

class ScreenViewResponse {
  final String? campaignHash;
  final String? campaignId;
  final String? schema;
  final String? slug;
  final String? uuid;
  final List<Recommendation>? items;

  ScreenViewResponse({
    this.campaignHash,
    this.campaignId,
    this.schema,
    this.slug,
    this.uuid,
    this.items,
  });

  ScreenViewResponse.fromMap(Map map)
      : this(
          campaignHash: map['campaignHash'],
          campaignId: map['campaignId'],
          schema: map['schema'],
          slug: map['slug'],
          uuid: map['uuid'],
          items: map['items'],
        );

  Map asMap() => {
        'campaignHash': campaignHash,
        'campaignId': campaignId,
        'schema': schema,
        'slug': slug,
        'uuid': uuid,
        'items': items,
      };
}
