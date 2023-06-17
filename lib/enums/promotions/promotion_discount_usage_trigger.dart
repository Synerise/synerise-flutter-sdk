/// This is defining an enum called `PromotionDiscountUsageTrigger` with two possible
/// values: `transaction` and `redeem`. Each value is associated with a string value (`'TRANSACTION'`
/// and `'REDEEM'` respectively). The enum also has a constructor that takes a string parameter and a
/// method `getPromotionDiscountUsageTriggerFromString` that returns the corresponding enum value based
/// on a given string input. There is also a method `promotionDiscountUsageTriggerAsString` that returns
/// the string value associated with the enum value.
enum PromotionDiscountUsageTrigger {
  transaction('TRANSACTION'),
  redeem('REDEEM');

  const PromotionDiscountUsageTrigger(this.promotionDiscountUsageTrigger);

  final String promotionDiscountUsageTrigger;

  /// The function returns a PromotionDiscountUsageTrigger enum value based on a given string input.
  ///
  /// Args:
  ///   string (String): A string value that represents a promotion discount usage trigger.
  ///
  /// Returns:
  ///   The method is returning a value of the enum type `PromotionDiscountUsageTrigger`. The value
  /// returned depends on the input string parameter. If the string is equal to 'TRANSACTION', the
  /// method returns the enum value `transaction`. If the string is equal to 'REDEEM', the method
  /// returns the enum value `redeem`. If the string is anything else, the method returns the enum value
  static PromotionDiscountUsageTrigger getPromotionDiscountUsageTriggerFromString(String string) {
    if (string == 'TRANSACTION') {
      return PromotionDiscountUsageTrigger.transaction;
    } else if (string == 'REDEEM') {
      return PromotionDiscountUsageTrigger.redeem;
    } else {
      return PromotionDiscountUsageTrigger.transaction;
    }
  }

  /// This function returns a string representation of a promotion discount usage trigger.
  ///
  /// Returns:
  ///   The method `promotionDiscountUsageTriggerAsString()` is returning the value of the variable
  /// `promotionDiscountUsageTrigger` as a string.
  String promotionDiscountUsageTriggerAsString() {
    return promotionDiscountUsageTrigger;
  }
}
