/// This code is defining an enumeration type called `PromotionItemScope` with two possible values:
/// `lineItem` and `basket`. Each value is associated with a string value (`'LINE_ITEM'` and `'BASKET'`,
/// respectively) that represents the promotion item scope.
enum PromotionItemScope {
  lineItem('LINE_ITEM'),
  basket('BASKET');

  const PromotionItemScope(this.promotionItemScope);

  final String promotionItemScope;

  /// The function returns a PromotionItemScope enum value based on a string input.
  ///
  /// Args:
  ///   string (String): A string representing the promotion item scope.
  ///
  /// Returns:
  ///   The method is returning a value of the enumeration type `PromotionItemScope`. The specific value
  /// being returned depends on the input string. If the input string matches the `promotionItemScope`
  /// value of the `lineItem` or `basket` enum values, then the corresponding enum value is returned.
  /// Otherwise, the default value of `lineItem` is returned.
  static PromotionItemScope getPromotionItemScopeFromString(String string) {
    if (string == PromotionItemScope.lineItem.promotionItemScope) {
      return PromotionItemScope.lineItem;
    } else if (string == PromotionItemScope.basket.promotionItemScope) {
      return PromotionItemScope.basket;
    } else {
      return PromotionItemScope.lineItem;
    }
  }

  /// This function returns the promotion item scope as a string.
  ///
  /// Returns:
  ///   The method `promotionItemScopeAsString()` is returning the value of the variable
  /// `promotionItemScope` as a string.
  String promotionItemScopeAsString() {
    return promotionItemScope;
  }
}
