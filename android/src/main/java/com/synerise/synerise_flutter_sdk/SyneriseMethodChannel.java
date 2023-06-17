package com.synerise.synerise_flutter_sdk;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseMethodChannel {
    public static MethodChannel methodChannel;

    public static void configureChannel(FlutterEngine flutterEngine) {
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "synerise_dart_channel");
    }
}
