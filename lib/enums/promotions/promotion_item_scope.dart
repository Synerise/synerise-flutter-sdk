enum PromotionItemScope {
  lineItem('LINE_ITEM'),
  basket('BASKET');

  const PromotionItemScope(this.promotionItemScope);

  final String promotionItemScope;

  static PromotionItemScope getPromotionItemScopeFromString(String string) {
    if (string == PromotionItemScope.lineItem.promotionItemScope) {
      return PromotionItemScope.lineItem;
    } else if (string == PromotionItemScope.basket.promotionItemScope) {
      return PromotionItemScope.basket;
    } else {
      return PromotionItemScope.lineItem;
    }
  }

  String promotionItemScopeAsString() {
    return promotionItemScope;
  }
}
