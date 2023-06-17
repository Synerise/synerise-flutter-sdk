import '../custom_event.dart';

/// The VisitedScreenEvent class is an event that represents a screen view with a label and
/// optional parameters.
class VisitedScreenEvent extends CustomEvent {
  VisitedScreenEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'screen.view', parameters);
}
