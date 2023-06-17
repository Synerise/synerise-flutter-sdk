import '../custom_event.dart';

/// The SharedEvent represents a shared event with a label and
/// optional parameters.
class SharedEvent extends CustomEvent {
  SharedEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'client.shared', parameters);
}
