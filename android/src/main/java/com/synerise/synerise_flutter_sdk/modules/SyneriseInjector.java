package com.synerise.synerise_flutter_sdk.modules;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.synerise.sdk.error.ApiError;
import com.synerise.sdk.injector.Injector;

import com.synerise.sdk.injector.callback.InjectorSource;
import com.synerise.sdk.injector.callback.OnBannerListener;
import com.synerise.sdk.injector.callback.OnInjectorListener;
import com.synerise.sdk.injector.callback.OnWalkthroughListener;
import com.synerise.sdk.injector.inapp.InAppMessageData;
import com.synerise.sdk.injector.inapp.OnInAppListener;
import com.synerise.sdk.injector.net.model.inject.walkthrough.WalkthroughResponse;
import com.synerise.sdk.injector.net.model.push.banner.TemplateBanner;
import com.synerise.sdk.injector.ui.handler.InjectorActionHandler;
import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInjector implements SyneriseModule {
    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {

    }

    public static void registerListeners() {
        registerBannerListener();
        registerInAppListener();
        registerWalkthroughListener();
        initializeActionInjectorListener();
    }

    public static void registerInAppListener() {
        Injector.setOnInAppListener(new OnInAppListener() {
            @Override
            public boolean shouldShow(InAppMessageData inAppMessageData) {
                return true;
            }

            @Override
            public void onShown(InAppMessageData inAppMessageData) {
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onPresent", createMapFromInAppMessageData(inAppMessageData));
            }

            @Override
            public void onDismissed(InAppMessageData inAppMessageData) {
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onHide", createMapFromInAppMessageData(inAppMessageData));
            }

            @Override
            public void onHandledOpenUrl(InAppMessageData inAppMessageData) {
                Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                data.put("url", inAppMessageData.getUrl());
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onOpenUrl", data);
            }

            @Override
            public void onHandledOpenDeepLink(InAppMessageData inAppMessageData) {
                Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                data.put("deepLink", inAppMessageData.getDeepLink());
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onDeepLink",data);
            }

            @Override
            public HashMap<String, Object> onContextFromAppRequired(InAppMessageData inAppMessageData) {
                return null;
            }

            @Override
            public void onCustomAction(String identifier, HashMap<String, Object> params, InAppMessageData inAppMessageData) {
                Map<String, Object> data = createMapFromInAppMessageData(inAppMessageData);
                data.put("name", identifier);
                data.put("parameters", params);
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorInAppMessageListener#onCustomAction",data);
            }
        });
    }

    public static void registerBannerListener() {
        Injector.setOnBannerListener(new OnBannerListener() {
            @Override
            public boolean shouldPresent(TemplateBanner banner) {
                return super.shouldPresent(banner);
            }

            @Override
            public void onPresented() {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorBannerListener#onPresent", map);
                super.onPresented();
            }

            @Override
            public void onClosed() {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorBannerListener#onHide",map);
                super.onClosed();
            }
        });
    }

    public static void initializeActionInjectorListener() {
        InjectorActionHandler.setOnInjectorListener(new OnInjectorListener() {
            @Override
            public boolean onOpenUrl(InjectorSource injectorSource, String url) {
                Handler mainHandler = new Handler(Looper.getMainLooper());
                Runnable myRunnable = () -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("url", url);
                    SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorListener#onOpenUrl", map);
                };
                mainHandler.post(myRunnable);
                return injectorSource != InjectorSource.WALKTHROUGH;
            }

            @Override
            public boolean onDeepLink(InjectorSource injectorSource, String deepLink) {
                Map<String, Object> map = new HashMap<>();
                map.put("deepLink", deepLink);
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorListener#onDeepLink", map);
                return injectorSource != InjectorSource.WALKTHROUGH;
            }
        });
    }

    public static void registerWalkthroughListener() {
        Injector.setOnWalkthroughListener(new OnWalkthroughListener() {
            @Override
            public void onLoadingError(ApiError error) {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorWalkthroughListener#onLoadingError",map);
                super.onLoadingError(error);
            }

            @Override
            public void onLoaded(WalkthroughResponse walkthrough) {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorWalkthroughListener#onLoad",map);
                super.onLoaded(walkthrough);
            }

            @Override
            public void onPresented() {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorWalkthroughListener#onPresent",map);
                super.onPresented();
            }

            @Override
            public void onClosed() {
                Map<String, Object> map = new HashMap<>();
                SyneriseMethodChannel.methodChannel.invokeMethod("Injector#InjectorWalkthroughListener#onHide",map);
                super.onClosed();
            }
        });
    }

    private static Map<String, Object> createMapFromInAppMessageData(InAppMessageData inAppMessageData) {
        Map<String, Object> map = new HashMap<>();
        map.put("campaignHash", inAppMessageData.getCampaignHash());
        map.put("variantIdentifier", inAppMessageData.getVariantId());
        map.put("additionalParameters", inAppMessageData.getAdditionalParameters());
        map.put("isTest", inAppMessageData.getTest());
        return map;
    }
}
