enum PromotionImageType {
  image('image'),
  thumbnail('thumbnail'),
  large('large'),
  unknown('UNKNOWN');

  const PromotionImageType(this.promotionImageType);

  final String promotionImageType;

  static PromotionImageType getPromotionImageTypeFromString(String string) {
    if (string == PromotionImageType.image.promotionImageType) {
      return PromotionImageType.image;
    } else if (string == PromotionImageType.thumbnail.promotionImageType) {
      return PromotionImageType.thumbnail;
    } else if (string == PromotionImageType.large.promotionImageType) {
      return PromotionImageType.large;
    } else if (string == PromotionImageType.unknown.promotionImageType) {
      return PromotionImageType.unknown;
    } else {
      return PromotionImageType.unknown;
    }
  }

  String promotionImageTypeAsString() {
    return promotionImageType;
  }
}
