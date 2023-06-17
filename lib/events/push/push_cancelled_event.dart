import '../custom_event.dart';

/// The PushCancelledEvent class is a custom event that represents the cancellation of a push
/// notification.
class PushCancelledEvent extends CustomEvent {
  PushCancelledEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'push.cancel', parameters);
}
