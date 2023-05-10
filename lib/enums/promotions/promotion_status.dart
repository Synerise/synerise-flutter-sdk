enum PromotionStatus {
  none('NONE'),
  active('ACTIVE'),
  assigned('ASSIGNED'),
  redeemed('REDEEMED');

  const PromotionStatus(this.promotionStatus);

  final String promotionStatus;

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

  String promotionStatusAsString() {
    return promotionStatus;
  }
}
