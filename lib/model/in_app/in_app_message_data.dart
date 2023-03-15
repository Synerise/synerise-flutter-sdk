class InAppMessageData {
  String campaignHash;
  String variantIdentifier;
  Map<String, String> additionalParameters;
  bool isTest;

  InAppMessageData(this.campaignHash, this.variantIdentifier, this.additionalParameters, this.isTest);
  
  InAppMessageData.fromMap(Map map) : this(map['campaignHash'], map['variantIdentifier'], map['additionalParameters'], map['isTest']);
}