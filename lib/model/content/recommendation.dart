/// The class Recommendation represents a recommendation with attributes and an item ID, and can be
/// converted to and from a map.
class Recommendation {
  final Map<String, Object> attributes;
  final String itemID;

  Recommendation._({
    required this.attributes,
    required this.itemID,
  });

  /// This is a named constructor in the `Recommendation` class that takes a `Map` as input and creates
  /// a new instance of the `Recommendation` class using the values from the input `Map`.
  Recommendation.fromMap(Map map)
      : this._(
          attributes: Map<String, Object>.from(map['attributes']),
          itemID: map['itemID'],
        );

  /// The function returns a map with 'attributes' and 'itemID' keys and their corresponding values.
  Map asMap() => {
        'attributes': attributes,
        'itemID': itemID,
      };
}
