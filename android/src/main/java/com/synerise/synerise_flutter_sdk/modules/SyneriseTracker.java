package com.synerise.synerise_flutter_sdk.modules;

import com.synerise.sdk.event.Tracker;
import com.synerise.sdk.event.TrackerParams;
import com.synerise.sdk.event.model.CustomEvent;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseTracker implements SyneriseModule {

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "setCustomIdentifier":
                setCustomIdentifier(call);
                return;
            case "setCustomEmail":
                setCustomEmail(call);
                return;
            case "send":
                send(call);
                return;
            case "flush":
                flush(call);
                return;

        }
    }

    private void setCustomIdentifier(MethodCall call) {
        String customIdentifier = call.argument("customIdentifier");
        Tracker.setCustomIdentifier(customIdentifier);
    }

    private void setCustomEmail(MethodCall call) {
        String customEmail = call.argument("customEmail");
        Tracker.setCustomEmail(customEmail);
    }

    private void send(MethodCall call) {
        String type = call.argument("type");
        String action = call.argument("action");
        String label = call.argument("label");
        HashMap<String, Object> hashMapParams = call.argument("params");
        TrackerParams params = new TrackerParams.Builder()
                .addAll(hashMapParams)
                .build();
        if (type != null && action != null && label != null) {
            CustomEvent event = new CustomEvent(type, action, label, params);
            Tracker.send(event);
        }
    }

    private void flush(MethodCall call) {
        Tracker.flush();
    }
}
