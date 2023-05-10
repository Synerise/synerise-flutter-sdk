enum PromotionIdentifierKey {
  uuid('UUID'),
  code('CODE');

  const PromotionIdentifierKey(this.promotionIdentifierKey);

  final String promotionIdentifierKey;

  static PromotionIdentifierKey getPromotionIdentifierKeyFromString(String string) {
    if (string == 'UUID') {
      return PromotionIdentifierKey.uuid;
    } else if (string == 'CODE') {
      return PromotionIdentifierKey.code;
    } else {
      return PromotionIdentifierKey.uuid;
    }
  }

  String promotionIdentifierKeyAsString() {
    return promotionIdentifierKey;
  }
}
