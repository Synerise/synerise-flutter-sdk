/// This is defining an enumeration called `PromotionStatus` with four possible values: `none`,
/// `active`, `assigned`, and `redeemed`. Each value is associated with a string representation
/// (`'NONE'`, `'ACTIVE'`, `'ASSIGNED'`, and `'REDEEMED'`, respectively).
enum PromotionStatus {
  none('NONE'),
  active('ACTIVE'),
  assigned('ASSIGNED'),
  redeemed('REDEEMED');

  const PromotionStatus(this.promotionStatus);

  final String promotionStatus;

  /// The function returns a PromotionStatus enum value based on a given string input.
  ///
  /// Args:
  ///   string (String): A string value that represents the promotion status. It can be one of the
  /// following values: 'ACTIVE', 'ASSIGNED', or 'REDEEMED'. If the string value is not one of these,
  /// the function returns PromotionStatus.none.
  ///
  /// Returns:
  ///   a value of the `PromotionStatus` enum type based on the input string. If the input string
  /// matches one of the defined enum values (`ACTIVE`, `ASSIGNED`, or `REDEEMED`), the corresponding
  /// enum value is returned. Otherwise, the `none` value of the `PromotionStatus` enum is returned.
  static PromotionStatus getPromotionStatusFromString(String string) {
    if (string == 'ACTIVE') {
      return PromotionStatus.active;
    } else if (string == 'ASSIGNED') {
      return PromotionStatus.assigned;
    } else if (string == 'REDEEMED') {
      return PromotionStatus.redeemed;
    } else {
      return PromotionStatus.none;
    }
  }

  /// This function returns the promotion status as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable `promotionStatus` as a string.
  String promotionStatusAsString() {
    return promotionStatus;
  }
}
