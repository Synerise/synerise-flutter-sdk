/// The `PromotionDiscountTypeDetails` class represents details about a promotion discount type and
/// includes methods for creating an instance from a `Map` and converting it to a `Map`.
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

  /// `PromotionDiscountTypeDetails.fromMap(Map map)` is a constructor that takes a `Map` as an argument
  /// and creates a new instance of `PromotionDiscountTypeDetails` using the values from the `Map`.
  PromotionDiscountTypeDetails.fromMap(Map map)
      : this(
          name: map['name'],
          outerScope: map['outerScope'],
          requiredItemsCount: map['requiredItemsCount'],
          discountedItemsCount: map['discountedItemsCount'],
        );

  /// The function returns a map containing the values of name, outerScope, requiredItemsCount, and
  /// discountedItemsCount.
  Map asMap() => {
        'name': name,
        'outerScope': outerScope,
        'requiredItemsCount': requiredItemsCount,
        'discountedItemsCount': discountedItemsCount,
      };
}
