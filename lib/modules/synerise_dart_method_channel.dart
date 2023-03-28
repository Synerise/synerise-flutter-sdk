import 'package:flutter/services.dart';
import '../synerise.dart';

class SyneriseDartMethodChannel {
  static const channelName = "synerise_dart_channel"; // this channel name needs to match the one in Native method channel
  late MethodChannel methodChannel;

  static final SyneriseDartMethodChannel instance = SyneriseDartMethodChannel._init();
  SyneriseDartMethodChannel._init();

  void configureChannel() {
    methodChannel = const MethodChannel(channelName);
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future<void> methodHandler(MethodCall call) async {
    var modulePath = call.method.split('#');
    // ignore: unnecessary_type_check
    if (modulePath is List<String> && modulePath.length == 3) {
      var module = modulePath[0];

      if (module == 'Notifications') {
        Synerise.notifications.handleMethod(call);
      } else if (module == 'Injector') {
        Synerise.injector.handleMethod(call);
      }
    }
  }
}
