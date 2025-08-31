package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

import com.synerise.sdk.core.Synerise;
import com.synerise.sdk.core.settings.Settings;
import com.synerise.synerise_flutter_sdk.SyneriseModule;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseSettings implements SyneriseModule {
    public static final String F_SETTINGS_SDK_ENABLED = "SDK_ENABLED";
    public static final String F_SETTINGS_SDK_DO_NOT_TRACK = "SDK_DO_NOT_TRACK";
    public static final String F_SETTINGS_SDK_MIN_TOKEN_REFRESH_INTERVAL = "SDK_MIN_TOKEN_REFRESH_INTERVAL";
    public static final String F_SETTINGS_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE = "SDK_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE";
    public static final String F_SETTINGS_TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED = "TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED";
    public static final String F_SETTINGS_TRACKER_MIN_BATCH_SIZE = "TRACKER_MIN_BATCH_SIZE";
    public static final String F_SETTINGS_TRACKER_MAX_BATCH_SIZE = "TRACKER_MAX_BATCH_SIZE";
    public static final String F_SETTINGS_TRACKER_AUTO_FLUSH_TIMEOUT = "TRACKER_AUTO_FLUSH_TIMEOUT";
    public static final String F_SETTINGS_TRACKER_EVENTS_TRIGGERING_FLUSH = "TRACKER_EVENTS_TRIGGERING_FLUSH";
    public static final String F_SETTINGS_NOTIFICATIONS_ENABLED = "NOTIFICATIONS_ENABLED";
    public static final String F_SETTINGS_NOTIFICATIONS_ENCRYPTION = "NOTIFICATIONS_ENCRYPTION";
    public static final String F_SETTINGS_INJECTOR_AUTOMATIC = "INJECTOR_AUTOMATIC";
    public static final String F_SETTINGS_IN_APP_MESSAGING_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT = "IN_APP_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT";
    public static final String F_SETTINGS_IN_APP_MESSAGING_RENDERING_TIMEOUT = "IN_APP_MESSAGING_RENDERING_TIMEOUT";
    public static final String F_SETTINGS_IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT = "IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT";
    public static final String F_SETTINGS_IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH = "IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH";
    public static final String F_SETTINGS_IN_APP_MESSAGING_CONTENT_BASE_URL = "IN_APP_MESSAGING_CONTENT_BASE_URL";

    private static SyneriseSettings instance;

    public static SyneriseSettings getInstance() {
        if (instance == null) {
            instance = new SyneriseSettings();
        }
        return instance;
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "getAllSettings":
                getAllSettings(call, result);
                return;
            case "setOne":
                setOne(call, result);
                return;
            case "setMany":
                setMany(call, result);
                return;
            case "getOne":
                getOne(call, result);
                return;
        }
    }

    private void getAllSettings(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> settingsMap = settingsMap();
        result.success(settingsMap);
    }

    private void setOne(MethodCall call, MethodChannel.Result result) {
        Map arguments = (Map) call.arguments;
        String key = (String) arguments.get("key");
        Object value = arguments.get("value");

        matchSetting(key, value);
    }

    private void setMany(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;

        for (String key : arguments.keySet()) {
            matchSetting(key, arguments.get(key));
        }
    }

    private void getOne(MethodCall call, MethodChannel.Result result) {
        Map arguments = (Map) call.arguments;
        String key = (String) arguments.get("key");
        if (key != null) {
            result.success(getSetting(key));
        }
    }

    private void matchSetting(String key, Object value) {
        switch (key) {
            case F_SETTINGS_SDK_ENABLED:
                if (value instanceof Boolean) {
                    Settings.getInstance().sdk.setSDKEnabled((Boolean) value);
                }
                break;
            case F_SETTINGS_SDK_DO_NOT_TRACK:
                if (value instanceof Boolean) {
                    Settings.getInstance().sdk.setDoNotTrack((Boolean) value);
                }
                break;
            case F_SETTINGS_SDK_MIN_TOKEN_REFRESH_INTERVAL:
                if (value instanceof Integer) {
                    Settings.getInstance().sdk.setMinTokenRefreshInterval((int) value);
                }
                break;
            case F_SETTINGS_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE:
                if (value instanceof Boolean) {
                    Settings.getInstance().sdk.shouldDestroySessionOnApiKeyChange = (Boolean) value;
                }
                break;
            case F_SETTINGS_TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED:
                if (value instanceof Boolean) {
                    Settings.getInstance().tracker.isBackendTimeSyncRequired = (Boolean) value;
                }
            case F_SETTINGS_TRACKER_AUTO_FLUSH_TIMEOUT:
                if (value instanceof Double) {
                    int autoFlushTimeout = ((Double) value).intValue() * 1000;
                    Settings.getInstance().tracker.setAutoFlushTimeout(autoFlushTimeout);
                }
                break;
            case F_SETTINGS_TRACKER_EVENTS_TRIGGERING_FLUSH:
                if (value instanceof ArrayList<?>) {
                    List<String> eventsFromFlutter = new ArrayList<>();
                    for (int i = 0; i < ((ArrayList<?>) value).size(); i++) {
                       eventsFromFlutter.add((String) ((ArrayList<?>) value).get(i));
                    }
                    Settings.getInstance().tracker.eventsTriggeringFlush = eventsFromFlutter;
                }
                break;
            case F_SETTINGS_TRACKER_MAX_BATCH_SIZE:
                if (value instanceof Integer) {
                    Settings.getInstance().tracker.setMaximumBatchSize((int) value);
                }
                break;
            case F_SETTINGS_TRACKER_MIN_BATCH_SIZE:
                if (value instanceof Integer) {
                    Settings.getInstance().tracker.setMinimumBatchSize((int) value);
                }
                break;
            case F_SETTINGS_NOTIFICATIONS_ENABLED:
                if (value instanceof Boolean) {
                    Settings.getInstance().notifications.enabled = (boolean) value;
                }
                break;
            case F_SETTINGS_NOTIFICATIONS_ENCRYPTION:
                if (value instanceof Boolean) {
                    Settings.getInstance().notifications.setEncryption((Boolean) value);
                }
                break;
            case F_SETTINGS_INJECTOR_AUTOMATIC:
                if (value instanceof Boolean) {
                    Settings.getInstance().injector.automatic = (Boolean) value;
                }
                break;
            case F_SETTINGS_IN_APP_MESSAGING_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT:
                if (value instanceof Double) {
                    Settings.getInstance().inAppMessaging.setMaxDefinitionUpdateIntervalLimit((int) value);
                }
                break;
            case F_SETTINGS_IN_APP_MESSAGING_RENDERING_TIMEOUT:
                if (value instanceof Double) {
                    int renderingTimeout = ((Double) value).intValue();
                    Settings.getInstance().inAppMessaging.renderingTimeout = renderingTimeout;
                }
                break;
            case F_SETTINGS_IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT:
                if (value instanceof Boolean) {
                    Settings.getInstance().inAppMessaging.shouldSendInAppCappingEvent = (Boolean) value;
                }
                break;
            case F_SETTINGS_IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH:
                if (value instanceof Boolean) {
                    Settings.getInstance().inAppMessaging.checkGlobalControlGroupsOnDefinitionsFetch = (Boolean) value;
                }
                break;
            case F_SETTINGS_IN_APP_MESSAGING_CONTENT_BASE_URL:
                if (value instanceof String) {
                    Settings.getInstance().inAppMessaging.setContentBaseUrl((String) value);
                }
                break;
        }
    }

    private Object getSetting(String key) {
        return switch (key) {
            case F_SETTINGS_SDK_ENABLED -> Settings.getInstance().sdk.isSDKEnabled();
            case F_SETTINGS_SDK_DO_NOT_TRACK -> Settings.getInstance().sdk.getDoNotTrack();
            case F_SETTINGS_SDK_MIN_TOKEN_REFRESH_INTERVAL ->
                    Settings.getInstance().sdk.getMinTokenRefreshInterval();
            case F_SETTINGS_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE ->
                    Settings.getInstance().sdk.shouldDestroySessionOnApiKeyChange;
            case F_SETTINGS_TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED ->
                    Settings.getInstance().tracker.isBackendTimeSyncRequired;
            case F_SETTINGS_TRACKER_AUTO_FLUSH_TIMEOUT ->
                    Settings.getInstance().tracker.autoFlushTimeout;
            case F_SETTINGS_TRACKER_EVENTS_TRIGGERING_FLUSH ->
                    Settings.getInstance().tracker.eventsTriggeringFlush;
            case F_SETTINGS_TRACKER_MAX_BATCH_SIZE -> Settings.getInstance().tracker.maxBatchSize;
            case F_SETTINGS_TRACKER_MIN_BATCH_SIZE -> Settings.getInstance().tracker.minBatchSize;
            case F_SETTINGS_NOTIFICATIONS_ENABLED -> Settings.getInstance().notifications.enabled;
            case F_SETTINGS_NOTIFICATIONS_ENCRYPTION ->
                    Settings.getInstance().notifications.getEncryption();
            case F_SETTINGS_INJECTOR_AUTOMATIC -> Settings.getInstance().injector.automatic;
            case F_SETTINGS_IN_APP_MESSAGING_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT ->
                    Settings.getInstance().inAppMessaging.getMaxDefinitionUpdateIntervalLimit();
            case F_SETTINGS_IN_APP_MESSAGING_RENDERING_TIMEOUT ->
                    Settings.getInstance().inAppMessaging.renderingTimeout;
            case F_SETTINGS_IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT ->
                    Settings.getInstance().inAppMessaging.shouldSendInAppCappingEvent;
            case F_SETTINGS_IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH ->
                    Settings.getInstance().inAppMessaging.checkGlobalControlGroupsOnDefinitionsFetch;
            case F_SETTINGS_IN_APP_MESSAGING_CONTENT_BASE_URL ->
                    Settings.getInstance().inAppMessaging.getContentBaseUrl();
            default -> null;
        };
    }

    private Map<String, Object> settingsMap() {
        Map<String, Object> settings = new HashMap<>();
        settings.put(F_SETTINGS_SDK_ENABLED, Synerise.settings.sdk.isSDKEnabled());
        // Intended do not uncomment. DoNotTrack is retrieved with different method.
        //settings.put(F_SETTINGS_SDK_DO_NOT_TRACK, Synerise.settings.sdk.getDoNotTrack());
        settings.put(F_SETTINGS_SDK_MIN_TOKEN_REFRESH_INTERVAL, Synerise.settings.sdk.getMinTokenRefreshInterval());
        settings.put(F_SETTINGS_TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED, Synerise.settings.tracker.isBackendTimeSyncRequired);
        settings.put(F_SETTINGS_TRACKER_MIN_BATCH_SIZE, Synerise.settings.tracker.minBatchSize);
        settings.put(F_SETTINGS_TRACKER_MAX_BATCH_SIZE, Synerise.settings.tracker.maxBatchSize);
        settings.put(F_SETTINGS_TRACKER_AUTO_FLUSH_TIMEOUT, (Synerise.settings.tracker.autoFlushTimeout / 1000));
        settings.put(F_SETTINGS_TRACKER_EVENTS_TRIGGERING_FLUSH, Synerise.settings.tracker.eventsTriggeringFlush);
        settings.put(F_SETTINGS_NOTIFICATIONS_ENABLED, Synerise.settings.notifications.enabled);
        settings.put(F_SETTINGS_NOTIFICATIONS_ENCRYPTION, Synerise.settings.notifications.getEncryption());
        settings.put(F_SETTINGS_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE, Synerise.settings.sdk.shouldDestroySessionOnApiKeyChange);
        settings.put(F_SETTINGS_INJECTOR_AUTOMATIC, Synerise.settings.injector.automatic);
        settings.put(F_SETTINGS_IN_APP_MESSAGING_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT, Synerise.settings.inAppMessaging.getMaxDefinitionUpdateIntervalLimit());
        settings.put(F_SETTINGS_IN_APP_MESSAGING_RENDERING_TIMEOUT, Synerise.settings.inAppMessaging.renderingTimeout);
        settings.put(F_SETTINGS_IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT, Synerise.settings.inAppMessaging.shouldSendInAppCappingEvent);
        settings.put(F_SETTINGS_IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH, Synerise.settings.inAppMessaging.checkGlobalControlGroupsOnDefinitionsFetch);
        settings.put(F_SETTINGS_IN_APP_MESSAGING_CONTENT_BASE_URL, Synerise.settings.inAppMessaging.getContentBaseUrl());

        return settings;
    }
}