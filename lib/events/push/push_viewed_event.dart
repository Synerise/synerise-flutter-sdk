import '../custom_event.dart';

/// The PushViewedEvent class is a custom event that represents a push notification being viewed, with a
/// label and optional parameters.
class PushViewedEvent extends CustomEvent {
  PushViewedEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'push.view', parameters);
}
