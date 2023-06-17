import 'recommendation_event.dart';

/// The class defines static constants for parameters related to a recommendation seen event.
abstract class RecommendationSeenEventParameters {
  static const String productId = 'productId';
  static const String name = 'name';
  static const String category = 'category';
  static const String campaignHash = 'campaignHash';
  static const String campaignId = 'campaignId';
  static const String url = 'url';

  RecommendationSeenEventParameters._();
}

/// This is a recommendation seen event with parameters such as product ID,
/// product name, campaign ID, and campaign hash.
abstract class RecommendationSeenEvent extends RecommendationEvent {
  RecommendationSeenEvent(String label, String action, String productId, String productName, String campaignId, String campaignHash,
      Map<String, Object>? parameters)
      : super(label, 'recommendation.seen', parameters) {
    this.parameters[RecommendationSeenEventParameters.productId] = productId;
    this.parameters[RecommendationSeenEventParameters.name] = productName;
    this.parameters[RecommendationSeenEventParameters.campaignId] = campaignId;
    this.parameters[RecommendationSeenEventParameters.campaignHash] = campaignHash;
  }

  /// This function sets the category parameter for a recommendation seen event.
  void setCategory(String category) {
    parameters[RecommendationSeenEventParameters.category] = category;
  }

  /// This function sets a URL parameter in a map called "parameters".
  void setUrl(String url) {
    parameters[RecommendationSeenEventParameters.url] = url;
  }
}
