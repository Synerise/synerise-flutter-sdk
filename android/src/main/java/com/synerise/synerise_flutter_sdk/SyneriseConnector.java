package com.synerise.synerise_flutter_sdk;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.synerise.synerise_flutter_sdk.modules.SyneriseClient;
import com.synerise.synerise_flutter_sdk.modules.SyneriseInitializer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SyneriseConnector implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    public Context context;
    private Activity activity;
    public static Application app;
    private static volatile boolean isCalled = false;
    private Gson gson = new Gson();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "synerise_flutter_sdk");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        this.app = (Application) context.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        String[] callMethodComponents = call.method.split("/");
        List<String> callMethodComponentsList = new ArrayList<String>(Arrays.asList(callMethodComponents));
        if (callMethodComponentsList.size() != 2) {
            return;
        }
        String callMethodModule = callMethodComponentsList.get(0);
        String calledMethod = callMethodComponentsList.get(1);
        SyneriseModule calledModule = handleModule(callMethodModule);
        if (calledModule == null) {
            System.out.println("no such module existing");
            return;
        }

        calledModule.handleMethodCall(call, result, calledMethod);
    }

    public static String getApplicationName(Context context) {
        ApplicationInfo applicationInfo = context.getApplicationInfo();
        int stringId = applicationInfo.labelRes;
        return stringId == 0 ? applicationInfo.nonLocalizedLabel.toString() : context.getString(stringId);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }

    private SyneriseModule handleModule(String callMethodModule) {
        SyneriseModule calledModule;
        switch (callMethodModule) {
            case "Synerise":
                calledModule = SyneriseInitializer.getInstance();
                return calledModule;
            case "Client":
                calledModule = SyneriseClient.getInstance();
                return calledModule;
        }
        return null;
    }
}


