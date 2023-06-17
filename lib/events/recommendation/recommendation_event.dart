import '../custom_event.dart';

/// The class `RecommendationEvent` extends `CustomEvent` and creates a new event for recommendations
/// with a label, action, and parameters.
class RecommendationEvent extends CustomEvent {
  RecommendationEvent(super.label, super.action, super.parameters);
}
