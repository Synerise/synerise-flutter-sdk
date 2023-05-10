class PromotionDiscountTypeDetails {
  String name;
  bool outerScope;
  int requiredItemsCount;
  int discountedItemsCount;

  PromotionDiscountTypeDetails({
    required this.name,
    required this.outerScope,
    required this.requiredItemsCount,
    required this.discountedItemsCount,
  });

  PromotionDiscountTypeDetails.fromMap(Map map)
      : this(
          name: map['name'],
          outerScope: map['outerScope'],
          requiredItemsCount: map['requiredItemsCount'],
          discountedItemsCount: map['discountedItemsCount'],
        );

  Map asMap() => {
        'name': name,
        'outerScope': outerScope,
        'requiredItemsCount': requiredItemsCount,
        'discountedItemsCount': discountedItemsCount,
      };
}
