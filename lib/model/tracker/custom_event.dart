import 'package:synerise_flutter_sdk/model/tracker/event.dart';

class CustomEvent extends Event {

static const customType = 'custom';

  CustomEvent(String label, String action, Map<String, Object> parameters):
  super(customType, label, action, parameters);
}