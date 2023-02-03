import 'package:synerise_flutter_sdk/model/tracker/event.dart';
import '../base/base_module_method_channel.dart';

/// An implementation of [TrackerMethods] that uses main method channel.
class TrackerMethods extends BaseMethodChannel {

  void setCustomIdentifier(String customIdentifier) {
    methodChannel.invokeMethod('Tracker/setCustomIdentifier', {"customIdentifier" : customIdentifier});
  }

  void setCustomEmail(String customEmail) {
    methodChannel.invokeMethod('Tracker/setCustomEmail', {"customEmail" : customEmail});
  }

  void send(Event event) {
    methodChannel.invokeMethod<Map<String, dynamic>>('Tracker/send', event.asMap());
  }

  void flush() {
    methodChannel.invokeMethod('Tracker/flush');
  }
}