/// This is defining an enumeration type called `VoucherCodeStatus` with four possible values:
/// `unassigned`, `assigned`, `redeemed`, and `canceled`. Each value is associated with a string
/// representation (`'UNASSIGNED'`, `'ASSIGNED'`, `'REDEEMED'`, and `'CANCELED'`, respectively).
enum VoucherCodeStatus {
  unassigned('UNASSIGNED'),
  assigned('ASSIGNED'),
  redeemed('REDEEMED'),
  canceled('CANCELED');

  const VoucherCodeStatus(this.voucherCodeStatus);

  final String voucherCodeStatus;

  /// The function converts a string to a corresponding VoucherCodeStatus enum value.
  ///
  /// Args:
  ///   string (String): A string representing the status of a voucher code. It can be one of the
  /// following values: 'UNASSIGNED', 'ASSIGNED', 'REDEEMED', or 'CANCELED'.
  ///
  /// Returns:
  ///   This function returns a value of the `VoucherCodeStatus` enum type based on the input string. If
  /// the input string matches one of the defined enum values, the corresponding enum value is returned.
  /// If the input string does not match any of the defined enum values, the default value of
  /// `VoucherCodeStatus.unassigned` is returned.
  static VoucherCodeStatus getVoucherCodeStatusFromString(String string) {
    if (string == 'UNASSIGNED') {
      return VoucherCodeStatus.unassigned;
    } else if (string == 'ASSIGNED') {
      return VoucherCodeStatus.assigned;
    } else if (string == 'REDEEMED') {
      return VoucherCodeStatus.redeemed;
    } else if (string == 'CANCELED') {
      return VoucherCodeStatus.canceled;
    } else {
      return VoucherCodeStatus.unassigned;
    }
  }

  /// This function returns the voucher code status as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable `voucherCodeStatus` as a string.
  String voucherCodeStatusAsString() {
    return voucherCodeStatus;
  }
}
