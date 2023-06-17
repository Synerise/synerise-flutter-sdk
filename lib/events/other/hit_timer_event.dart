import '../custom_event.dart';

/// The HitTimerEvent class is an event that represents a hit timer event with a label and
/// optional parameters.
class HitTimerEvent extends CustomEvent {
  HitTimerEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'client.hitTimer', parameters);
}
