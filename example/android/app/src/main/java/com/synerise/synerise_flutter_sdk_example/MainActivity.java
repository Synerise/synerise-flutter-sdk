package com.synerise.synerise_flutter_sdk_example;

import androidx.annotation.NonNull;

import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        SyneriseMethodChannel.configureChannel(flutterEngine);
    }
}
