package com.synerise.synerise_flutter_sdk.modules.listeners;

import static com.synerise.synerise_flutter_sdk.SyneriseMethodChannel.methodChannel;

import android.util.Log;

import com.synerise.synerise_flutter_sdk.SyneriseMethodChannel;

import java.util.HashMap;
import java.util.Map;

public interface OnRegisterPushListener {

    OnRegisterPushListener INTERNAL_CALLBACK = new OnRegisterPushListener() {

        @Override
        public void onRegisterPushRequired() {
            Map<String, Object> map = new HashMap<>();
            SyneriseMethodChannel.delayedMethodCall(methodChannel, "Notifications#NotificationsListener#onRegistrationRequired", map, 1000);
        }
    };

    void onRegisterPushRequired();
}