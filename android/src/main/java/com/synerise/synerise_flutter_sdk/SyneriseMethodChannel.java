package com.synerise.synerise_flutter_sdk;

import android.os.Handler;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseMethodChannel {

    public static final String REVERSE_CHANNEL_NAME = "synerise_dart_channel";

    public static MethodChannel methodChannel;

    /** Retained so integrations that still call it from MainActivity keep working; the plugin now configures the channel itself. */
    public static void configureChannel(FlutterEngine flutterEngine) {
        bindChannel(createChannel(flutterEngine.getDartExecutor().getBinaryMessenger()));
    }

    static MethodChannel createChannel(BinaryMessenger binaryMessenger) {
        return new MethodChannel(binaryMessenger, REVERSE_CHANNEL_NAME);
    }

    static void bindChannel(MethodChannel channelToBind) {
        methodChannel = channelToBind;
    }

    static void bindChannelIfNoneBound(MethodChannel channelToBind) {
        if (methodChannel == null) {
            methodChannel = channelToBind;
        }
    }

    static void unbindChannel(MethodChannel channelToUnbind) {
        if (methodChannel == channelToUnbind) {
            methodChannel = null;
        }
    }

    public static boolean isChannelAttached() {
        return methodChannel != null;
    }

    /** Drops the call when the Flutter engine is already detached, instead of throwing on a null channel. */
    public static void invokeMethodIfChannelAttached(String methodName, Object arguments) {
        MethodChannel channelToInvoke = methodChannel;
        if (channelToInvoke != null) {
            channelToInvoke.invokeMethod(methodName, arguments);
        }
    }

    public static void delayedMethodCall(MethodChannel methodChannel, String methodName, Object arguments, long delayMs) {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (methodChannel != null) {
                    methodChannel.invokeMethod(methodName, arguments);
                }
            }
        }, delayMs);
    }
}
