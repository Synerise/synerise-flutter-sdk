package com.synerise.synerise_flutter_sdk.modules;

import com.synerise.sdk.client.Client;
import com.synerise.sdk.core.listeners.DataActionListener;
import com.synerise.sdk.core.listeners.OnRegisterForPushListener;
import com.synerise.sdk.core.net.IApiCall;
import com.synerise.sdk.error.ApiError;
import com.synerise.sdk.injector.Injector;
import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseNotifications implements SyneriseModule {
    private IApiCall registerForNotificationCall;
    private static ArrayList<Map<String, String>> dataToSend = new ArrayList<>();
    private static ArrayList<String> tokensToSend = new ArrayList<>();
    protected static OnRegisterForPushListener registerNativeForPushListener;

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "registerForNotifications":
                registerForNotifications(call, result);
                return;
            case "handleNotification":
                handleNotification(call, result);
                return;
            case "isSyneriseNotification":
                isSyneriseNotification(call, result);
                return;
            case "isSyneriseSimplePush":
                isSyneriseSimplePush(call, result);
                return;
            case "isSyneriseBanner":
                isSyneriseBanner(call, result);
                return;
            case "isSilentCommand":
                isSilentCommand(call, result);
                return;
            case "isSilentSDKCommand":
                isSilentSDKCommand(call, result);
                return;
        }
    }

    private void registerForNotifications(MethodCall call, MethodChannel.Result result) {
        String registrationToken = call.argument("registrationToken");
        Boolean mobileAgreement = call.argument("mobileAgreement");

        if (mobileAgreement != null) {
            registerForNotificationCall = Client.registerForPush(registrationToken, mobileAgreement);
            registerForNotificationCall.execute(() ->
                            SyneriseModule.executeSuccessResult(true, result),
                    (DataActionListener<ApiError>) apiError ->
                            SyneriseModule.executeFailureResult(apiError, result));
        } else {
            registerForNotificationCall = Client.registerForPush(registrationToken);
            registerForNotificationCall.execute(() ->
                            SyneriseModule.executeSuccessResult(true, result),
                    (DataActionListener<ApiError>) apiError ->
                            SyneriseModule.executeFailureResult(apiError, result));
        }
    }

    private void handleNotification(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);

        String content = (String) dataMap.get("content");
        if (content != null) {
            String newContent = content.replace("\"priority\":\"high\"","\"priority\":\"HIGH\"");
            dataMap.put("content", newContent);
        }
        Boolean handlePushPayload = Injector.handlePushPayload(dataMap);

        SyneriseModule.executeSuccessResult(handlePushPayload, result);
    }

    public void isSyneriseNotification(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);
        boolean isSynerisePush = Injector.isSynerisePush(dataMap);
        SyneriseModule.executeSuccessResult(isSynerisePush, result);
    }

    public void isSyneriseSimplePush(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);
        boolean isSyneriseSimplePush = Injector.isSyneriseSimplePush(dataMap);
        SyneriseModule.executeSuccessResult(isSyneriseSimplePush, result);
    }

    public void isSyneriseBanner(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);
        boolean isSyneriseBanner = Injector.isSyneriseBanner(dataMap);
        SyneriseModule.executeSuccessResult(isSyneriseBanner, result);
    }

    public void isSilentCommand(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);
        boolean isSilentCommand = Injector.isSilentCommand(dataMap);
        SyneriseModule.executeSuccessResult(isSilentCommand, result);
    }

    public void isSilentSDKCommand(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, String> dataMap = notificationMapper(notificationMap);
        boolean isSilentSDKCommand = Injector.isSilentCommandSdk(dataMap);
        SyneriseModule.executeSuccessResult(isSilentSDKCommand, result);
    }

    public static OnRegisterForPushListener getPushNotificationsListener() {
        Map<String, Object> map = new HashMap<>();
        registerNativeForPushListener = () -> SyneriseMethodChannel.methodChannel.invokeMethod("Notifications#NotificationsListener#onRegistrationRequired", map);
        return registerNativeForPushListener;
    }

    private Map<String, String> notificationMapper(Map pushPayload) {
        Map<String, Object> notificationMap = (Map<String, Object>) pushPayload.get("notification");
        Map<String, String> dataMapSerialized = (Map<String, String>) notificationMap.get("data");
        return dataMapSerialized;
    }
}
