import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../base/base_module.dart';
import 'package:synerise_flutter_sdk/modules/settings/settings_methods.dart';

class SettingsKeys {
  static const sdkEnabled = "SDK_ENABLED";
  static const sdkAppGroupIdentifier = "SDK_APP_GROUP_IDENTIFIER";
  static const sdkKeychainGroupIdentifier = "SDK_KEYCHAIN_GROUP_IDENTIFIER";
  static const sdkMinTokenRefreshInterval = "SDK_MIN_TOKEN_REFRESH_INTERVAL";
  static const sdkShouldDestroySessionOnApiKeyChange = "SDK_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE";

  static const trackerIsBackendTimeSyncRequired = "TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED";
  static const trackerMinBatchSize = "TRACKER_MIN_BATCH_SIZE";
  static const trackerMaxBatchSize = "TRACKER_MAX_BATCH_SIZE";
  static const trackerAutoFlushTimeout = "TRACKER_AUTO_FLUSH_TIMEOUT";

  static const notificationsEnabled = "NOTIFICATIONS_ENABLED";
  static const notificationsEncryption = "NOTIFICATIONS_ENCRYPTION";
  static const notificationsDisableInAppAlerts = "NOTIFICATIONS_DISABLE_IN_APP_ALERTS";

  static const inAppMaxDefinitionUpdateIntervalLimit = "IN_APP_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT";
  static const inAppMessagingRenderingTimeout = "IN_APP_MESSAGING_RENDERING_TIMEOUT";

  static const injectorAutomatic = "INJECTOR_AUTOMATIC";
}

Map settingsValues = <String, dynamic>{};

typedef GetFunction = Function<T>(String key, [bool isSupportedPlatform, dynamic androidDefault, dynamic iosDefault]);
typedef SetFunction = Function<T>(String key, dynamic value, [bool isSupportedPlatform]);

class BaseSettings {
  late GetFunction getFunction;
  late SetFunction setFunction;

  BaseSettings(this.getFunction, this.setFunction);
}

class GeneralSettings extends BaseSettings {
  bool get enabled => getFunction<bool>(SettingsKeys.sdkEnabled);
  set enabled(bool enabled) => setFunction<bool>(SettingsKeys.sdkEnabled, enabled);

  String? get appGroupIdentifier => getFunction<String>(SettingsKeys.sdkAppGroupIdentifier, Platform.isIOS == true, null);
  set appGroupIdentifier(String? appGroupIdentifier) =>
      setFunction<String>(SettingsKeys.sdkAppGroupIdentifier, appGroupIdentifier, Platform.isIOS == true);

  String? get keychainGroupIdentifier => getFunction<String>(SettingsKeys.sdkKeychainGroupIdentifier, Platform.isIOS == true, null);
  set keychainGroupIdentifier(String? keychainGroupIdentifier) =>
      setFunction<String>(SettingsKeys.sdkKeychainGroupIdentifier, keychainGroupIdentifier, Platform.isIOS == true);

  double get minTokenRefreshInterval => getFunction<double>(SettingsKeys.sdkMinTokenRefreshInterval);
  set minTokenRefreshInterval(double minTokenRefreshInterval) =>
      setFunction<double>(SettingsKeys.sdkMinTokenRefreshInterval, minTokenRefreshInterval);

  bool get shouldDestroySessionOnApiKeyChange => getFunction<bool>(SettingsKeys.sdkShouldDestroySessionOnApiKeyChange);
  set shouldDestroySessionOnApiKeyChange(bool shouldDestroySessionOnApiKeyChange) =>
      setFunction<bool>(SettingsKeys.sdkShouldDestroySessionOnApiKeyChange, minTokenRefreshInterval);

  GeneralSettings(GetFunction getFunction, SetFunction setFunction) : super(getFunction, setFunction);
}

class TrackerSettings extends BaseSettings {
  bool get isBackendTimeSyncRequired => getFunction<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired);
  set isBackendTimeSyncRequired(bool isBackendTimeSyncRequired) =>
      setFunction<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired, isBackendTimeSyncRequired);

  int get minBatchSize => getFunction<int>(SettingsKeys.trackerMinBatchSize);
  set minBatchSize(int minBatchSize) => setFunction<int>(SettingsKeys.trackerMinBatchSize, minBatchSize);

  int get maxBatchSize => getFunction<int>(SettingsKeys.trackerMaxBatchSize);
  set maxBatchSize(int maxBatchSize) => setFunction<int>(SettingsKeys.trackerMaxBatchSize, maxBatchSize);

  double get autoFlushTimeout => getFunction<double>(SettingsKeys.trackerAutoFlushTimeout);
  set autoFlushTimeout(double autoFlushTimeout) => setFunction<double>(SettingsKeys.trackerAutoFlushTimeout, autoFlushTimeout);

  TrackerSettings(GetFunction getFunction, SetFunction setFunction) : super(getFunction, setFunction);
}

class NotificationsSettings extends BaseSettings {
  bool get enabled => getFunction<bool>(SettingsKeys.notificationsEnabled);
  set enabled(bool enabled) => setFunction<bool>(SettingsKeys.notificationsEnabled, enabled);

  bool get encryption => getFunction<bool>(SettingsKeys.notificationsEncryption);
  set encryption(bool encryption) => setFunction<bool>(SettingsKeys.notificationsEncryption, encryption);

  bool get disableInAppAlerts => getFunction<bool>(SettingsKeys.notificationsDisableInAppAlerts, Platform.isIOS == true, true);
  set disableInAppAlerts(bool disableInAppAlerts) =>
      setFunction<bool>(SettingsKeys.notificationsDisableInAppAlerts, disableInAppAlerts, Platform.isIOS == true);

  NotificationsSettings(GetFunction getFunction, SetFunction setFunction) : super(getFunction, setFunction);
}

class InAppMessagingSettings extends BaseSettings {
  double get maxDefinitionUpdateIntervalLimit => getFunction<double>(SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit);
  set maxDefinitionUpdateIntervalLimit(double maxDefinitionUpdateIntervalLimit) =>
      setFunction<double>(SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit, maxDefinitionUpdateIntervalLimit);

  double get renderingTimeout => getFunction<double>(SettingsKeys.inAppMessagingRenderingTimeout);
  set renderingTimeout(double renderingTimeout) => setFunction<double>(SettingsKeys.inAppMessagingRenderingTimeout, renderingTimeout);

  InAppMessagingSettings(GetFunction getFunction, SetFunction setFunction) : super(getFunction, setFunction);
}

class InjectorSettings extends BaseSettings {
  bool get automatic => getFunction<bool>(SettingsKeys.injectorAutomatic);
  set automatic(bool automatic) => setFunction<bool>(SettingsKeys.injectorAutomatic, automatic);

  InjectorSettings(GetFunction getFunction, SetFunction setFunction) : super(getFunction, setFunction);
}

class SettingsImpl extends BaseModule {
  late GeneralSettings sdk = GeneralSettings(_getFunction, _setFunction);
  late TrackerSettings tracker = TrackerSettings(_getFunction, _setFunction);
  late NotificationsSettings notifications = NotificationsSettings(_getFunction, _setFunction);
  late InAppMessagingSettings inAppMessaging = InAppMessagingSettings(_getFunction, _setFunction);
  late InjectorSettings injector = InjectorSettings(_getFunction, _setFunction);

  final SettingsMethods _methods = SettingsMethods();

  SettingsImpl();

  @override
  void beforeInitialization() async {
    super.beforeInitialization();
    await _refreshAllSettings();
  }

  dynamic _getFunction<T>(String key, [isSupportedPlatform, dynamic androidDefault, dynamic iosDefault]) {
    if (isInitialized == false) {
      throw PlatformException(message: 'Synerise is not initialized. Access to reading settings is possible when Synerise is initialized.', code: '-1');
    }

    if (isSupportedPlatform != null && isSupportedPlatform == false) {
      if (Platform.isAndroid == true) {
        return androidDefault;
      }

      if (Platform.isIOS == true) {
        return iosDefault;
      }

      return;
    }

    return _getOne<T>(key);
  }

  void _setFunction<T>(String key, dynamic value, [isSupportedPlatform]) {
    if (isSupportedPlatform != null && isSupportedPlatform == false) {
      return;
    }

    _overrideOne<T>(key, value);
    _setOne(key, value);
  }

  Future<void> _refreshAllSettings() async {
    return _methods.getAllSettings().then((settings) {
      _overrideOne<bool>(SettingsKeys.sdkEnabled, settings[SettingsKeys.sdkEnabled]);
      _overrideOne<String>(SettingsKeys.sdkAppGroupIdentifier, settings[SettingsKeys.sdkAppGroupIdentifier]);
      _overrideOne<String>(SettingsKeys.sdkKeychainGroupIdentifier, settings[SettingsKeys.sdkKeychainGroupIdentifier]);
      _overrideOne<double>(SettingsKeys.sdkMinTokenRefreshInterval, settings[SettingsKeys.sdkMinTokenRefreshInterval]);
      _overrideOne<double>(
          SettingsKeys.sdkShouldDestroySessionOnApiKeyChange, settings[SettingsKeys.sdkShouldDestroySessionOnApiKeyChange]);

      _overrideOne<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired, settings[SettingsKeys.trackerIsBackendTimeSyncRequired]);
      _overrideOne<double>(SettingsKeys.trackerMinBatchSize, settings[SettingsKeys.trackerMinBatchSize]);
      _overrideOne<double>(SettingsKeys.trackerMaxBatchSize, settings[SettingsKeys.trackerMaxBatchSize]);
      _overrideOne<double>(SettingsKeys.trackerAutoFlushTimeout, settings[SettingsKeys.trackerAutoFlushTimeout]);

      _overrideOne<bool>(SettingsKeys.notificationsEnabled, settings[SettingsKeys.notificationsEnabled]);
      _overrideOne<bool>(SettingsKeys.notificationsEncryption, settings[SettingsKeys.notificationsEncryption]);
      _overrideOne<bool>(SettingsKeys.notificationsDisableInAppAlerts, settings[SettingsKeys.notificationsDisableInAppAlerts]);

      _overrideOne<double>(
          SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit, settings[SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit]);
      _overrideOne<double>(SettingsKeys.inAppMessagingRenderingTimeout, settings[SettingsKeys.inAppMessagingRenderingTimeout]);

      _overrideOne<bool>(SettingsKeys.injectorAutomatic, settings[SettingsKeys.injectorAutomatic]);
    });
  }

  Future<void> _setOne(String key, dynamic value) async {
    await _methods.setOne(key, value);
  }

  dynamic _getOne<T>(String key) {
    dynamic value = settingsValues[key];

    if (value == null) {
      return null;
    }

    if (value is T == false) {
      return null;
    }

    return value;
  }

  void _overrideOne<T>(String key, dynamic value) {
    if (value == null) {
      settingsValues.remove(key);
      return;
    }

    if (value is T == true) {
      settingsValues[key] = value;
      return;
    }
  }
}
