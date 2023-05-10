enum PromotionDiscountUsageTrigger {
  transaction('TRANSACTION'),
  redeem('REDEEM');

  const PromotionDiscountUsageTrigger(this.promotionDiscountUsageTrigger);

  final String promotionDiscountUsageTrigger;

  static PromotionDiscountUsageTrigger getPromotionDiscountUsageTriggerFromString(String string) {
    if (string == 'TRANSACTION') {
      return PromotionDiscountUsageTrigger.transaction;
    } else if (string == 'REDEEM') {
      return PromotionDiscountUsageTrigger.redeem;
    } else {
      return PromotionDiscountUsageTrigger.transaction;
    }
  }

  String promotionDiscountUsageTriggerAsString() {
    return promotionDiscountUsageTrigger;
  }
}
