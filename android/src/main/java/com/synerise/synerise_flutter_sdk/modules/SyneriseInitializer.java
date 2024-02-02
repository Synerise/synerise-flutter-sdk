package com.synerise.synerise_flutter_sdk.modules;

import static com.synerise.synerise_flutter_sdk.SyneriseConnector.app;
import static com.synerise.synerise_flutter_sdk.modules.SyneriseInjector.initializeActionInjectorListener;

import android.app.Application;

import com.synerise.sdk.client.Client;
import com.synerise.sdk.core.Synerise;
import com.synerise.sdk.core.types.enums.HostApplicationType;
import com.synerise.synerise_flutter_sdk.SyneriseConnector;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInitializer implements SyneriseModule {
    private static String sdkPluginVersion = "0.8.2";
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
            case "changeApiKey":
                changeApiKey(call, result);
                return;
        }
    }

    public void initSynerise(Application app, MethodCall call, MethodChannel.Result result) {
        if (isInitialized == false) {
            prepareDefaultSettings();
            Map dataFull = (Map) call.arguments;
            Map data = (Map) dataFull.get("initializationParameters");
            String requestValidationSalt = data.containsKey("requestValidationSalt") ? (String) data.get("requestValidationSalt") : null;
            initializeActionInjectorListener();
            Synerise.Builder builder = Synerise.Builder.with(app, (String) data.get("clientApiKey"), SyneriseConnector.getApplicationName(app))
                    .baseUrl(data.containsKey("baseUrl") ? (String) data.get("baseUrl") : null)
                    .syneriseDebugMode(data.containsKey("debugModeEnabled") ? (boolean) data.get("debugModeEnabled") : false)
                    .crashHandlingEnabled(data.containsKey("crashHandlingEnabled") ? (boolean) data.get("crashHandlingEnabled") : false)
                    .hostApplicationType(HostApplicationType.FLUTTER)
                    .hostApplicationSDKPluginVersion(sdkPluginVersion)
                    .pushRegistrationRequired(SyneriseNotifications.getPushNotificationsListener());
            if (requestValidationSalt != null) {
                builder.setRequestValidationSalt(requestValidationSalt);
            }
            builder.build();
            isInitialized = true;
            SyneriseInjector.registerListeners();
        }
        result.success(true);
    }

    public void changeApiKey(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String apiKey = null;

        if (data != null && data.containsKey("apiKey")) {
            apiKey = (String) data.get("apiKey");
        } else {
            result.error("apiKey missing", null, null);
            return;
        }

        Client.changeApiKey(apiKey);
        SyneriseModule.executeSuccessResult(true,result);
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