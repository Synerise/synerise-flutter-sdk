import '../../model/tracker/event.dart';
import '../base/base_module.dart';
import 'tracker_methods.dart';

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