import 'recommendation_event.dart';

/// The class defines static constants for parameters used in a recommendation click event.
abstract class RecommendationClickEventParameters {
  static const String productId = 'productId';
  static const String name = 'name';
  static const String category = 'category';
  static const String campaignHash = 'campaignHash';
  static const String campaignId = 'campaignId';
  static const String url = 'url';

  RecommendationClickEventParameters._();
}

/// The class represents a recommendation click event with specific parameters.
class RecommendationClickEvent extends RecommendationEvent {
  RecommendationClickEvent(String label, String action, String productId, String productName, String campaignId, String campaignHash,
      Map<String, Object>? parameters)
      : super(label, 'recommendation.click', parameters) {
    this.parameters[RecommendationClickEventParameters.productId] = productId;
    this.parameters[RecommendationClickEventParameters.name] = productName;
    this.parameters[RecommendationClickEventParameters.campaignId] = campaignId;
    this.parameters[RecommendationClickEventParameters.campaignHash] = campaignHash;
  }

  /// This function sets the category parameter for a recommendation click event.
  void setCategory(String category) {
    parameters[RecommendationClickEventParameters.category] = category;
  }

  /// The function sets a URL parameter in a recommendation click event.
  void setUrl(String url) {
    parameters[RecommendationClickEventParameters.url] = url;
  }
}
