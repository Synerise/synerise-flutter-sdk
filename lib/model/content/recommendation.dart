import 'dart:collection';

class Recommendation {
  final HashMap<dynamic, dynamic> attributes;
  final String itemId;

  Recommendation({
    required this.attributes,
    required this.itemId,
  });

  Recommendation.fromMap(Map map)
      : this(
          attributes: map['attributes'],
          itemId: map['itemId'],
        );

  Map asMap() => {
        'attributes': attributes,
        'itemId': itemId,
      };
}
