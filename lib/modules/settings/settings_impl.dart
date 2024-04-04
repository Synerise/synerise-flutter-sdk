import 'dart:io' show Platform;

import 'package:flutter/services.dart';

import '../base/base_module.dart';
import 'settings_methods.dart';

class SettingsKeys {
  static const sdkEnabled = "SDK_ENABLED";
  static const sdkAppGroupIdentifier = "SDK_APP_GROUP_IDENTIFIER";
  static const sdkKeychainGroupIdentifier = "SDK_KEYCHAIN_GROUP_IDENTIFIER";
  static const sdkMinTokenRefreshInterval = "SDK_MIN_TOKEN_REFRESH_INTERVAL";
  static const sdkShouldDestroySessionOnApiKeyChange =
      "SDK_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE";
  static const sdkLocalizable = "SDK_LOCALIZABLE";

  static const trackerIsBackendTimeSyncRequired =
      "TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED";
  static const trackerMinBatchSize = "TRACKER_MIN_BATCH_SIZE";
  static const trackerMaxBatchSize = "TRACKER_MAX_BATCH_SIZE";
  static const trackerAutoFlushTimeout = "TRACKER_AUTO_FLUSH_TIMEOUT";

  static const notificationsEnabled = "NOTIFICATIONS_ENABLED";
  static const notificationsEncryption = "NOTIFICATIONS_ENCRYPTION";
  static const notificationsDisableInAppAlerts =
      "NOTIFICATIONS_DISABLE_IN_APP_ALERTS";

  static const inAppMaxDefinitionUpdateIntervalLimit =
      "IN_APP_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT";
  static const inAppMessagingRenderingTimeout =
      "IN_APP_MESSAGING_RENDERING_TIMEOUT";
  static const inAppMessagingShouldSendInAppCappingEvent =
      "IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT";
  static const inAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch =
      "IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH";

  static const injectorAutomatic = "INJECTOR_AUTOMATIC";
}

class LocalizableKey {
  static const localizableStringKeyOk = "LocalizableStringKeyOK";
  static const localizableStringKeyCancel = "LocalizableStringKeyCancel";

  LocalizableKey._();
}

Map settingsValues = <String, dynamic>{};

typedef GetFunction = Function<T>(String key,
    [bool isSupportedPlatform, dynamic androidDefault, dynamic iosDefault]);
typedef SetFunction = Function<T>(String key, dynamic value,
    [bool isSupportedPlatform]);

class BaseSettings {
  late GetFunction getFunction;
  late SetFunction setFunction;

  BaseSettings(this.getFunction, this.setFunction);
}

class GeneralSettings extends BaseSettings {
  bool get enabled => getFunction<bool>(SettingsKeys.sdkEnabled);
  set enabled(bool enabled) =>
      setFunction<bool>(SettingsKeys.sdkEnabled, enabled);

  String? get appGroupIdentifier => getFunction<String>(
      SettingsKeys.sdkAppGroupIdentifier, Platform.isIOS == true, null);
  set appGroupIdentifier(String? appGroupIdentifier) => setFunction<String>(
      SettingsKeys.sdkAppGroupIdentifier,
      appGroupIdentifier,
      Platform.isIOS == true);

  String? get keychainGroupIdentifier => getFunction<String>(
      SettingsKeys.sdkKeychainGroupIdentifier, Platform.isIOS == true, null);
  set keychainGroupIdentifier(String? keychainGroupIdentifier) =>
      setFunction<String>(SettingsKeys.sdkKeychainGroupIdentifier,
          keychainGroupIdentifier, Platform.isIOS == true);

  double get minTokenRefreshInterval =>
      getFunction<double>(SettingsKeys.sdkMinTokenRefreshInterval);
  set minTokenRefreshInterval(double minTokenRefreshInterval) =>
      setFunction<double>(
          SettingsKeys.sdkMinTokenRefreshInterval, minTokenRefreshInterval);

  bool get shouldDestroySessionOnApiKeyChange =>
      getFunction<bool>(SettingsKeys.sdkShouldDestroySessionOnApiKeyChange);
  set shouldDestroySessionOnApiKeyChange(
          bool shouldDestroySessionOnApiKeyChange) =>
      setFunction<bool>(SettingsKeys.sdkShouldDestroySessionOnApiKeyChange,
          shouldDestroySessionOnApiKeyChange);

  Map<String, String>? get localizable => getFunction<Map<String, String>?>(
      SettingsKeys.sdkLocalizable, Platform.isIOS == true);
  set localizable(Map<String, String>? localizable) =>
      setFunction<Map<String, String>?>(
          SettingsKeys.sdkLocalizable, localizable, Platform.isIOS == true);

  GeneralSettings(GetFunction getFunction, SetFunction setFunction)
      : super(getFunction, setFunction);
}

class TrackerSettings extends BaseSettings {
  bool get isBackendTimeSyncRequired =>
      getFunction<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired);
  set isBackendTimeSyncRequired(bool isBackendTimeSyncRequired) =>
      setFunction<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired,
          isBackendTimeSyncRequired);

  int get minBatchSize => getFunction<int>(SettingsKeys.trackerMinBatchSize);
  set minBatchSize(int minBatchSize) =>
      setFunction<int>(SettingsKeys.trackerMinBatchSize, minBatchSize);

  int get maxBatchSize => getFunction<int>(SettingsKeys.trackerMaxBatchSize);
  set maxBatchSize(int maxBatchSize) =>
      setFunction<int>(SettingsKeys.trackerMaxBatchSize, maxBatchSize);

  double get autoFlushTimeout =>
      getFunction<double>(SettingsKeys.trackerAutoFlushTimeout);
  set autoFlushTimeout(double autoFlushTimeout) => setFunction<double>(
      SettingsKeys.trackerAutoFlushTimeout, autoFlushTimeout);

  TrackerSettings(GetFunction getFunction, SetFunction setFunction)
      : super(getFunction, setFunction);
}

class NotificationsSettings extends BaseSettings {
  bool get enabled => getFunction<bool>(SettingsKeys.notificationsEnabled);
  set enabled(bool enabled) =>
      setFunction<bool>(SettingsKeys.notificationsEnabled, enabled);

  bool get encryption =>
      getFunction<bool>(SettingsKeys.notificationsEncryption);
  set encryption(bool encryption) =>
      setFunction<bool>(SettingsKeys.notificationsEncryption, encryption);

  bool get disableInAppAlerts => getFunction<bool>(
      SettingsKeys.notificationsDisableInAppAlerts,
      Platform.isIOS == true,
      true);
  set disableInAppAlerts(bool disableInAppAlerts) => setFunction<bool>(
      SettingsKeys.notificationsDisableInAppAlerts,
      disableInAppAlerts,
      Platform.isIOS == true);

  NotificationsSettings(GetFunction getFunction, SetFunction setFunction)
      : super(getFunction, setFunction);
}

class InAppMessagingSettings extends BaseSettings {
  double get maxDefinitionUpdateIntervalLimit =>
      getFunction<double>(SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit);
  set maxDefinitionUpdateIntervalLimit(
          double maxDefinitionUpdateIntervalLimit) =>
      setFunction<double>(SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit,
          maxDefinitionUpdateIntervalLimit);

  double get renderingTimeout =>
      getFunction<double>(SettingsKeys.inAppMessagingRenderingTimeout);
  set renderingTimeout(double renderingTimeout) => setFunction<double>(
      SettingsKeys.inAppMessagingRenderingTimeout, renderingTimeout);

  bool get shouldSendInAppCappingEvent =>
      getFunction<bool>(SettingsKeys.inAppMessagingShouldSendInAppCappingEvent);
  set shouldSendInAppCappingEvent(bool shouldSendInAppCappingEvent) =>
      setFunction<bool>(SettingsKeys.inAppMessagingShouldSendInAppCappingEvent,
          shouldSendInAppCappingEvent);

  bool get checkGlobalControlGroupsOnDefinitionsFetch => getFunction<bool>(
      SettingsKeys.inAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch);
  set checkGlobalControlGroupsOnDefinitionsFetch(
          bool checkGlobalControlGroupsOnDefinitionsFetch) =>
      setFunction<bool>(
          SettingsKeys.inAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch,
          checkGlobalControlGroupsOnDefinitionsFetch);

  InAppMessagingSettings(GetFunction getFunction, SetFunction setFunction)
      : super(getFunction, setFunction);
}

class InjectorSettings extends BaseSettings {
  bool get automatic => getFunction<bool>(SettingsKeys.injectorAutomatic);
  set automatic(bool automatic) =>
      setFunction<bool>(SettingsKeys.injectorAutomatic, automatic);

  InjectorSettings(GetFunction getFunction, SetFunction setFunction)
      : super(getFunction, setFunction);
}

class SettingsImpl extends BaseModule {
  late GeneralSettings sdk = GeneralSettings(_getFunction, _setFunction);
  late TrackerSettings tracker = TrackerSettings(_getFunction, _setFunction);
  late NotificationsSettings notifications =
      NotificationsSettings(_getFunction, _setFunction);
  late InAppMessagingSettings inAppMessaging =
      InAppMessagingSettings(_getFunction, _setFunction);
  late InjectorSettings injector = InjectorSettings(_getFunction, _setFunction);

  final SettingsMethods _methods = SettingsMethods();

  SettingsImpl();

  @override
  void beforeInitialization() async {
    super.beforeInitialization();
    await _refreshAllSettings();
  }

  /// This function retrieves a function based on a given key and platform, with optional default
  /// values.
  ///
  /// Args:
  ///   key (String): A string representing the key of the setting to be retrieved.
  ///   isSupportedPlatform: A boolean value indicating whether the current platform is supported. If it
  /// is set to false, the function will return the default value for the platform (androidDefault for
  /// Android, iosDefault for iOS). If it is set to null or true, the function will proceed to retrieve
  /// the value for the given key
  ///   androidDefault (dynamic): The default value to be returned if the platform is Android and the
  /// requested key is not found in the settings.
  ///   iosDefault (dynamic): The default value to be returned if the platform is iOS and the requested
  /// key is not found in the settings.
  ///
  /// Returns:
  ///   either the value associated with the given key in the settings map, or null if the key is not
  /// found. If the function is called before initialization or on an unsupported platform, it throws a
  /// PlatformException. If the function is called on a supported platform but the key is not found in
  /// the settings map, it returns the default value provided for that platform (androidDefault for
  /// Android, ios
  dynamic _getFunction<T>(String key,
      [isSupportedPlatform, dynamic androidDefault, dynamic iosDefault]) {
    if (isInitialized == false) {
      throw PlatformException(
          message:
              'Synerise is not initialized. Access to reading settings is possible when Synerise is initialized.',
          code: '-1');
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

  /// This function sets a value for a given key, but only if the platform is supported.
  ///
  /// Args:
  ///   key (String): A string representing the key of the function to be set or overridden.
  ///   value (dynamic): The value to be set for the given key.
  ///   isSupportedPlatform: isSupportedPlatform is an optional boolean parameter that determines
  /// whether the platform is supported or not.
  ///
  /// Returns:
  ///   If the `isSupportedPlatform` parameter is not provided or is `true`, then nothing is being
  /// returned. If `isSupportedPlatform` is `false`, then the function returns without executing the
  /// rest of the code.
  void _setFunction<T>(String key, dynamic value, [isSupportedPlatform]) {
    if (isSupportedPlatform != null && isSupportedPlatform == false) {
      return;
    }

    _overrideOne<T>(key, value);
    _setOne(key, value);
  }

  /// This function refreshes all settings by overriding them with values obtained from a method call.
  Future<void> _refreshAllSettings() async {
    return _methods.getAllSettings().then((settings) {
      _overrideOne<bool>(
          SettingsKeys.sdkEnabled, settings[SettingsKeys.sdkEnabled]);
      _overrideOne<String>(SettingsKeys.sdkAppGroupIdentifier,
          settings[SettingsKeys.sdkAppGroupIdentifier]);
      _overrideOne<String>(SettingsKeys.sdkKeychainGroupIdentifier,
          settings[SettingsKeys.sdkKeychainGroupIdentifier]);
      _overrideOne<double>(SettingsKeys.sdkMinTokenRefreshInterval,
          settings[SettingsKeys.sdkMinTokenRefreshInterval]);
      _overrideOne<double>(SettingsKeys.sdkShouldDestroySessionOnApiKeyChange,
          settings[SettingsKeys.sdkShouldDestroySessionOnApiKeyChange]);
      _overrideOne<Map<String, String>?>(
          SettingsKeys.sdkLocalizable, settings[SettingsKeys.sdkLocalizable]);

      _overrideOne<bool>(SettingsKeys.trackerIsBackendTimeSyncRequired,
          settings[SettingsKeys.trackerIsBackendTimeSyncRequired]);
      _overrideOne<double>(SettingsKeys.trackerMinBatchSize,
          settings[SettingsKeys.trackerMinBatchSize]);
      _overrideOne<double>(SettingsKeys.trackerMaxBatchSize,
          settings[SettingsKeys.trackerMaxBatchSize]);
      _overrideOne<double>(SettingsKeys.trackerAutoFlushTimeout,
          settings[SettingsKeys.trackerAutoFlushTimeout]);

      _overrideOne<bool>(SettingsKeys.notificationsEnabled,
          settings[SettingsKeys.notificationsEnabled]);
      _overrideOne<bool>(SettingsKeys.notificationsEncryption,
          settings[SettingsKeys.notificationsEncryption]);
      _overrideOne<bool>(SettingsKeys.notificationsDisableInAppAlerts,
          settings[SettingsKeys.notificationsDisableInAppAlerts]);

      _overrideOne<double>(SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit,
          settings[SettingsKeys.inAppMaxDefinitionUpdateIntervalLimit]);
      _overrideOne<double>(SettingsKeys.inAppMessagingRenderingTimeout,
          settings[SettingsKeys.inAppMessagingRenderingTimeout]);
      _overrideOne<bool>(SettingsKeys.inAppMessagingShouldSendInAppCappingEvent,
          settings[SettingsKeys.inAppMessagingShouldSendInAppCappingEvent]);
      _overrideOne<bool>(
          SettingsKeys.inAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch,
          settings[SettingsKeys
              .inAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch]);

      _overrideOne<bool>(SettingsKeys.injectorAutomatic,
          settings[SettingsKeys.injectorAutomatic]);
    });
  }

  Future<void> _setOne(String key, dynamic value) async {
    await _methods.setOne(key, value);
  }

  /// This function retrieves a value from a settings map and returns it if it matches the specified
  /// type, otherwise it returns null.
  ///
  /// Args:
  ///   key (String): The key is a string parameter that represents the key of the value to be retrieved
  /// from the settingsValues map.
  ///
  /// Returns:
  ///   either the value associated with the given key in the `settingsValues` map, or `null` if the key
  /// is not found or the value is not of type `T`. The return type of the function is `dynamic`, which
  /// means it can return any type of value.
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

  /// This function overrides a value in a settings map if the new value is not null and is of the same
  /// type as the original value.
  ///
  /// Args:
  ///   key (String): A string representing the key of the setting value to be overridden or removed.
  ///   value (dynamic): The value that needs to be stored or removed in the settingsValues map.
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
