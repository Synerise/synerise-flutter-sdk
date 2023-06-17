import 'main/index.dart';
import 'modules/synerise_dart_method_channel.dart';
export 'main/index.dart';

class Synerise {
  Synerise();

  static SettingsImpl settings = SettingsImpl();
  static ClientImpl client = ClientImpl();
  static TrackerImpl tracker = TrackerImpl();
  static ContentImpl content = ContentImpl();
  static NotificationsImpl notifications = NotificationsImpl();
  static InjectorImpl injector = InjectorImpl();
  static PromotionsImpl promotions = PromotionsImpl();

  /// This function returns a SyneriseInitializer object with a completion handler that initializes
  /// Synerise and configures the SyneriseDartMethodChannel instance.
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
