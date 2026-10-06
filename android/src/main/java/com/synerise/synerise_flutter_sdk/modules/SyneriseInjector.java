package com.synerise.synerise_flutter_sdk.modules;

import android.os.Handler;

import com.synerise.sdk.core.Synerise;
import com.synerise.sdk.core.utils.SystemUtils;
import com.synerise.sdk.injector.Injector;
import androidx.annotation.VisibleForTesting;
import com.synerise.sdk.injector.callback.OnInjectorListener;
import com.synerise.sdk.injector.callback.SyneriseSource;
import com.synerise.sdk.injector.ui.handler.InjectorActionHandler;
import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseInjector implements SyneriseModule {
    private final SyneriseInAppManager inAppManager = new SyneriseInAppManager();

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "closeInAppMessage":
                inAppManager.closeInAppMessage(call, result);
                return;
            case "handleOpenUrlBySDK":
                handleOpenUrlBySDK(call, result);
                return;
            case "handleDeepLinkBySDK":
                handleDeepLinkBySDK(call, result);
                return;
            case "setInlineInAppListenerEnabled":
                inAppManager.setInlineInAppListenerEnabled(call, result);
                return;
            case "removeInlineInAppListener":
                inAppManager.removeInlineInAppListener(call, result);
                return;
            case "resolveInlineCustomMethod":
                inAppManager.resolveInlineCustomMethod(call, result);
                return;
            case "resolveInAppCustomMethod":
                inAppManager.resolveInAppCustomMethod(call, result);
                return;
            case "setInAppContext":
                setInAppContext(call, result);
                return;
            case "notifyInAppContextChange":
                notifyInAppContextChange(call, result);
                return;
        }
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

    /** Both in-app types (overlay and inline) are bridged by {@link SyneriseInAppManager}. */
    public static void registerListeners() {
        SyneriseInAppManager.registerListeners();
    }

    public static void initializeActionInjectorListener() {
        InjectorActionHandler.setOnInjectorListener(new OnInjectorListener() {
            @Override
            public void onOpenUrl(SyneriseSource syneriseSource, String url) {
                Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    public void run() {
                        SyneriseModule.executeCallbackOnMainHandler(() -> {
                            SyneriseMethodChannel.invokeMethodIfChannelAttached(
                                    "Injector#InjectorListener#onOpenUrl",
                                    buildActionPayload("url", url, syneriseSource));
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
                            SyneriseMethodChannel.invokeMethodIfChannelAttached(
                                    "Injector#InjectorListener#onDeepLink",
                                    buildActionPayload("deepLink", deepLink, syneriseSource));
                        });
                    }
                }, 1000);
            }
        });
    }

    /** The source is sent as its native enum name; SyneriseSource.fromString in Dart matches on it. */
    @VisibleForTesting
    static Map<String, Object> buildActionPayload(String targetKey, String target, SyneriseSource source) {
        Map<String, Object> payload = new HashMap<>();
        payload.put(targetKey, target);
        payload.put("source", source.name());
        return payload;
    }
}
