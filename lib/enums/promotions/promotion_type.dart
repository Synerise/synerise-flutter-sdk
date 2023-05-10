enum PromotionType {
  unknown('UNKNOWN'),
  membersOnly('MEMBERS_ONLY'),
  custom('CUSTOM'),
  general('GENERAL'),
  handbill('HANDBILL');

  const PromotionType(this.promotionType);

  final String promotionType;

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

  String promotionTypeAsString() {
    return promotionType;
  }
}
