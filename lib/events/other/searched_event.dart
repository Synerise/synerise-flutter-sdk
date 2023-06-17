import '../custom_event.dart';

/// The `SearchedEvent` class is a custom event that represents a search action with a label and
/// optional parameters.
class SearchedEvent extends CustomEvent {
  SearchedEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'client.search', parameters);
}
