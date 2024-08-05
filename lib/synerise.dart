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

  static Function()? _ready;

  /// This function returns a SyneriseInitializer object with a completion handler that initializes
  /// Synerise and configures the SyneriseDartMethodChannel instance.
  static SyneriseInitializer initializer() {
    final initializer = SyneriseInitializer();
    initializer.setCompletionHandler((initialized) {
      if (initialized == true) {
        Synerise.settings.afterInitialization();
        Synerise.injector.afterInitialization();
        SyneriseDartMethodChannel.instance.configureChannel();
          if (_ready != null) {
              _ready!();
              }
      } else {
        Synerise.settings.beforeInitialization();
        Synerise.injector.beforeInitialization();
      }
    });

    return initializer;
  }

  /// The function `changeApiKey` is a function that is used to change the: Profile API key.
  ///
  /// Args:
  ///   apiKey (String): The `apiKey` parameter is a string that represents the new Profile API key that you
  /// want to set.
  static Future<void> changeApiKey(String apiKey, [InitializationConfig? config]) async {
    await Dependencies.methodChannel
        .invokeMethod('Synerise/changeApiKey', {
          "apiKey": apiKey,
          "config": config?.asMap()
        });
  }

  static void onReady(Function() ready) {
    _ready = ready;
  }
}