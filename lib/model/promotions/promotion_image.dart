import '../../enums/promotions/promotion_image_type.dart';

class PromotionImage {
  String url;
  PromotionImageType type;

  PromotionImage({
    required this.url,
    required this.type,
  });

  PromotionImage.fromMap(Map map)
      : url = map['url'],
        type = PromotionImageType.getPromotionImageTypeFromString(map['type']);

  Map asMap() => {
        'url': url,
        'type': type.promotionImageTypeAsString(),
      };
}
