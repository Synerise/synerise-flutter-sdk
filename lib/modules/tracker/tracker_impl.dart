import '../../events/event.dart';
import '../base/base_module.dart';
import 'tracker_methods.dart';

class TrackerImpl extends BaseModule {
  final TrackerMethods _methods = TrackerMethods();
  TrackerImpl();

  /// This method sets a custom identifier in the parameters of every event. You can pass a custom
  /// identifier to match your customers in our database.
  ///
  /// Args:
  ///   customIdentifier (String): customIdentifier is a String parameter that represents a unique
  /// customer's custom identifier.
  Future<void> setCustomIdentifier(String customIdentifier) async {
    return await _methods.setCustomIdentifier(customIdentifier);
  }

  /// This method sets a custom email in the parameters of every event. You can pass a custom email to
  /// match your customers in our database.
  ///
  /// Args:
  ///   customEmail (String): customEmail is a variable of type String that represents the email address
  /// that the user wants to set as their custom email.
  Future<void> setCustomEmail(String customEmail) async {
    return await _methods.setCustomEmail(customEmail);
  }

  /// This method sends an event.
  ///
  /// Args:
  ///   event (Event): Event object
  Future<void> send(Event event) async {
    return await _methods.send(event);
  }

  /// This method forces sending the events from the queue to the server.
  Future<void> flush() async {
    return await _methods.flush();
  }
}
