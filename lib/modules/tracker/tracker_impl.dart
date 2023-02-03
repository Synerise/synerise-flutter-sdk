import 'package:synerise_flutter_sdk/model/tracker/event.dart';
import 'package:synerise_flutter_sdk/modules/tracker/tracker_methods.dart';
import '../base/base_module.dart';

class TrackerImpl extends BaseModule {
  final TrackerMethods _methods = TrackerMethods();
  TrackerImpl();

  void setCustomIdentifier(String customIdentifier) {
    _methods.setCustomIdentifier(customIdentifier);
  }

  void setCustomEmail(String customEmail) {
    _methods.setCustomEmail(customEmail);
  }

  void send(Event event) {
    _methods.send(event);
  }

  void flush() {
    _methods.flush();
  }
}