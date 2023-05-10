import '../../enums/promotions/promotion_discount_usage_trigger.dart';
import 'promotion_discount_step.dart';

class PromotionDiscountModeDetails {
  List<PromotionDiscountStep> discountSteps;
  PromotionDiscountUsageTrigger discountUsageTrigger;

  PromotionDiscountModeDetails({
    required this.discountSteps,
    required this.discountUsageTrigger,
  });

  PromotionDiscountModeDetails.fromMap(Map map)
      : this(
            discountSteps: _convertObjectListToPromotionDiscountStep(map['discountSteps']),
            discountUsageTrigger: PromotionDiscountUsageTrigger.getPromotionDiscountUsageTriggerFromString(map['discountUsageTrigger']));

  Map asMap() => {'discountSteps': discountSteps, 'discountUsageTrigger': discountUsageTrigger};
}

List<PromotionDiscountStep> _convertObjectListToPromotionDiscountStep(List<Object?> list) {
  List<PromotionDiscountStep> promotionDiscountStepList = [];
  for (var discountSteps in list) {
    discountSteps as Map<Object?, Object?>;
    PromotionDiscountStep promotionDiscountStep = PromotionDiscountStep.fromMap(discountSteps);
    promotionDiscountStepList.add(promotionDiscountStep);
  }
  return promotionDiscountStepList;
}
