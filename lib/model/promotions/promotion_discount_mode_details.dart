import '../../enums/promotions/promotion_discount_usage_trigger.dart';
import 'promotion_discount_step.dart';

/// The class `PromotionDiscountModeDetails` contains information about the discount steps and usage
/// trigger for a promotion.
class PromotionDiscountModeDetails {
  List<PromotionDiscountStep> discountSteps;
  PromotionDiscountUsageTrigger discountUsageTrigger;

  PromotionDiscountModeDetails({
    required this.discountSteps,
    required this.discountUsageTrigger,
  });

  /// `PromotionDiscountModeDetails.fromMap(Map map)` is a constructor that takes a `Map` as an argument
  /// and initializes a `PromotionDiscountModeDetails` object with the values from the `Map`.
  PromotionDiscountModeDetails.fromMap(Map map)
      : this(
            discountSteps: _convertObjectListToPromotionDiscountStep(map['discountSteps']),
            discountUsageTrigger: PromotionDiscountUsageTrigger.getPromotionDiscountUsageTriggerFromString(map['discountUsageTrigger']));

  /// The function returns a map with the values of 'discountSteps' and 'discountUsageTrigger'.
  Map asMap() => {'discountSteps': discountSteps, 'discountUsageTrigger': discountUsageTrigger};
}

/// This function converts a list of objects to a list of PromotionDiscountStep objects.
List<PromotionDiscountStep> _convertObjectListToPromotionDiscountStep(List<Object?> list) {
  List<PromotionDiscountStep> promotionDiscountStepList = [];
  for (var discountSteps in list) {
    discountSteps as Map<Object?, Object?>;
    PromotionDiscountStep promotionDiscountStep = PromotionDiscountStep.fromMap(discountSteps);
    promotionDiscountStepList.add(promotionDiscountStep);
  }
  return promotionDiscountStepList;
}
