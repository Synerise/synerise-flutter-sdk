import 'recommendation_event.dart';

/// The class defines static constants for parameters used in recommendation views.
abstract class RecommendationViewParameters {
  static const String items = 'items';
  static const String category = 'category';
  static const String campaignHash = 'campaignHash';
  static const String campaignId = 'campaignId';
  static const String url = 'url';
  static const String correlationId = 'correlationId';

  RecommendationViewParameters._();
}

/// The class RecommendationViewEvent is used to create an event with specific parameters for tracking
/// recommendation views.
class RecommendationViewEvent extends RecommendationEvent {
  RecommendationViewEvent(
      String label,
      String action,
      List<String>? items,
      String campaignId,
      String campaignHash,
      String correlationId,
      Map<String, Object>? parameters)
      : super(label, 'recommendation.view', parameters) {
    if (items != null) {
      this.parameters[RecommendationViewParameters.items] = items;
    }
    this.parameters[RecommendationViewParameters.correlationId] = campaignId;
    this.parameters[RecommendationViewParameters.correlationId] = campaignHash;
    this.parameters[RecommendationViewParameters.correlationId] = correlationId;
  }

  /// The function sets a list of items as a parameter in a recommendation view.
  void setItems(List<dynamic> items) {
    parameters[RecommendationViewParameters.items] = items;
  }
}
