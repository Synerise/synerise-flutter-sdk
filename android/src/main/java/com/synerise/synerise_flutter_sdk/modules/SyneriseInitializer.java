package com.synerise.synerise_flutter_sdk.modules;

import static com.synerise.synerise_flutter_sdk.SyneriseConnector.app;

import android.app.Application;

import com.synerise.sdk.core.Synerise;
import com.synerise.sdk.core.types.enums.HostApplicationType;
import com.synerise.synerise_flutter_sdk.SyneriseConnector;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInitializer implements SyneriseModule {

    private static SyneriseInitializer instance;
    protected static volatile boolean isInitialized = false;

    public SyneriseInitializer() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {

        switch (calledMethod) {
            case "initialize":
                initSynerise(app, call, result);
                return;
        }
    }

    public void initSynerise(Application app, MethodCall call, MethodChannel.Result result) {
        if (isInitialized == false) {
            prepareDefaultSettings();

            Map dataFull = (Map) call.arguments;
            Map data = (Map) dataFull.get("initializationParameters");
            Synerise.Builder.with(app, data.get("clientApiKey").toString(), SyneriseConnector.getApplicationName(app))
                    .baseUrl(data.containsKey("baseUrl") ? data.get("baseUrl").toString() : null)
                    .syneriseDebugMode(data.containsKey("debugModeEnabled") ? (boolean) data.get("debugModeEnabled") : null)
                    .crashHandlingEnabled(data.containsKey("crashHandlingEnabled") ? (boolean) data.get("crashHandlingEnabled") : null)
                    .hostApplicationType(HostApplicationType.FLUTTER)
                    .pushRegistrationRequired(SyneriseNotifications.getPushNotificationsListener())
                    .build();

            isInitialized = true;

            SyneriseInjector.registerListeners();
        }
        result.success(null);
    }

    private static void prepareDefaultSettings() {
        Synerise.settings.tracker.autoTracking.enabled = false;
    }

    public static SyneriseInitializer getInstance() {
        if (instance == null) {
            instance = new SyneriseInitializer();
        }
        return instance;
    }
}