import 'package:flutter/services.dart';
import '../synerise.dart';

class SyneriseDartMethodChannel {
  ///This variable is used to identify the method channel that is being set up and configured in the
  /// `configureChannel()` function. The same value is also used in the platform-specific code to
  /// establish communication with the Flutter app through this method channel.
  ///
  /// This channel name needs to match the one in Native method channel.
  static const channelName = "synerise_dart_channel";
  late MethodChannel methodChannel;

  static final SyneriseDartMethodChannel instance =
      SyneriseDartMethodChannel._init();
  SyneriseDartMethodChannel._init();

  /// This function configures a method channel and sets a method call handler.
  void configureChannel() {
    methodChannel = const MethodChannel(channelName);
    methodChannel.setMethodCallHandler(methodHandler);
  }

  /// This function handles method calls for different modules based on the method name.
  ///
  /// Args:
  ///   call (MethodCall): The parameter `call` is of type `MethodCall`, which is a class from the
  /// Flutter framework's `flutter/services.dart` library. It represents a method call from a
  /// platform-specific code to the Flutter app. It contains information such as the method name,
  /// arguments, and argument types.
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
