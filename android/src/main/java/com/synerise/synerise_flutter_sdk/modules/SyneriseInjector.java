package com.synerise.synerise_flutter_sdk.modules;

import android.os.Handler;
import com.synerise.sdk.core.Synerise;
import com.synerise.sdk.core.utils.SystemUtils;
import com.synerise.sdk.injector.Injector;
import com.synerise.sdk.injector.callback.OnInjectorListener;
import com.synerise.sdk.injector.callback.SyneriseSource;
import com.synerise.sdk.injector.inapp.InAppCustomMethodCompletion;
import com.synerise.sdk.injector.inapp.InAppMessageData;
import com.synerise.sdk.injector.inapp.OnInAppListener;
import com.synerise.sdk.injector.ui.handler.InjectorActionHandler;
import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInjector implements SyneriseModule {

    private static final ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingInAppCustomMethodCompletions = new ConcurrentHashMap<>();

    @Override
        public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "closeInAppMessage":
                closeInAppMessage(call, result);
                return;
            case "handleOpenUrlBySDK":
                handleOpenUrlBySDK(call, result);
                return;
            case "handleDeepLinkBySDK":
                handleDeepLinkBySDK(call, result);
                return;
            case "setInAppContext":
                setInAppContext(call, result);
                return;
            case "notifyInAppContextChange":
                notifyInAppContextChange(call, result);
                return;
            case "resolveInAppCustomMethod":
                resolveInAppCustomMethod(call, result);
                return;
        }
    }

    public void closeInAppMessage(MethodCall call, MethodChannel.Result result) {
        String campaignHash = (String) call.arguments;
        Injector.closeInAppMessage(campaignHash);
    }

    public void handleOpenUrlBySDK(MethodCall call, MethodChannel.Result result) {
        String url = (String) call.arguments;
        SystemUtils.openURL(Synerise.getApplicationContext(), url);
    }

    public void handleDeepLinkBySDK(MethodCall call, MethodChannel.Result result) {
        String deepLink = (String) call.arguments;
        SystemUtils.openDeepLink(Synerise.getApplicationContext(), deepLink);
    }

    @SuppressWarnings("unchecked")
    public void setInAppContext(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> context = call.arguments != null ? (Map<String, Object>) call.arguments : new HashMap<>();
        Injector.setInAppContext(new HashMap<>(context));
    }

    public void notifyInAppContextChange(MethodCall call, MethodChannel.Result result) {
        Injector.notifyInAppContextChange();
    }

    @SuppressWarnings("unchecked")
    public void resolveInAppCustomMethod(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> arguments = call.arguments != null ? (Map<String, Object>) call.arguments : new HashMap<>();
        String callId = (String) arguments.get("callId");
        if (callId == null) {
            return;
        }

        boolean success = Boolean.TRUE.equals(arguments.get("success"));
        Object methodResult = arguments.get("result");
        String error = (String) arguments.get("error");

        InAppCustomMethodCompletion completion = pendingInAppCustomMethodCompletions.remove(callId);
        if (completion == null) {
            return;
        }

        if (success) {
            completion.success(methodResult);
        } else {
            completion.failure(error);
        }
    }

    public static void registerListeners() {
        registerInAppListener();
    }

    public static void registerInAppListener() {
        Injector.setOnInAppListener(new OnInAppListener() {
            @Override
            public boolean shouldShow(InAppMessageData inAppMessageData) {
                return true;
            }

            @Override
            public void onShown(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("data", createMapFromInAppMessageData(inAppMessageData));
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onPresent", map);
                });
            }

            @Override
            public void onDismissed(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("data", createMapFromInAppMessageData(inAppMessageData));
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onHide", map);
                });
            }

            @Override
            public void onHandledOpenUrl(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("url", inAppMessageData.getUrl());
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onOpenUrl", map);
                });
            }

            @Override
            public void onHandledOpenDeepLink(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("deepLink", inAppMessageData.getDeepLink());
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onDeepLink", map);
                });
            }

            @Override
            public HashMap<String, Object> onContextFromAppRequired(InAppMessageData inAppMessageData) {
                return null;
            }

            @Override
            public void onCustomAction(String identifier, HashMap<String, Object> params, InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("name", identifier);
                    map.put("parameters", params);
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onCustomAction", map);
                });
            }

            @Override
            public void onCustomMethod(String name, HashMap<String, Object> params, InAppMessageData inAppMessageData, InAppCustomMethodCompletion completion) {
                String callId = UUID.randomUUID().toString();
                pendingInAppCustomMethodCompletions.put(callId, completion);
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("callId", callId);
                    map.put("name", name);
                    map.put("parameters", params != null ? params : new HashMap<>());
                    map.put("data", data);
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onCustomMethod", map);
                });
            }
        });
    }

    public static void initializeActionInjectorListener() {
        InjectorActionHandler.setOnInjectorListener(new OnInjectorListener() {
            @Override
            public void onOpenUrl(SyneriseSource syneriseSource, String url) {
                Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    public void run() {
                        SyneriseModule.executeCallbackOnMainHandler(() -> {
                            Map<String, Object> map = new HashMap<>();
                            map.put("url", url);
                            map.put("source", syneriseSource.name());
                            if (SyneriseMethodChannel.methodChannel != null) {
                                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorListener#onOpenUrl", map);
                            }
                        });
                    }
                }, 1000);
            }

            @Override
            public void onDeepLink(SyneriseSource syneriseSource, String deepLink) {
                Handler handler = new Handler();
                handler.postDelayed(new Runnable() {

                    @Override
                    public void run() {
                        SyneriseModule.executeCallbackOnMainHandler(() -> {
                            Map<String, Object> map = new HashMap<>();
                            map.put("deepLink", deepLink);
                            map.put("source", syneriseSource.name());
                            if (SyneriseMethodChannel.methodChannel != null) {
                                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorListener#onDeepLink", map);
                            }
                        });
                    }
                }, 1000);
            }
        });
    }

    private static Map<String, Object> createMapFromInAppMessageData(InAppMessageData inAppMessageData) {
        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("campaignHash", inAppMessageData.getCampaignHash());
        dataMap.put("variantIdentifier", inAppMessageData.getVariantId());
        dataMap.put("additionalParameters", inAppMessageData.getAdditionalParameters());
        dataMap.put("isTest", Boolean.TRUE.equals(inAppMessageData.getTest()));
        return dataMap;
    }
}
