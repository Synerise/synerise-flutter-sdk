package com.synerise.synerise_flutter_sdk.views;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.synerise.sdk.injector.inapp.ui.inline.InlineInAppView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class InlineInAppViewFactory extends PlatformViewFactory {
    public static final String VIEW_TYPE = "synerise_flutter_sdk/inline_in_app_view";

    private final BinaryMessenger binaryMessenger;

    public InlineInAppViewFactory(BinaryMessenger binaryMessenger) {
        super(StandardMessageCodec.INSTANCE);
        this.binaryMessenger = binaryMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int viewId, @Nullable Object args) {
        CreationParams creationParams = parseCreationParams(args);
        // A stale id (the view was already taken, e.g. after a remount or hot restart) simply falls
        // back to the regular placement-key path.
        InlineInAppView adoptedView = creationParams.adoptViewId != null
                ? InlineInAppViewRegistry.take(creationParams.adoptViewId)
                : null;
        return new InlineInAppPlatformView(context, binaryMessenger, viewId,
                creationParams.placementKey, creationParams.identifier, adoptedView);
    }

    @VisibleForTesting
    static CreationParams parseCreationParams(@Nullable Object args) {
        String placementKey = "";
        String identifier = null;
        String adoptViewId = null;
        if (args instanceof Map) {
            Map<?, ?> arguments = (Map<?, ?>) args;
            Object placementKeyArg = arguments.get("placementKey");
            if (placementKeyArg instanceof String) {
                placementKey = (String) placementKeyArg;
            }
            Object identifierArg = arguments.get("identifier");
            if (identifierArg instanceof String) {
                identifier = (String) identifierArg;
            }
            Object adoptViewIdArg = arguments.get("adoptViewId");
            if (adoptViewIdArg instanceof String) {
                adoptViewId = (String) adoptViewIdArg;
            }
        }
        return new CreationParams(placementKey, identifier, adoptViewId);
    }

    @VisibleForTesting
    static final class CreationParams {
        final String placementKey;
        final String identifier;
        final String adoptViewId;

        CreationParams(String placementKey, String identifier, String adoptViewId) {
            this.placementKey = placementKey;
            this.identifier = identifier;
            this.adoptViewId = adoptViewId;
        }
    }
}
