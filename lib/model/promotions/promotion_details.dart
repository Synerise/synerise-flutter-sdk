import 'promotion_discount_type_details.dart';

/// The `PromotionDetails` class represents details of a promotion, including the discount type, and
/// provides methods for converting to and from a `Map`.
class PromotionDetails {
  PromotionDiscountTypeDetails? discountType;

  PromotionDetails({this.discountType});

  /// `PromotionDetails.fromMap(Map map)` is a constructor that takes a `Map` as input and creates a new
  /// `PromotionDetails` object from it.
  PromotionDetails.fromMap(Map map)
      : discountType = map['discountType'] != null ? PromotionDiscountTypeDetails.fromMap(map['discountType']) : null;

  /// The function returns a map with the value of 'discountType' converted to a map using the 'asMap'
  /// function.
  Map asMap() => {
        'discountType': discountType?.asMap(),
      };
}
