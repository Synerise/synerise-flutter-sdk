package com.synerise.synerise_flutter_sdk.views;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.synerise.sdk.injector.Injector;
import com.synerise.sdk.injector.inapp.inline.InlineInAppMessageData;
import com.synerise.sdk.injector.inapp.inline.InlineInAppSize;
import com.synerise.sdk.injector.inapp.inline.OnInlineInAppViewListener;
import com.synerise.sdk.injector.inapp.ui.inline.InlineInAppView;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMethodCodec;
import io.flutter.plugin.platform.PlatformView;

public class InlineInAppPlatformView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String TAG = "InlineInAppPlatformView";
    private static final String CHANNEL_NAME_PREFIX = "synerise_flutter_sdk/inline_in_app_view/";

    private final FrameLayout containerView;
    private final Context context;
    private final boolean adopted;
    private final MethodChannel methodChannel;
    private String placementKey;
    private String identifier;
    @Nullable
    private InlineInAppView view;

    private final InlineInAppViewCommands commands = new InlineInAppViewCommands() {
        @Override
        public void render() {
            createInlineViewIfPossible();
            if (view != null) {
                view.render();
            }
        }

        @Override
        public void release() {
            if (view != null) {
                view.release();
            }
        }

        /** An adopted view already holds its campaign; re-applying a placement key would destroy it. */
        @Override
        public void setPlacementKey(String newPlacementKey) {
            placementKey = newPlacementKey;
            if (!adopted && view != null) {
                view.setPlacementKey(newPlacementKey);
            }
        }

        @Override
        public void setIdentifier(String newIdentifier) {
            identifier = newIdentifier;
            if (view != null) {
                view.setIdentifier(newIdentifier);
            }
        }

        @Override
        public void clearViewListener() {
            if (view != null) {
                view.setOnInlineInAppViewListener(null);
            }
        }

        @Override
        public boolean isRendered() {
            return view != null && view.isRendered();
        }

        @Override
        public Map<String, Object> getData() {
            InlineInAppMessageData data = view != null ? view.getData() : null;
            return data != null ? createMapFromInlineInAppMessageData(data) : null;
        }
    };

    /**
     * Hosts either a freshly created SDK view for {@code placementKey} or, when {@code adoptedView}
     * is given, the already rendered view the SDK announced through the global inline listener.
     */
    public InlineInAppPlatformView(Context context, BinaryMessenger binaryMessenger, int viewId,
                                   String placementKey, String identifier, @Nullable InlineInAppView adoptedView) {
        this.context = context;
        this.placementKey = resolvePlacementKey(placementKey);
        this.identifier = identifier;
        this.containerView = new FrameLayout(context);
        this.methodChannel = new MethodChannel(binaryMessenger, CHANNEL_NAME_PREFIX + viewId, StandardMethodCodec.INSTANCE);
        this.methodChannel.setMethodCallHandler(this);

        if (adoptedView != null) {
            detachFromCurrentParent(adoptedView);
            this.adopted = true;
            attachInlineView(adoptedView);
        } else {
            this.adopted = false;
            createInlineViewIfPossible();
        }
    }

    /**
     * A view the SDK cannot produce leaves an empty container instead of propagating the failure, and
     * render() retries the creation later. An empty placement key still reaches the SDK.
     */
    private void createInlineViewIfPossible() {
        if (view != null) {
            return;
        }
        InlineInAppView createdView = createSdkInlineView();
        if (createdView == null) {
            return;
        }
        attachInlineView(createdView);
    }

    @Nullable
    private InlineInAppView createSdkInlineView() {
        try {
            return Injector.createInlineInAppView(context, placementKey);
        } catch (Exception exception) {
            Log.e(TAG, "cannot create inline view for key=" + placementKey
                    + ", leaving an empty container: " + exception.getMessage());
            return null;
        }
    }

    private void attachInlineView(InlineInAppView inlineView) {
        this.view = inlineView;
        if (identifier != null) {
            inlineView.setIdentifier(identifier);
        }
        inlineView.setOnInlineInAppViewListener(createViewListener());
        containerView.addView(inlineView, new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
    }

    @Override
    public View getView() {
        return containerView;
    }

    @Override
    public void dispose() {
        disposeView(commands, () -> methodChannel.setMethodCallHandler(null));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        result.success(dispatchCommand(call.method, call.arguments, commands));
    }

    @VisibleForTesting
    static String resolvePlacementKey(String placementKey) {
        return placementKey != null ? placementKey : "";
    }

    /** Runs a command from Dart; fire-and-forget commands yield {@code null}, queries yield their value. */
    @VisibleForTesting
    @Nullable
    static Object dispatchCommand(String command, Object arguments, InlineInAppViewCommands commands) {
        if (command == null) {
            return null;
        }
        switch (command) {
            case "render":
                commands.render();
                return null;
            case "release":
                commands.release();
                return null;
            case "setPlacementKey":
                commands.setPlacementKey((String) arguments);
                return null;
            case "setIdentifier":
                commands.setIdentifier((String) arguments);
                return null;
            case "isRendered":
                return commands.isRendered();
            case "getData":
                return commands.getData();
            default:
                return null;
        }
    }

    @VisibleForTesting
    static void disposeView(InlineInAppViewCommands commands, Runnable clearChannelHandler) {
        commands.release();
        commands.clearViewListener();
        clearChannelHandler.run();
    }

    private static void detachFromCurrentParent(@NonNull InlineInAppView view) {
        if (view.getParent() instanceof ViewGroup) {
            ((ViewGroup) view.getParent()).removeView(view);
        }
    }

    @VisibleForTesting
    interface InlineInAppViewCommands {
        void render();

        void release();

        void setPlacementKey(String placementKey);

        void setIdentifier(String identifier);

        void clearViewListener();

        boolean isRendered();

        @Nullable
        Map<String, Object> getData();
    }

    private OnInlineInAppViewListener createViewListener() {
        return new OnInlineInAppViewListener() {
            @Override
            public void onProcessingStarted() {
                invokeOnMainThread("onProcessingStarted", null);
            }

            @Override
            public void onLoaded(InlineInAppMessageData data) {
                invokeOnMainThread("onLoaded", buildDataPayload(data));
            }

            @Override
            public void onUpdated(InlineInAppMessageData data) {
                invokeOnMainThread("onUpdated", buildDataPayload(data));
            }

            @Override
            public void onFailed(InlineInAppMessageData data, String error) {
                Map<String, Object> payload = buildDataPayload(data);
                payload.put("error", error);
                invokeOnMainThread("onFailed", payload);
            }

            @Override
            public void onRemove(InlineInAppMessageData data) {
                invokeOnMainThread("onRemove", buildDataPayload(data));
            }

            @Override
            public void onSizeChanged(InlineInAppMessageData data, InlineInAppSize size) {
                invokeOnMainThread("onSizeChanged", putSizeInto(buildDataPayload(data), size));
            }
        };
    }

    private void invokeOnMainThread(String method, Object arguments) {
        SyneriseModule.executeCallbackOnMainHandler(() -> methodChannel.invokeMethod(method, arguments));
    }

    /** Wire names must match InlineInAppSize.fromMap on the Dart side; a rename here zeroes the values there. */
    @VisibleForTesting
    static Map<String, Object> putSizeInto(Map<String, Object> payload, InlineInAppSize size) {
        payload.put("widthPx", size.getWidthPx());
        payload.put("heightPx", size.getHeightPx());
        payload.put("width", (double) size.getWidthDp());
        payload.put("height", (double) size.getHeightDp());
        payload.put("widthScreenRatio", (double) size.getWidthScreenRatio());
        payload.put("heightScreenRatio", (double) size.getHeightScreenRatio());
        return payload;
    }

    private Map<String, Object> buildDataPayload(InlineInAppMessageData data) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("data", createMapFromInlineInAppMessageData(data));
        return payload;
    }

    private static Map<String, Object> createMapFromInlineInAppMessageData(InlineInAppMessageData data) {
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
}
