import '../custom_event.dart';

/// The `LoggedOutEvent` class represents an event of signing out of a client with a label and
/// optional parameters.
class LoggedOutEvent extends CustomEvent {
  LoggedOutEvent(String label, Map<String, Object>? parameters)
      : super(label, 'client.logout', parameters);
}
