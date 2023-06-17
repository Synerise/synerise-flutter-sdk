import '../custom_event.dart';

/// The PushClickedEvent class is a custom event that represents a push notification click with a label
/// and optional parameters.
class PushClickedEvent extends CustomEvent {
  PushClickedEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'push.click', parameters);
}
