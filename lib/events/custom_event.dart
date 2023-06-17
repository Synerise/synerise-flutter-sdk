import 'event.dart';

/// The CustomEvent class extends the Event class and defines a custom event type with a label, action,
/// and parameters.
class CustomEvent extends Event {
  CustomEvent(String label, String action, Map<String, Object>? parameters) : super(label, action, parameters ?? {});
}
