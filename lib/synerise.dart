import 'package:synerise_flutter_sdk/main/index.dart';
import 'package:synerise_flutter_sdk/modules/SyneriseDartMethodChannel.dart';
export 'package:synerise_flutter_sdk/main/index.dart';

class Synerise {
  Synerise();

  static SettingsImpl settings = SettingsImpl();
  static ClientImpl client = ClientImpl();
  static TrackerImpl tracker = TrackerImpl();
  static ContentImpl content = ContentImpl();
  static NotificationsImpl notifications = NotificationsImpl();
  static InjectorImpl injector = InjectorImpl();

  static SyneriseInitializer initializer() {
    final initializer = SyneriseInitializer();
    initializer.setCompletionHandler((initialized) {
      if (initialized == true) {
        Synerise.settings.afterInitialization();
        SyneriseDartMethodChannel.instance.configureChannel();
      } else {
        Synerise.settings.beforeInitialization();
      }
    });

    return initializer;
  }
}