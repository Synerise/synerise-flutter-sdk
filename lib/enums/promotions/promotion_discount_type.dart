/// This is defining an enumeration type called `PromotionDiscountType` with seven possible values:
/// `none`, `percent`, `amount`, `twoForOne`, `points`, `multibuy`, and `exactPrice`. Each value is
/// associated with a string literal that represents the value in a human-readable format. The
/// `getPromotionDiscountTypeFromString` method is used to convert a string to the corresponding
/// `PromotionDiscountType` value.
enum PromotionDiscountType {
  none('NONE'),
  percent('PERCENT'),
  amount('AMOUNT'),
  twoForOne('2_FOR_1'),
  points('POINTS'),
  multibuy('MULTIBUY'),
  exactPrice('EXACT_PRICE');

  const PromotionDiscountType(this.promotionDiscountType);

  final String promotionDiscountType;

  /// This function returns a PromotionDiscountType enum value based on a given string input.
  ///
  /// Args:
  ///   string (String): A string value representing a promotion discount type.
  ///
  /// Returns:
  ///   This method returns a value of the enum type `PromotionDiscountType`.
  static PromotionDiscountType getPromotionDiscountTypeFromString(String string) {
    if (string == 'NONE') {
      return PromotionDiscountType.none;
    } else if (string == 'PERCENT') {
      return PromotionDiscountType.percent;
    } else if (string == 'AMOUNT') {
      return PromotionDiscountType.amount;
    } else if (string == '2_FOR_1') {
      return PromotionDiscountType.twoForOne;
    } else if (string == 'POINTS') {
      return PromotionDiscountType.points;
    } else if (string == 'MULTIBUY') {
      return PromotionDiscountType.multibuy;
    } else if (string == 'EXACT_PRICE') {
      return PromotionDiscountType.exactPrice;
    } else {
      return PromotionDiscountType.none;
    }
  }
}
