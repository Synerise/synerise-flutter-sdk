import '../../enums/promotions/promotion_identifier_key.dart';

class PromotionIdentifier {
  PromotionIdentifierKey key;
  String value;

  PromotionIdentifier({required this.key, required this.value});

  PromotionIdentifier.fromMap(Map map)
      : this(
          key: PromotionIdentifierKey.getPromotionIdentifierKeyFromString(map['key']),
          value: map['value'],
        );

  Map asMap() => {
        'key': key.promotionIdentifierKeyAsString(),
        'value': value,
      };
}
