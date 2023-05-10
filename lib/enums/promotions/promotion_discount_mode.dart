enum PromotionDiscountMode {
  staticMode('STATIC'),
  stepMode('STEP');

  const PromotionDiscountMode(this.promotionDiscountMode);

  final String promotionDiscountMode;

  static PromotionDiscountMode getPromotionDiscountModeFromString(String string) {
    if (string == 'STATIC') {
      return PromotionDiscountMode.staticMode;
    } else if (string == 'STEP') {
      return PromotionDiscountMode.stepMode;
    } else {
      return PromotionDiscountMode.staticMode;
    }
  }
}
