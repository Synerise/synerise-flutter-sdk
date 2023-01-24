package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

import com.synerise.sdk.client.Client;
import com.synerise.sdk.client.model.ClientIdentityProvider;
import com.synerise.sdk.client.model.client.Agreements;
import com.synerise.sdk.client.model.client.Attributes;
import com.synerise.sdk.client.model.client.RegisterClient;
import com.synerise.sdk.core.listeners.DataActionListener;
import com.synerise.sdk.core.net.IApiCall;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.sdk.core.types.model.Sex;
import com.synerise.sdk.core.types.model.Token;
import com.synerise.sdk.error.ApiError;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public final class SyneriseClient implements SyneriseModule {

    private static SyneriseClient instance;
    public static IApiCall signInCall;
    public static IApiCall signUpCall;
    private static IDataApiCall<Token> retrieveTokenCall;
    private static final String TAG = "FlutterSyneriseSdk.Cli";

    private SyneriseClient() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "signIn":
                signIn(call, result);
                return;
            case "registerAccount":
                registerAccount(call, result);
                return;
            case "signOut":
                signOut();
                return;
            case "isSignedIn":
                isSignedIn(result);
                return;
            case "retrieveToken":
                retrieveToken(result);
                return;
            case "authenticate":
                authenticate(call, result);
                return;
        }
    }

    public static void signIn(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String email = null;
        String password = null;

        if (data != null && data.containsKey("email")) {
            email = (data.get("email").toString());
        } else {
            result.error("email missing", null, null);
        }

        if (data != null && data.containsKey("password")) {
            password = (data.get("password").toString());
        } else {
            result.error("password missing", null, null);
        }

        signInCall = Client.signIn(email, password);
        signInCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public static void registerAccount(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        RegisterClient registerClient = new RegisterClient();
        if (data.get("email").toString().isEmpty() || data.get("password").toString().isEmpty() || data.get("phone").toString().isEmpty()) {
            result.error("data missing", null, null);
        }
        registerClient.setEmail((String) data.get("email"));
        registerClient.setPassword((String) data.get("password"));
        registerClient.setPhone((String) data.get("phone"));
        registerClient.setAddress(data.containsKey("address") ? (String) data.get("address") : null);
        registerClient.setCity(data.containsKey("city") ? (String) data.get("city") : null);
        registerClient.setCompany(data.containsKey("company") ? (String) data.get("company") : null);
        registerClient.setCountryCode(data.containsKey("countryCode") ? (String) data.get("countryCode") : null);
        registerClient.setCustomId(data.containsKey("customId") ? (String) data.get("customId") : null);
        registerClient.setFirstName(data.containsKey("firstName") ? (String) data.get("firstName") : null);
        registerClient.setLastName(data.containsKey("lastName") ? (String) data.get("lastName") : null);
        registerClient.setProvince(data.containsKey("province") ? (String) data.get("province") : null);
        if (data.containsKey("sex")) {
            registerClient.setSex(Sex.getSex((String) data.get("sex")));
        }
        registerClient.setUuid(data.containsKey("uuid") ? (String) data.get("uuid") : null);
        registerClient.setZipCode(data.containsKey("zipCode") ? (String) data.get("zipCode") : null);
        if (data.containsKey("attributes")) {
            Attributes attributes = attributesMapper((HashMap<String, Object>) data.get("attributes"));
            registerClient.setAttributes(attributes);
        }
        if (data.containsKey("agreements")) {
            Agreements agreements = agreementsMapper((Map) data.get("agreements"));
            registerClient.setAgreements(agreements);
        }

        if (signUpCall != null) signUpCall.cancel();
        signUpCall = Client.registerAccount(registerClient);
        signUpCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError ->
                        SyneriseModule.executeFailureResult(apiError, result));

    }

    private static void signOut() {
        Client.signOut();
    }

    private static void isSignedIn(MethodChannel.Result result) {
        SyneriseModule.executeSuccessResult(Client.isSignedIn(), result);
    }

    private static void retrieveToken(MethodChannel.Result result) {
        if (retrieveTokenCall != null) retrieveTokenCall.cancel();
        retrieveTokenCall = Client.getToken();
        retrieveTokenCall.execute(token -> SyneriseModule.executeSuccessResult(tokenMapper(token), result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void authenticate(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String token = null;
        String clientIdentityProvider = null;
        Map contextMap = null;

        if (data != null && data.containsKey("tokenString")) {
            token = (String) data.get("tokenString");
        } else {
            Log.i(TAG, "no token suppplied");
        }

        if (data != null && data.containsKey("identityProvider")) {
            clientIdentityProvider = (String) data.get("identityProvider");
        } else {
            Log.i(TAG, "no clientIdentityProvider suppplied");
        }

        if (data != null && data.containsKey("clientAuthContext")) {
            contextMap = (Map) data.get("clientAuthContext");
        } else {
            Log.i(TAG, "no contextMap suppplied");
        }

        Agreements agreements = null;
        Attributes attributes = null;
        String authId = null;

        if (contextMap.containsKey("agreements") && contextMap.get("agreements") != null) {
            agreements = agreementsMapper((Map) contextMap.get("agreements"));
        }

        if (contextMap.containsKey("attributes") && contextMap.get("attributes") != null) {
            attributes = attributesMapper((HashMap<String, Object>) contextMap.get("attributes"));
        }

        if (contextMap.containsKey("authID")) {
            authId = (String) contextMap.get("authID");
        }

        IApiCall authenticateCall = Client.authenticate(token, ClientIdentityProvider.getByProvider(clientIdentityProvider), agreements, attributes, authId);
        authenticateCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    private static String tokenMapper(Token token) {
        HashMap tokenMap = new HashMap<String, String>();

        //tokenMap.putString("signKey", token.getSignKey());
        tokenMap.put("tokenString", token.getRawJwt());
        //tokenMap.putString("rlm", token.retrieveTokenRLM().getRlm());
        tokenMap.put("origin", token.getOrigin().getOrigin());
        tokenMap.put("expirationDate", token.getExpirationUnixTime());
        JSONObject tokenJson = new JSONObject(tokenMap);
        return tokenJson.toString();
    }

    private static Attributes attributesMapper(HashMap<String, Object> map) {
        Attributes attributes = new Attributes();
        if (map != null) {
            Iterator it = map.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry pair = (Map.Entry) it.next();
                if (pair.getValue() instanceof String) {
                    attributes.add(pair.getKey().toString(), pair.getValue().toString());
                }
                it.remove(); // avoids a ConcurrentModificationException
            }
        }
        return attributes;
    }

    private static Agreements agreementsMapper(Map map) {
        if (map != null) {
            Agreements agreements = new Agreements();
            if (map.containsKey("bluetooth") && map.get("bluetooth") != null) {
                agreements.setBluetooth((boolean) map.get("bluetooth"));
            }
            if (map.containsKey("email") && map.get("email") != null) {
                agreements.setEmail((boolean) map.get("email"));
            }
            if (map.containsKey("push") && map.get("push") != null) {
                agreements.setPush((boolean) map.get("push"));
            }
            if (map.containsKey("rfid") && map.get("rfid") != null) {
                agreements.setRfid((boolean) map.get("rfid"));
            }
            if (map.containsKey("wifi") && map.get("wifi") != null) {
                agreements.setWifi((boolean) map.get("wifi"));
            }
            if (map.containsKey("sms") && map.get("sms") != null) {
                agreements.setSms((boolean) map.get("sms"));
            }
            return agreements;
        } else {
            return null;
        }
    }

    public static SyneriseClient getInstance() {
        if (instance == null) {
            instance = new SyneriseClient();
        }
        return instance;
    }
}
