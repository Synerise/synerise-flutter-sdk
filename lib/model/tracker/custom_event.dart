import 'event.dart';

class CustomEvent extends Event {

static const customType = 'custom';

  CustomEvent(String label, String action, Map<String, Object> parameters):
  super(customType, label, action, parameters);
}