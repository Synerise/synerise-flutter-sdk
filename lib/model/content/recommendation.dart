class Recommendation {
  final Map<String, Object> attributes;
  final String itemID;

  Recommendation._({
    required this.attributes,
    required this.itemID,
  });

  Recommendation.fromMap(Map map)
      : this._(
          attributes: Map<String, Object>.from(map['attributes']),
          itemID: map['itemID'],
        );

  Map asMap() => {
        'attributes': attributes,
        'itemID': itemID,
      };
}
