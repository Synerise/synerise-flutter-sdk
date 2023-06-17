/// This is a enum that defines four possible values for a promotion image type: "image",
/// "thumbnail", "large", and "UNKNOWN". Each value is assigned a string representation and a
/// constructor that takes a string argument. The enum also includes a static method
/// `getPromotionImageTypeFromString` that takes a string argument and returns the corresponding enum
/// value, or "UNKNOWN" if the string does not match any of the defined values. Finally, the enum
/// includes a method `promotionImageTypeAsString` that returns the string representation of the enum
/// value.
enum PromotionImageType {
  image('image'),
  thumbnail('thumbnail'),
  large('large'),
  unknown('UNKNOWN');

  const PromotionImageType(this.promotionImageType);

  final String promotionImageType;

  /// This function returns a PromotionImageType enum value based on a given string input.
  ///
  /// Args:
  ///   string (String): A string that represents the promotion image type.
  ///
  /// Returns:
  ///   The method is returning a value of the enum type `PromotionImageType`.
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

  /// This function returns a string representation of a promotion image type.
  ///
  /// Returns:
  ///   The method is returning the value of the variable `promotionImageType` as a string.
  String promotionImageTypeAsString() {
    return promotionImageType;
  }
}
