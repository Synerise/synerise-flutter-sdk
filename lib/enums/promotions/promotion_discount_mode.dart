/// This is defining an enumeration called `PromotionDiscountMode` with two possible values:
/// `staticMode` and `stepMode`. Each value is associated with a string value (`'STATIC'` and `'STEP'`,
/// respectively). The `getPromotionDiscountModeFromString` method is used to convert a string value to the
/// corresponding enum value.
enum PromotionDiscountMode {
  staticMode('STATIC'),
  stepMode('STEP');

  const PromotionDiscountMode(this.promotionDiscountMode);

  final String promotionDiscountMode;

  /// `static PromotionDiscountMode getPromotionDiscountModeFromString(String string)` is a static
  /// method that takes a string as input and returns the corresponding `PromotionDiscountMode` enum
  /// value. It checks if the input string matches either `'STATIC'` or `'STEP'`, and returns the
  /// corresponding enum value (`staticMode` or `stepMode`). If the input string does not match either
  /// of these values, it returns the default value of `staticMode`.
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
