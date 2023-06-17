import '../../enums/promotions/promotion_image_type.dart';

/// The PromotionImage class represents an image used for promotions and includes a URL and type.
class PromotionImage {
  String url;
  PromotionImageType type;

  PromotionImage({
    required this.url,
    required this.type,
  });

  /// `PromotionImage.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// initializes a `PromotionImage` object with the values from the map.
  PromotionImage.fromMap(Map map)
      : url = map['url'],
        type = PromotionImageType.getPromotionImageTypeFromString(map['type']);

  /// The function returns a map with the URL and type of a promotion image.
  Map asMap() => {
        'url': url,
        'type': type.promotionImageTypeAsString(),
      };
}
