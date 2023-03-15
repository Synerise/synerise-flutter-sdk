package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

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
                handleNotification(call,result);
                return;
        }
    }

    private void registerForNotifications(MethodCall call, MethodChannel.Result result) {
        String registrationToken = call.argument("registrationToken");
        boolean mobileAgreement = call.argument("mobileAgreement");
        registerForNotificationCall = Client.registerForPush(registrationToken, mobileAgreement);
        registerForNotificationCall.execute(() ->
                        SyneriseModule.executeSuccessResult(null, result),
                (DataActionListener<ApiError>) apiError ->
                        SyneriseModule.executeFailureResult(apiError, result));
    }

    private void handleNotification(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> notificationMap = (Map) call.arguments;
        Map<String, Object> notificationContentMap = (Map<String, Object>) notificationMap.get("notification");
        Map<String, String> dataMap = (Map<String, String>) notificationContentMap.get("data");
        Boolean handlePushPayload = Injector.handlePushPayload(dataMap);
        SyneriseModule.executeSuccessResult(handlePushPayload, result);
    }

    public static OnRegisterForPushListener getPushNotificationsListener() {
        Map<String, Object> map = new HashMap<>();
        registerNativeForPushListener = () -> SyneriseMethodChannel.methodChannel.invokeMethod("Notifications#NotificationsListener#onRegistrationRequired",map);
        return registerNativeForPushListener;
        }
}
