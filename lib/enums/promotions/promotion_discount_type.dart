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
