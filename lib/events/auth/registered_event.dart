import '../custom_event.dart';

/// The RegisteredEvent is an event of client registration with a label,
/// parameters, and a specific type of 'client.register'.
class RegisteredEvent extends CustomEvent {
  RegisteredEvent(String label, Map<String, Object>? parameters)
      : super(label, 'client.register', parameters);
}
