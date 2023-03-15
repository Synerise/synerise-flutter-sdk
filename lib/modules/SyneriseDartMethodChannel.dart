import 'package:flutter/services.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class SyneriseDartMethodChannel {
  static const channelName = "synerise_dart_channel"; // this channel name needs to match the one in Native method channel
  late MethodChannel methodChannel;

  static final SyneriseDartMethodChannel instance = SyneriseDartMethodChannel._init();
  SyneriseDartMethodChannel._init();

  void configureChannel() {
    methodChannel = MethodChannel(channelName);
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future<void> methodHandler(MethodCall call) async {
    var modulePath = call.method.split('#');
    if (modulePath is List<String> && modulePath.length == 3) {
      var module = modulePath[0];
      var listener = modulePath[1];

      if (module == 'Notifications') {
        Synerise.notifications.handleMethod(call);
      } else if (module == 'Injector') {
        Synerise.injector.handleMethod(call);
      }
        }
  }
}