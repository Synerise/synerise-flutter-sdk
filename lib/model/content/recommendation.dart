import 'dart:collection';

class Recommendation {
  final HashMap<dynamic, dynamic>? attributes;
  final String? idemId;

  Recommendation({
    this.attributes,
    this.idemId,
  });

  Recommendation.fromMap(Map map)
      : this(
          attributes: map['attributes'],
          idemId: map['idemId'],
        );

  Map asMap() => {
        'attributes': attributes,
        'idemId': idemId,
      };
}
