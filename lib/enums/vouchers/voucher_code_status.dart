enum VoucherCodeStatus {
  unassigned('UNASSIGNED'),
  assigned('ASSIGNED'),
  redeemed('REDEEMED'),
  canceled('CANCELED');

  const VoucherCodeStatus(this.voucherCodeStatus);

  final String voucherCodeStatus;

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

  String voucherCodeStatusAsString() {
    return voucherCodeStatus;
  }
}
