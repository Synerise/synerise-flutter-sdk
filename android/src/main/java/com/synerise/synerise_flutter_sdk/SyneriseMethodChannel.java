package com.synerise.synerise_flutter_sdk;

import android.os.Handler;
import android.util.Log;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseMethodChannel {
    public static MethodChannel methodChannel;

    public static void configureChannel(FlutterEngine flutterEngine) {
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "synerise_dart_channel");
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