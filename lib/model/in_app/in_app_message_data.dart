/// The InAppMessageData class represents data for an in-app message campaign, including campaign hash,
/// variant identifier, additional parameters, and a flag for testing.
class InAppMessageData {
  String campaignHash;
  String variantIdentifier;
  Map<String, String> additionalParameters;
  bool isTest;

  InAppMessageData(this.campaignHash, this.variantIdentifier, this.additionalParameters, this.isTest);

  /// This is a constructor named `fromMap` that takes a `Map` as an argument and creates a new instance
  /// of the `InAppMessageData` class using the values from the map.
  InAppMessageData.fromMap(Map map) : this(map['campaignHash'], map['variantIdentifier'], map['additionalParameters'], map['isTest']);
}
