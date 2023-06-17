/// The `PromotionDiscountStep` class represents a step in a promotion that includes a discount value
/// and a usage threshold.
class PromotionDiscountStep {
  int discountValue;
  int usageThreshold;

  PromotionDiscountStep({
    required this.discountValue,
    required this.usageThreshold,
  });

  /// `PromotionDiscountStep.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// initializes a new `PromotionDiscountStep` object with the values from the map.
  PromotionDiscountStep.fromMap(Map map)
      : discountValue = map['discountValue'],
        usageThreshold = map['usageThreshold'];

  /// The function returns a map with the values of discountValue and usageThreshold.
  Map asMap() => {
        'discountValue': discountValue,
        'usageThreshold': usageThreshold,
      };
}
