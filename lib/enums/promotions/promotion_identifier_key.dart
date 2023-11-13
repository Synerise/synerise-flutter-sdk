/// This is defining an enumeration called `PromotionIdentifierKey` with two possible values: `uuid` and
/// `code`. Each value is associated with a string value (`'UUID'` and `'CODE'` respectively). The
/// `const PromotionIdentifierKey(this.promotionIdentifierKey)` constructor is used to initialize the
/// `promotionIdentifierKey` field with the string value associated with each enumeration value.
enum PromotionIdentifierKey {
  uuid('UUID'),
  code('CODE');

  const PromotionIdentifierKey(this.promotionIdentifierKey);

  final String promotionIdentifierKey;

  /// The function returns a PromotionIdentifierKey based on a given string input.
  ///
  /// Args:
  ///   string (String): A string value that represents the type of promotion identifier key. It can be
  /// either "UUID" or "CODE".
  ///
  /// Returns:
  ///   The function `getPromotionIdentifierKeyFromString` returns a value of the
  /// `PromotionIdentifierKey` enum type. The returned value depends on the input string: if the string
  /// is "UUID", the function returns the `uuid` value of the enum, if the string is "CODE", the
  /// function returns the `code` value of the enum, and if the string is anything else, the
  static PromotionIdentifierKey getPromotionIdentifierKeyFromString(
      String string) {
    if (string == 'UUID') {
      return PromotionIdentifierKey.uuid;
    } else if (string == 'CODE') {
      return PromotionIdentifierKey.code;
    } else {
      return PromotionIdentifierKey.uuid;
    }
  }

  /// This function returns the promotion identifier key as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable `promotionIdentifierKey` as a string.
  String promotionIdentifierKeyAsString() {
    return promotionIdentifierKey;
  }
}
