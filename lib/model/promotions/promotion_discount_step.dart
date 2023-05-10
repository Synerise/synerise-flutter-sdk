class PromotionDiscountStep {
  int discountValue;
  int usageThreshold;

  PromotionDiscountStep({
    required this.discountValue,
    required this.usageThreshold,
  });

  PromotionDiscountStep.fromMap(Map map)
      : discountValue = map['discountValue'],
        usageThreshold = map['usageThreshold'];

  Map asMap() => {
        'discountValue': discountValue,
        'usageThreshold': usageThreshold,
      };
}
