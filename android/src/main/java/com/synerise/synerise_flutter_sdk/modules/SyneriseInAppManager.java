package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

import androidx.annotation.VisibleForTesting;

import com.synerise.sdk.injector.Injector;
import com.synerise.sdk.injector.inapp.InAppCustomMethodCompletion;
import com.synerise.sdk.injector.inapp.InAppMessageData;
import com.synerise.sdk.injector.inapp.OnInAppListener;
import com.synerise.sdk.injector.inapp.inline.InlineInAppMessageData;
import com.synerise.sdk.injector.inapp.inline.OnInlineInAppListener;
import com.synerise.sdk.injector.inapp.ui.inline.InlineInAppView;
import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;
import com.synerise.synerise_flutter_sdk.SyneriseModule;
import com.synerise.synerise_flutter_sdk.views.InlineInAppViewRegistry;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInAppManager {
    private static final String TAG = "SyneriseInAppManager";
    private static final String IN_APP_LISTENER = "Injector#InjectorInAppMessageListener#";
    private static final String INLINE_IN_APP_LISTENER = "Injector#InjectorInlineInAppMessageListener#";

    private static final String JINJAVA_CONTEXT_KEY = "jinjavaContext";
    private static final String CHANNEL_NOT_ATTACHED_ERROR = "Flutter method channel is not attached.";

    private static final ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingInlineCustomMethodCompletions = new ConcurrentHashMap<>();
    private static final ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingInAppCustomMethodCompletions = new ConcurrentHashMap<>();

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
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onPresent", map);
                });
            }

            @Override
            public void onDismissed(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("data", createMapFromInAppMessageData(inAppMessageData));
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onHide", map);
                });
            }

            @Override
            public void onHandledOpenUrl(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("url", inAppMessageData.getUrl());
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onOpenUrl", map);
                });
            }

            @Override
            public void onHandledOpenDeepLink(InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("deepLink", inAppMessageData.getDeepLink());
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onDeepLink", map);
                });
            }

            @Override
            public HashMap<String, Object> onContextFromAppRequired(InAppMessageData inAppMessageData) {
                return jinjavaContextFromApp();
            }

            @Override
            public void onCustomAction(String identifier, HashMap<String, Object> params, InAppMessageData inAppMessageData) {
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    Map<String, Object> map = new HashMap<>();
                    Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                    map.put("data", data);
                    map.put("name", identifier);
                    map.put("parameters", params);
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onCustomAction", map);
                });
            }

            @Override
            public void onCustomMethod(String name, HashMap<String, Object> params, InAppMessageData inAppMessageData, InAppCustomMethodCompletion completion) {
                String callId = UUID.randomUUID().toString();
                pendingInAppCustomMethodCompletions.put(callId, completion);
                SyneriseModule.executeCallbackOnMainHandler(() -> {
                    if (!SyneriseMethodChannel.isChannelAttached()) {
                        resolveInAppCustomMethod(callId, false, null, CHANNEL_NOT_ATTACHED_ERROR);
                        return;
                    }
                    Map<String, Object> map = new HashMap<>();
                    map.put("callId", callId);
                    map.put("name", name);
                    map.put("parameters", params != null ? params : new HashMap<>());
                    map.put("data", createMapFromInAppMessageData(inAppMessageData));
                    SyneriseMethodChannel.invokeMethodIfChannelAttached(IN_APP_LISTENER + "onCustomMethod", map);
                });
            }
        });
    }

    public void closeInAppMessage(MethodCall call, MethodChannel.Result result) {
        String campaignHash = (String) call.arguments;
        Injector.closeInAppMessage(campaignHash);
    }

    public void setInlineInAppListenerEnabled(MethodCall call, MethodChannel.Result result) {
        initializeInlineInAppListener();
        result.success(null);
    }

    public void removeInlineInAppListener(MethodCall call, MethodChannel.Result result) {
        Injector.removeInlineInAppListener();
        failPendingInlineCustomMethodCompletions();
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    public void resolveInAppCustomMethod(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> arguments = call.arguments != null ? (Map<String, Object>) call.arguments : new HashMap<>();
        String callId = (String) arguments.get("callId");
        boolean success = Boolean.TRUE.equals(arguments.get("success"));
        resolveInAppCustomMethod(callId, success, arguments.get("result"), (String) arguments.get("error"));
        result.success(null);
    }

    /** Overlay results keep their JS type (string, number, boolean, list, map), matching iOS. */
    @VisibleForTesting
    static void resolveInAppCustomMethod(String callId, boolean success, Object result, String error) {
        if (callId == null) {
            return;
        }
        InAppCustomMethodCompletion completion = pendingInAppCustomMethodCompletions.remove(callId);
        if (completion == null) {
            return;
        }
        if (success) {
            completion.success(result);
        } else {
            completion.failure(error != null ? error : "Unknown error.");
        }
    }

    @VisibleForTesting
    static ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingInAppCustomMethodCompletions() {
        return pendingInAppCustomMethodCompletions;
    }

    public void resolveInlineCustomMethod(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        String callId = (String) arguments.get("callId");
        boolean success = Boolean.TRUE.equals(arguments.get("success"));
        resolveInlineCustomMethod(callId, success, arguments.get("result"), (String) arguments.get("error"));
        result.success(null);
    }

    @VisibleForTesting
    static void resolveInlineCustomMethod(String callId, boolean success, Object result, String error) {
        InAppCustomMethodCompletion completion = pendingInlineCustomMethodCompletions.remove(callId);
        if (completion == null) {
            return;
        }
        if (success) {
            completion.success(result);
        } else {
            completion.failure(error);
        }
    }

    @VisibleForTesting
    static ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingInlineCustomMethodCompletions() {
        return pendingInlineCustomMethodCompletions;
    }

    @VisibleForTesting
    static void failPendingInlineCustomMethodCompletions() {
        for (String callId : pendingInlineCustomMethodCompletions.keySet()) {
            InAppCustomMethodCompletion completion = pendingInlineCustomMethodCompletions.remove(callId);
            if (completion == null) {
                continue;
            }
            try {
                completion.failure("LISTENER_REMOVED");
            } catch (Exception exception) {
                Log.e(TAG, "Failed to fail pending inline custom method completion", exception);
            }
        }
    }

    private static void initializeInlineInAppListener() {
        Injector.setOnInlineInAppListener(new OnInlineInAppListener() {
            @Override
            public void onInlineInAppAvailable(InlineInAppView view, InlineInAppMessageData data) {
                String viewId = InlineInAppViewRegistry.retain(data.getPlacementKey(), view);
                emitInlineInAppAvailable(data, viewId);
            }

            @Override
            public Map<String, Object> onContextFromAppRequired(InlineInAppMessageData data) {
                return jinjavaContextFromApp();
            }

            @Override
            public void onOpenedUrl(InlineInAppMessageData data, String url) {
                onInlineOpenedUrl(data, url);
            }

            @Override
            public void onOpenedDeepLink(InlineInAppMessageData data, String deepLink) {
                onInlineOpenedDeepLink(data, deepLink);
            }

            @Override
            public void onCustomAction(InlineInAppMessageData data, String name, Map<String, Object> params) {
                onInlineCustomAction(data, name, params);
            }

            @Override
            public void onCustomMethod(String name, HashMap<String, Object> params, InlineInAppMessageData data, InAppCustomMethodCompletion completion) {
                onInlineCustomMethod(name, params, data, completion);
            }
        });
    }

    /** The SDK-rendered view stays retained in the registry under {@code viewId} until Dart mounts it. */
    private static void emitInlineInAppAvailable(InlineInAppMessageData data, String viewId) {
        SyneriseModule.executeCallbackOnMainHandler(() -> {
            Map<String, Object> map = new HashMap<>();
            map.put("data", createMapFromInlineInAppMessageData(data));
            map.put("viewId", viewId);
            SyneriseMethodChannel.invokeMethodIfChannelAttached(INLINE_IN_APP_LISTENER + "onInlineInAppAvailable", map);
        });
    }

    private static void onInlineOpenedUrl(InlineInAppMessageData data, String url) {
        SyneriseModule.executeCallbackOnMainHandler(() -> {
            Map<String, Object> map = new HashMap<>();
            map.put("data", createMapFromInlineInAppMessageData(data));
            map.put("url", url);
            SyneriseMethodChannel.invokeMethodIfChannelAttached(INLINE_IN_APP_LISTENER + "onOpenUrl", map);
        });
    }

    private static void onInlineOpenedDeepLink(InlineInAppMessageData data, String deepLink) {
        SyneriseModule.executeCallbackOnMainHandler(() -> {
            Map<String, Object> map = new HashMap<>();
            map.put("data", createMapFromInlineInAppMessageData(data));
            map.put("deepLink", deepLink);
            SyneriseMethodChannel.invokeMethodIfChannelAttached(INLINE_IN_APP_LISTENER + "onDeepLink", map);
        });
    }

    private static void onInlineCustomAction(InlineInAppMessageData data, String name, Map<String, Object> params) {
        SyneriseModule.executeCallbackOnMainHandler(() -> {
            Map<String, Object> map = new HashMap<>();
            map.put("data", createMapFromInlineInAppMessageData(data));
            map.put("name", name);
            map.put("parameters", params);
            SyneriseMethodChannel.invokeMethodIfChannelAttached(INLINE_IN_APP_LISTENER + "onCustomAction", map);
        });
    }

    private static void onInlineCustomMethod(String name, HashMap<String, Object> params, InlineInAppMessageData data, InAppCustomMethodCompletion completion) {
        String callId = UUID.randomUUID().toString();
        pendingInlineCustomMethodCompletions.put(callId, completion);
        SyneriseModule.executeCallbackOnMainHandler(() -> {
            if (!SyneriseMethodChannel.isChannelAttached()) {
                resolveInlineCustomMethod(callId, false, null, CHANNEL_NOT_ATTACHED_ERROR);
                return;
            }
            Map<String, Object> map = new HashMap<>();
            map.put("callId", callId);
            map.put("name", name);
            map.put("parameters", params);
            map.put("data", createMapFromInlineInAppMessageData(data));
            SyneriseMethodChannel.invokeMethodIfChannelAttached(INLINE_IN_APP_LISTENER + "onCustomMethod", map);
        });
    }

    /**
     * The app-owned context the backend evaluates on render, read straight from the context the app
     * already mirrors into the SDK through {@code Injector.setInAppContext}. Answering synchronously
     * keeps the SDK's render thread from ever waiting on Dart.
     */
    static HashMap<String, Object> jinjavaContextFromApp() {
        return jinjavaContextFrom(Injector.inAppContext);
    }

    @VisibleForTesting
    @SuppressWarnings("unchecked")
    static HashMap<String, Object> jinjavaContextFrom(Map<String, Object> inAppContext) {
        Object jinjavaContext = inAppContext != null ? inAppContext.get(JINJAVA_CONTEXT_KEY) : null;
        if (jinjavaContext instanceof Map) {
            return new HashMap<>((Map<String, Object>) jinjavaContext);
        }
        return new HashMap<>();
    }

    @VisibleForTesting
    static Map<String, Object> createMapFromInlineInAppMessageData(InlineInAppMessageData data) {
        Map<String, Object> dataMap = new HashMap<>();
        if (data == null) {
            return dataMap;
        }
        dataMap.put("campaignHash", data.getCampaignHash());
        dataMap.put("variantIdentifier", data.getVariantId());
        dataMap.put("placementKey", data.getPlacementKey());
        Map<String, Object> additionalParameters = data.getAdditionalParameters();
        dataMap.put("additionalParameters", additionalParameters != null ? additionalParameters : new HashMap<>());
        dataMap.put("isTest", data.isTest());
        return dataMap;
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
