import '../../enums/promotions/promotion_identifier_key.dart';

/// The PromotionIdentifier class represents a key-value pair object used to identify a promotion, with methods
/// for converting to and from a map.
class PromotionIdentifier {
  PromotionIdentifierKey key;
  String value;

  PromotionIdentifier({required this.key, required this.value});

  /// `PromotionIdentifier.fromMap(Map map)` is a constructor that takes a `Map` as an argument and
  /// creates a new `PromotionIdentifier` object from it.
  PromotionIdentifier.fromMap(Map map)
      : this(
          key: PromotionIdentifierKey.getPromotionIdentifierKeyFromString(
              map['key']),
          value: map['value'],
        );

  /// The function returns a map with a key and value based on the promotion identifier key and value.
  Map asMap() => {
        'key': key.promotionIdentifierKeyAsString(),
        'value': value,
      };
}
