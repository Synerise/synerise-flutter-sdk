import '../custom_event.dart';

/// The class represents an event of signing in user with a label, event type, and optional
/// parameters.
class LoggedInEvent extends CustomEvent {
  LoggedInEvent(String label, Map<String, Object>? parameters) : super(label, 'client.login', parameters);
}
