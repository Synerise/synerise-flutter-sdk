/// The InlineInAppMessageData class represents data for an inline in-app message campaign, including
/// campaign hash, variant identifier, placement key, additional parameters, and a flag for testing.
class InlineInAppMessageData {
  String campaignHash;
  String variantIdentifier;
  String placementKey;
  Map<String, dynamic> additionalParameters;
  bool isTest;

  InlineInAppMessageData(this.campaignHash, this.variantIdentifier,
      this.placementKey, this.additionalParameters, this.isTest);

  /// This is a constructor named `fromMap` that takes a `Map` as an argument and creates a new instance
  /// of the `InlineInAppMessageData` class using the values from the map.
  InlineInAppMessageData.fromMap(Map map)
      : this(
            map['campaignHash'] ?? '',
            map['variantIdentifier'] ?? '',
            map['placementKey'] ?? '',
            map['additionalParameters'] != null
                ? Map<String, dynamic>.from(map['additionalParameters'])
                : <String, dynamic>{},
            map['isTest'] ?? false);
}
