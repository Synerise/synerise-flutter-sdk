package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

import com.synerise.sdk.client.Client;
import com.synerise.sdk.client.model.ClientIdentityProvider;
import com.synerise.sdk.client.model.GetAccountInformation;
import com.synerise.sdk.client.model.UpdateAccountInformation;
import com.synerise.sdk.client.model.client.Agreements;
import com.synerise.sdk.client.model.client.Attributes;
import com.synerise.sdk.client.model.client.RegisterClient;
import com.synerise.sdk.client.model.password.PasswordResetConfirmation;
import com.synerise.sdk.client.model.password.PasswordResetRequest;
import com.synerise.sdk.core.listeners.ActionListener;
import com.synerise.sdk.core.listeners.DataActionListener;
import com.synerise.sdk.core.net.IApiCall;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.sdk.core.types.model.Sex;
import com.synerise.sdk.core.types.model.Token;
import com.synerise.sdk.error.ApiError;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public final class SyneriseClient implements SyneriseModule {

    private static SyneriseClient instance;
    public static IApiCall signInCall, signUpCall, updateAccountCall, refreshTokenCall, passwordResetCall, activateCall, confirmCall;
    private static IDataApiCall<Token> retrieveTokenCall;
    private static final String TAG = "FlutterSyneriseSdk.Cli";
    private IDataApiCall<GetAccountInformation> getAccountCall;

    public SyneriseClient() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "signIn":
                signIn(call, result);
                return;
            case "signOut":
                signOut(result);
                return;
            case "isSignedIn":
                isSignedIn(result);
                return;
            case "registerAccount":
                registerAccount(call, result);
                return;
            case "updateAccount":
                updateAccount(call, result);
                return;
            case "retrieveToken":
                retrieveToken(result);
                return;
            case "refreshToken":
                refreshToken(result);
                return;
            case "authenticate":
                authenticate(call, result);
                return;
            case "getUUID":
                getUUID(result);
                return;
            case "regenerateUUID":
                regenerateUUID(result);
                return;
            case "requestPasswordReset":
                requestPasswordReset(call, result);
                return;
            case "getAccount":
                getAccount(call, result);
                return;
            case "destroySession":
                destroySession(result);
                return;
            case "changePassword":
                changePassword(call, result);
                return;
            case "confirmPasswordReset":
                confirmPasswordReset(call, result);
                return;
            case "deleteAccount":
                deleteAccount(call, result);
                return;
            case "activateAccount":
                activateAccount(call, result);
                return;
            case "confirmAccount":
                confirmAccount(call, result);
                return;
        }
    }

    public static void signIn(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String email = null;
        String password = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
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
        registerClient.setEmail(data.containsKey("email") ? (String) data.get("email") : null);
        registerClient.setPassword(data.containsKey("password") ? (String) data.get("password") : null);
        if (data.containsKey("phone") && data.get("phone") != null) {
            String phone = (String) data.get("phone");
            if (!phone.isEmpty()) {
                registerClient.setPhone(phone);
            }
        }
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
        signUpCall.execute(new ActionListener() {
            @Override
            public void onAction() {
                SyneriseModule.executeSuccessResult(true, result);
            }
        }, new DataActionListener<ApiError>() {
            @Override
            public void onDataAction(ApiError apiError) {
                SyneriseModule.executeFailureResult(apiError, result);
            }
        });
    }

    private static void signOut(MethodChannel.Result result) {
        Client.signOut();
        SyneriseModule.executeSuccessResult(true, result);
    }

    private static void isSignedIn(MethodChannel.Result result) {
        SyneriseModule.executeSuccessResult(Client.isSignedIn(), result);
    }

    private static void retrieveToken(MethodChannel.Result result) {
        if (retrieveTokenCall != null) retrieveTokenCall.cancel();
        retrieveTokenCall = Client.getToken();
        retrieveTokenCall.execute(token -> {
                    Map<String, Object> tokenMap = new HashMap<String, Object>();
                    tokenMap.put("tokenString", token.getRawJwt());
                    tokenMap.put("origin", token.getOrigin().getOrigin());
                    tokenMap.put("expirationDate", token.getExpirationUnixTime() * 1000);
                    SyneriseModule.executeSuccessResult(tokenMap, result);
                },
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

    public void refreshToken(MethodChannel.Result result) {
        if (refreshTokenCall != null) refreshTokenCall.cancel();
        {
            refreshTokenCall = Client.refreshToken();
            refreshTokenCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                    (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
        }
    }

    public void getUUID(MethodChannel.Result result) {
        String uuid = Client.getUuid();
        SyneriseModule.executeSuccessResult(uuid, result);
    }

    public void regenerateUUID(MethodChannel.Result result) {
        Client.regenerateUuid();
        SyneriseModule.executeSuccessResult(true, result);
    }

    public void updateAccount(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        UpdateAccountInformation updateAccountInformation = new UpdateAccountInformation();
        updateAccountInformation.setEmail(data.containsKey("email") ? (String) data.get("email") : null);
        updateAccountInformation.setPhoneNumber(data.containsKey("phone") ? (String) data.get("phone") : null);
        updateAccountInformation.setCustomId(data.containsKey("customId") ? (String) data.get("customId") : null);
        updateAccountInformation.setUuid(data.containsKey("uuid") ? (String) data.get("uuid") : null);
        updateAccountInformation.setFirstName(data.containsKey("firstName") ? (String) data.get("firstName") : null);
        updateAccountInformation.setLastName(data.containsKey("lastName") ? (String) data.get("lastName") : null);
        updateAccountInformation.setDisplayName(data.containsKey("displayName") ? (String) data.get("displayName") : null);
        if (data.containsKey("sex")) {
            updateAccountInformation.setSex(Sex.getSex((String) data.get("sex")));
        }
        updateAccountInformation.setBirthDate(data.containsKey("birthDate") ? (String) data.get("birthDate") : null);
        updateAccountInformation.setAvatarUrl(data.containsKey("avatarUrl") ? (String) data.get("avatarUrl") : null);
        updateAccountInformation.setCompany(data.containsKey("company") ? (String) data.get("company") : null);
        updateAccountInformation.setAddress(data.containsKey("address") ? (String) data.get("address") : null);
        updateAccountInformation.setCity(data.containsKey("city") ? (String) data.get("city") : null);
        updateAccountInformation.setProvince(data.containsKey("province") ? (String) data.get("province") : null);
        updateAccountInformation.setZipCode(data.containsKey("zipCode") ? (String) data.get("zipCode") : null);
        updateAccountInformation.setCountryCode(data.containsKey("countryCode") ? (String) data.get("countryCode") : null);

        if (data.containsKey("attributes")) {
            Attributes attributes = attributesMapper((HashMap<String, Object>) data.get("attributes"));
            updateAccountInformation.setAttributes(attributes);
        }

        if (data.containsKey("agreements")) {
            Agreements agreements = agreementsMapper((Map) data.get("agreements"));
            updateAccountInformation.setAgreements(agreements);
        }

        if (updateAccountCall != null) updateAccountCall.cancel();
        updateAccountCall = Client.updateAccount(updateAccountInformation);
        updateAccountCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError ->
                        SyneriseModule.executeFailureResult(apiError, result));

    }

    public void requestPasswordReset(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
        }
        if (passwordResetCall != null) passwordResetCall.cancel();
        PasswordResetRequest passwordResetRequest = new PasswordResetRequest(email);
        passwordResetCall = Client.requestPasswordReset(passwordResetRequest);
        passwordResetCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getAccount(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> accountMap = new HashMap<String, Object>();
        if (getAccountCall != null) getAccountCall.cancel();
        getAccountCall = Client.getAccount();
        getAccountCall.execute((DataActionListener<GetAccountInformation>) getAccountInformation -> {
                    Map<String, Object> agreements = new HashMap<String, Object>();
                    agreements.put("email", getAccountInformation.getAgreements().getEmail());
                    agreements.put("sms", getAccountInformation.getAgreements().getSms());
                    agreements.put("push", getAccountInformation.getAgreements().getPush());
                    agreements.put("bluetooth", getAccountInformation.getAgreements().getBluetooth());
                    agreements.put("rfid", getAccountInformation.getAgreements().getRfid());
                    agreements.put("wifi", getAccountInformation.getAgreements().getWifi());
                    accountMap.put("clientId", getAccountInformation.getClientId());
                    accountMap.put("email", getAccountInformation.getEmail());
                    accountMap.put("phone", getAccountInformation.getPhone());
                    accountMap.put("customId", getAccountInformation.getCustomId());
                    accountMap.put("uuid", getAccountInformation.getUuid());
                    accountMap.put("firstName", getAccountInformation.getFirstName());
                    accountMap.put("lastName", getAccountInformation.getLastName());
                    accountMap.put("displayName", getAccountInformation.getDisplayName());
                    accountMap.put("company", getAccountInformation.getCompany());
                    accountMap.put("address", getAccountInformation.getAddress());
                    accountMap.put("city", getAccountInformation.getCity());
                    accountMap.put("province", getAccountInformation.getProvince());
                    accountMap.put("zipCode", getAccountInformation.getZipCode());
                    accountMap.put("countryCode", getAccountInformation.getCountryCode());
                    accountMap.put("birthDate", getAccountInformation.getBirthDate());
                    accountMap.put("sex", getAccountInformation.getSex().getSex());
                    accountMap.put("avatarUrl", getAccountInformation.getAvatarUrl());
                    accountMap.put("anonymous", getAccountInformation.getAnonymous());
                    accountMap.put("agreements", agreements);
                    accountMap.put("attributes", (getAccountInformation.getAttributes()));
                    accountMap.put("tags", mapTags(getAccountInformation.getTags()));
                    if (getAccountInformation.getLastActivityDate() != null) {
                        accountMap.put("lastActivityDate", getAccountInformation.getLastActivityDate().getTime());
                    }
                    SyneriseModule.executeSuccessResult(accountMap, result);
                },
                new DataActionListener<ApiError>() {
                    @Override
                    public void onDataAction(ApiError apiError) {
                        SyneriseModule.executeFailureResult(apiError, result);
                    }
                });
    }

    public void destroySession(MethodChannel.Result result) {
        Client.destroySession();
        SyneriseModule.executeSuccessResult(true, result);
    }

    public void changePassword(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String oldPassword = null;
        String password = null;

        if (data != null && data.containsKey("oldPassword")) {
            oldPassword = (String) data.get("oldPassword");
        } else {
            result.error("oldPassword missing", null, null);
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
        }

        IApiCall changePasswordCall = Client.changePassword(oldPassword, password);
        changePasswordCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void confirmPasswordReset(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String token = null;
        String password = null;

        if (data != null && data.containsKey("token")) {
            token = (String) data.get("token");
        } else {
            result.error("token missing", null, null);
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
        }

        PasswordResetConfirmation passwordResetConfirmation = new PasswordResetConfirmation(password, token);
        IApiCall confirmPasswordReset = Client.confirmPasswordReset(passwordResetConfirmation);
        confirmPasswordReset.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void deleteAccount(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String clientAuthFactor = null;
        ClientIdentityProvider clientIdentityProvider = null;
        String authId = null;
        if (data != null) {
            if (data.containsKey("clientAuthFactor")) {
                clientAuthFactor = (String) data.get("clientAuthFactor");
            }
            if (data.containsKey("identityProvider")) {
                clientIdentityProvider = ClientIdentityProvider.getByProvider((String) data.get("identityProvider"));
            }
            if (data.containsKey("authID")) {
                authId = (String) data.get("authID");
            }
        } else {
            result.error("Missing method arguments", null, null);
        }

        IApiCall deleteAccountCall = Client.deleteAccount(clientAuthFactor, clientIdentityProvider, authId);
        deleteAccountCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void activateAccount(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
        }

        if (activateCall != null) activateCall.cancel();
        activateCall = Client.activateAccount(email);
        activateCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void confirmAccount(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String token = null;

        if (data != null && data.containsKey("token")) {
            token = (String) data.get("token");
        } else {
            result.error("token missing", null, null);
        }

        if (confirmCall != null) confirmCall.cancel();
        confirmCall = Client.confirmAccount(token);
        confirmCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    private ArrayList<String> mapTags(List<String> list) {
        return new ArrayList<>(list);
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
