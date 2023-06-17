/// This is an enum called `PromotionType` that defines five possible values: `unknown`,
/// `membersOnly`, `custom`, `general`, and `handbill`. Each value is associated with a string
/// representation. The enum also has a constructor that takes a string argument and a method
/// `getPromotionTypeFromString` that returns a `PromotionType` value based on a given string input. If
/// the input string matches one of the defined enum values, then the corresponding enum value is
/// returned. Otherwise, the value `unknown` is returned. The enum also has a method
/// `promotionTypeAsString` that returns the string representation of the enum value.
enum PromotionType {
  unknown('UNKNOWN'),
  membersOnly('MEMBERS_ONLY'),
  custom('CUSTOM'),
  general('GENERAL'),
  handbill('HANDBILL');

  const PromotionType(this.promotionType);

  final String promotionType;

  /// This function returns a PromotionType enum value based on a given string input.
  ///
  /// Args:
  ///   string (String): A string value that represents a promotion type.
  ///
  /// Returns:
  ///   This function returns a value of the enum type `PromotionType`. The specific value returned
  /// depends on the input string. If the input string matches one of the defined enum values
  /// (`membersOnly`, `custom`, `general`, `handbill`), then the corresponding enum value is returned.
  /// Otherwise, the value `unknown` is returned.
  static PromotionType getPromotionTypeFromString(String string) {
    if (string == 'MEMBERS_ONLY') {
      return PromotionType.membersOnly;
    } else if (string == 'CUSTOM') {
      return PromotionType.custom;
    } else if (string == 'GENERAL') {
      return PromotionType.general;
    } else if (string == 'HANDBILL') {
      return PromotionType.handbill;
    } else {
      return PromotionType.unknown;
    }
  }

  /// This function returns the promotion type as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable `promotionType` as a string.
  String promotionTypeAsString() {
    return promotionType;
  }
}
