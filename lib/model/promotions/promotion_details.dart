import 'promotion_discount_type_details.dart';

class PromotionDetails {
  PromotionDiscountTypeDetails? discountType;

  PromotionDetails({this.discountType});

  PromotionDetails.fromMap(Map map)
      : discountType = map['discountType'] != null ? PromotionDiscountTypeDetails.fromMap(map['discountType']) : null;

  Map asMap() => {
        'discountType': discountType?.asMap(),
      };
}
