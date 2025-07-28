package com.synerise.synerise_flutter_sdk.modules;

import android.util.Log;

import com.google.gson.Gson;
import com.synerise.sdk.client.Client;
import com.synerise.sdk.client.model.AuthConditions;
import com.synerise.sdk.client.model.ClientIdentityProvider;
import com.synerise.sdk.client.model.GetAccountInformation;
import com.synerise.sdk.client.model.UpdateAccountBasicInformation;
import com.synerise.sdk.client.model.UpdateAccountInformation;
import com.synerise.sdk.client.model.client.Agreements;
import com.synerise.sdk.client.model.client.Attributes;
import com.synerise.sdk.client.model.client.RegisterClient;
import com.synerise.sdk.client.model.password.PasswordResetConfirmation;
import com.synerise.sdk.client.model.password.PasswordResetRequest;
import com.synerise.sdk.client.model.simpleAuth.ClientData;
import com.synerise.sdk.core.listeners.ActionListener;
import com.synerise.sdk.core.listeners.DataActionListener;
import com.synerise.sdk.core.net.IApiCall;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.sdk.core.types.enums.ClientSignOutMode;
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
    public static IApiCall signInCall, signUpCall, signOutCall, updateAccountCall, passwordResetCall, updateAccountBasicInformationCall;
    public static IApiCall activateCall, confirmCall, refreshTokenCall, simpleAuthenticationCall;
    private static IDataApiCall<Token> retrieveTokenCall;
    private static final String TAG = "FlutterSyneriseSdk.Cli";
    private IDataApiCall<GetAccountInformation> getAccountCall;
    private Gson gson = new Gson();

    public SyneriseClient() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {
        switch (calledMethod) {
            case "registerAccount":
                registerAccount(call, result);
                return;
            case "confirmAccountActivation":
                confirmAccountActivation(call, result);
                return;
            case "requestAccountActivation":
                requestAccountActivation(call, result);
                return;
            case "confirmAccountActivationByPin":
                confirmAccountActivationByPin(call, result);
                return;
            case "requestAccountActivationByPin":
                requestAccountActivationByPin(call, result);
                return;
            case "signIn":
                signIn(call, result);
                return;
            case "signInConditionally":
                signInConditionally(call, result);
                return;
            case "authenticate":
                authenticate(call, result);
                return;
            case "authenticateConditionally":
                authenticateConditionally(call, result);
                return;
            case "simpleAuthentication":
                simpleAuthentication(call, result);
                return;
            case "isSignedIn":
                isSignedIn(result);
                return;
            case "isSignedInViaSimpleAuthentication":
                isSignedInViaSimpleAuthentication(result);
                return;
            case "signOut":
                signOut(result);
                return;
            case "signOutWithMode":
                signOutWithMode(call, result);
                return;
            case "refreshToken":
                refreshToken(result);
                return;
            case "retrieveToken":
                retrieveToken(result);
                return;
            case "getUUID":
                getUUID(result);
                return;
            case "regenerateUUID":
                regenerateUUID(result);
                return;
            case "regenerateUUIDWithClientIdentifier":
                regenerateUUIDWithClientIdentifier(call, result);
                return;
            case "destroySession":
                destroySession(result);
                return;
            case "getAccount":
                getAccount(call, result);
                return;
            case "updateAccount":
                updateAccount(call, result);
                return;
            case "updateAccountBasicInformation":
                updateAccountBasicInformation(call, result);
                return;
            case "requestPasswordReset":
                requestPasswordReset(call, result);
                return;
            case "confirmPasswordReset":
                confirmPasswordReset(call, result);
                return;
            case "changePassword":
                changePassword(call, result);
                return;
            case "requestEmailChange":
                requestEmailChange(call, result);
                return;
            case "confirmEmailChange":
                confirmEmailChange(call, result);
                return;
            case "requestPhoneUpdate":
                requestPhoneUpdate(call, result);
                return;
            case "confirmPhoneUpdate":
                confirmPhoneUpdate(call, result);
                return;
            case "deleteAccount":
                deleteAccount(call, result);
                return;
        }
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

    public void confirmAccountActivation(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String token = null;

        if (data != null && data.containsKey("token")) {
            token = (String) data.get("token");
        } else {
            result.error("token missing", null, null);
            return;
        }

        if (confirmCall != null) confirmCall.cancel();
        confirmCall = Client.confirmAccountActivation(token);
        confirmCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void requestAccountActivation(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        if (activateCall != null) activateCall.cancel();
        activateCall = Client.requestAccountActivation(email);
        activateCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void requestAccountActivationByPin(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        IApiCall requestAccountActivationCall = Client.requestAccountActivationByPin(email);
        requestAccountActivationCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void confirmAccountActivationByPin(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;
        String pinCode = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        if (data != null && data.containsKey("pinCode")) {
            pinCode = (String) data.get("pinCode");
        } else {
            result.error("pinCode missing", null, null);
            return;
        }

        IApiCall confirmAccountActivationCall = Client.confirmAccountActivationByPin(pinCode, email);
        confirmAccountActivationCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public static void signIn(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String email = null;
        String password = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
            return;
        }

        signInCall = Client.signIn(email, password);
        signInCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void signInConditionally(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;
        String password = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        if (data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
            return;
        }
        IDataApiCall<AuthConditions> apiDataCallConditional = Client.signInConditionally(email, password);
        apiDataCallConditional.execute(response -> {
            Map<String, Object> authMap = new HashMap<String, Object>();

            if (response.getStatus() != null) {
                authMap.put("status", response.getStatus().toString());
            }

            ArrayList<Object> conditions = response.getConditions();
            if (conditions != null) {
                ArrayList<Map<String, Object>> array = new ArrayList();
                for (Object object : conditions) {
                    try {
                        String jsonObject = gson.toJson(object);
                        HashMap<String, Object> objectMap = gson.fromJson(jsonObject, HashMap.class);
                        array.add(objectMap);
                    } catch (Exception e) {
                        result.error("conditions gson error", e.getMessage(), null);
                        return;
                    }
                }
                authMap.put("conditions", array);
            }
            SyneriseModule.executeSuccessResult(authMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
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

    public void authenticateConditionally(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String token = null;
        String clientIdentityProvider = null;
        Map contextMap = null;

        Agreements agreements = null;
        Attributes attributes = null;
        String authID = null;

        if (data != null && data.get("tokenString") != null) {
            token = (String) data.get("tokenString");
        } else {
            result.error("tokenString missing", null, null);
            return;
        }

        if (data.containsKey("identityProvider") && data.get("identityProvider") != null) {
            clientIdentityProvider = (String) data.get("identityProvider");
        } else {
            result.error("identityProvider missing", null, null);
            return;
        }

        if (data.get("clientAuthContext") != null) {
            contextMap = (Map) data.get("clientAuthContext");

            if (contextMap.containsKey("agreements") && contextMap.get("agreements") != null) {
                agreements = agreementsMapper((Map) contextMap.get("agreements"));
            }

            if (contextMap.containsKey("attributes") && contextMap.get("attributes") != null) {
                attributes = attributesMapper((HashMap<String, Object>) contextMap.get("attributes"));
            }
        }

        if (data.get("authID") != null) {
            authID = (String) data.get("authID");
        }

        IDataApiCall<AuthConditions> apiDataCallConditional = Client.authenticateConditionally(token, ClientIdentityProvider.getByProvider(clientIdentityProvider), agreements, attributes, authID);
        apiDataCallConditional.execute(response -> {
            Map<String, Object> authMap = new HashMap<String, Object>();

            if (response.getStatus() != null) {
                authMap.put("status", response.getStatus().toString());
            }

            ArrayList<Object> conditions = response.getConditions();
            if (conditions != null) {

                ArrayList<Map<String, Object>> array = new ArrayList();
                for (Object object : conditions) {
                    try {
                        String jsonObject = gson.toJson(object);
                        HashMap<String, Object> objectMap = gson.fromJson(jsonObject, HashMap.class);
                        array.add(objectMap);
                    } catch (Exception e) {
                        result.error("conditions gson error", e.getMessage(), null);
                        return;
                    }
                }
                authMap.put("conditions", array);
            }

            SyneriseModule.executeSuccessResult(authMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void simpleAuthentication(MethodCall call, MethodChannel.Result result) {
        Map callArgs = (Map) call.arguments;
        String authID = (String) callArgs.get("authID");
        Map data = (Map) callArgs.get("clientSimpleAuthenticationData");

        ClientData clientData = new ClientData();
        clientData.setEmail(data.containsKey("email") ? (String) data.get("email") : null);
        clientData.setPhoneNumber(data.containsKey("phone") ? (String) data.get("phone") : null);
        clientData.setCustomId(data.containsKey("customId") ? (String) data.get("customId") : null);
        clientData.setUuid(data.containsKey("uuid") ? (String) data.get("uuid") : null);
        clientData.setFirstName(data.containsKey("firstName") ? (String) data.get("firstName") : null);
        clientData.setLastName(data.containsKey("lastName") ? (String) data.get("lastName") : null);
        clientData.setDisplayName(data.containsKey("displayName") ? (String) data.get("displayName") : null);
        if (data.containsKey("sex")) {
            clientData.setSex(Sex.getSex((String) data.get("sex")));
        }
        clientData.setBirthDate(data.containsKey("birthDate") ? (String) data.get("birthDate") : null);
        clientData.setAvatarUrl(data.containsKey("avatarUrl") ? (String) data.get("avatarUrl") : null);
        clientData.setCompany(data.containsKey("company") ? (String) data.get("company") : null);
        clientData.setAddress(data.containsKey("address") ? (String) data.get("address") : null);
        clientData.setCity(data.containsKey("city") ? (String) data.get("city") : null);
        clientData.setProvince(data.containsKey("province") ? (String) data.get("province") : null);
        clientData.setZipCode(data.containsKey("zipCode") ? (String) data.get("zipCode") : null);
        clientData.setCountryCode(data.containsKey("countryCode") ? (String) data.get("countryCode") : null);

        if (data.containsKey("attributes")) {
            Attributes attributes = attributesMapper((HashMap<String, Object>) data.get("attributes"));
            clientData.setAttributes(attributes);
        }

        if (data.containsKey("agreements")) {
            Agreements agreements = agreementsMapper((Map) data.get("agreements"));
            clientData.setAgreements(agreements);
        }

        if (simpleAuthenticationCall != null) simpleAuthenticationCall.cancel();
        simpleAuthenticationCall = Client.simpleAuthentication(clientData, authID);
        simpleAuthenticationCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError ->
                        SyneriseModule.executeFailureResult(apiError, result));
    }

    private static void isSignedIn(MethodChannel.Result result) {
        boolean boolResult = Client.isSignedIn();
        SyneriseModule.executeSuccessResult(boolResult, result);
    }

    public void isSignedInViaSimpleAuthentication(MethodChannel.Result result) {
        boolean boolResult = Client.isSignedInViaSimpleAuthentication();
        SyneriseModule.executeSuccessResult(boolResult, result);
    }

    private static void signOut(MethodChannel.Result result) {
        Client.signOut();
        SyneriseModule.executeSuccessResult(true, result);
    }

    public void signOutWithMode(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String mode = (String) data.get("mode");
        Boolean fromAllDevices;
        fromAllDevices = (Boolean) data.get("fromAllDevices");

        ClientSignOutMode nativeMode = clientSignOutModeMapper(mode);

        if (signOutCall != null) signOutCall.cancel();
        if (nativeMode == null) {
            result.error("mode missing", null, null);
            return;
        } else {
            signOutCall = Client.signOut(nativeMode, fromAllDevices);
            signOutCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
        }
    }

    public void refreshToken(MethodChannel.Result result) {
        if (refreshTokenCall != null) refreshTokenCall.cancel();
        {
            refreshTokenCall = Client.refreshToken();
            refreshTokenCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                    (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
        }
    }

    private static void retrieveToken(MethodChannel.Result result) {
        if (retrieveTokenCall != null) retrieveTokenCall.cancel();
        retrieveTokenCall = Client.getToken();
        retrieveTokenCall.execute(token -> {
                    Map<String, Object> tokenMap = new HashMap<String, Object>();
                    tokenMap.put("tokenString", token.getRawJwt());
                    tokenMap.put("origin", token.getOrigin().getOrigin());
                    tokenMap.put("expirationDate", token.getExpirationUnixTime() * 1000);
                    tokenMap.put("rlm", token.getTokenRLM().getRlm());
                    tokenMap.put("clientId", token.getClientId());
                    if (token.getCustomId() != null) {
                        tokenMap.put("customId", token.getCustomId());
                    }
                    SyneriseModule.executeSuccessResult(tokenMap, result);
                },
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getUUID(MethodChannel.Result result) {
        String uuid = Client.getUuid();
        SyneriseModule.executeSuccessResult(uuid, result);
    }

    public void regenerateUUID(MethodChannel.Result result) {
        boolean boolResult = Client.regenerateUuid();
        SyneriseModule.executeSuccessResult(boolResult, result);
    }

    public void regenerateUUIDWithClientIdentifier(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String clientIdentifier = (String) data.get("clientIdentifier");

        if (clientIdentifier != null) {
            boolean isUUIDRegenerated = Client.regenerateUuid(clientIdentifier);
            SyneriseModule.executeSuccessResult(isUUIDRegenerated, result);
        } else {
            result.error("clientIdentifier missing", null, null);
            return;
        }
    }

    public void destroySession(MethodChannel.Result result) {
        Client.destroySession();
        SyneriseModule.executeSuccessResult(true, result);
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
                    accountMap.put("tags", getAccountInformation.getTags());
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

    @SuppressWarnings("unchecked")
    public void updateAccount(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> data = (Map<String, Object>) call.arguments;
        UpdateAccountInformation updateAccountInformation = new UpdateAccountInformation();

        if (data.containsKey("email")) {
            updateAccountInformation.setEmail((String) data.get("email"));
        }
        if (data.containsKey("phone")) {
            updateAccountInformation.setPhoneNumber((String) data.get("phone"));
        }
        if (data.containsKey("customId")) {
            updateAccountInformation.setCustomId((String) data.get("customId"));
        }
        if (data.containsKey("uuid")) {
            updateAccountInformation.setUuid((String) data.get("uuid"));
        }
        if (data.containsKey("firstName")) {
            updateAccountInformation.setFirstName((String) data.get("firstName"));
        }
        if (data.containsKey("lastName")) {
            updateAccountInformation.setLastName((String) data.get("lastName"));
        }
        if (data.containsKey("displayName")) {
            updateAccountInformation.setDisplayName((String) data.get("displayName"));
        }
        if (data.containsKey("sex")) {
            updateAccountInformation.setSex(Sex.getSex((String) data.get("sex")));
        }
        if (data.containsKey("birthDate")) {
            updateAccountInformation.setBirthDate((String) data.get("birthDate"));
        }
        if (data.containsKey("avatarUrl")) {
            updateAccountInformation.setAvatarUrl((String) data.get("avatarUrl"));
        }
        if (data.containsKey("company")) {
            updateAccountInformation.setCompany((String) data.get("company"));
        }
        if (data.containsKey("address")) {
            updateAccountInformation.setAddress((String) data.get("address"));
        }
        if (data.containsKey("city")) {
            updateAccountInformation.setCity((String) data.get("city"));
        }
        if (data.containsKey("province")) {
            updateAccountInformation.setProvince((String) data.get("province"));
        }
        if (data.containsKey("zipCode")) {
            updateAccountInformation.setZipCode((String) data.get("zipCode"));
        }
        if (data.containsKey("countryCode")) {
            updateAccountInformation.setCountryCode((String) data.get("countryCode"));
        }

        if (data.containsKey("attributes")) {
            Object attributesObj = data.get("attributes");
            if (attributesObj instanceof Map) {
                Attributes attributes = attributesMapper((HashMap<String, Object>) attributesObj);
                updateAccountInformation.setAttributes(attributes);
            }
        }

        if (data.containsKey("agreements")) {
            Object agreementsObj = data.get("agreements");
            if (agreementsObj instanceof Map) {
                Agreements agreements = agreementsMapper((Map<String, Object>) agreementsObj);
                updateAccountInformation.setAgreements(agreements);
            }
        }

        if (updateAccountCall != null) {
            updateAccountCall.cancel();
        }

        updateAccountCall = Client.updateAccount(updateAccountInformation);
        updateAccountCall.execute(
                () -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError ->
                        SyneriseModule.executeFailureResult(apiError, result)
        );
    }



    public void updateAccountBasicInformation(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        UpdateAccountBasicInformation updateAccountBasicInformation = new UpdateAccountBasicInformation();

        if (data.containsKey("phone")) {
            updateAccountBasicInformation.setPhoneNumber((String) data.get("phone"));
        }

        if (data.containsKey("firstName")) {
            updateAccountBasicInformation.setFirstName((String) data.get("firstName"));
        }

        if (data.containsKey("lastName")) {
            updateAccountBasicInformation.setLastName((String) data.get("lastName"));
        }

        if (data.containsKey("displayName")) {
            updateAccountBasicInformation.setDisplayName((String) data.get("displayName"));
        }

        if (data.containsKey("sex")) {
            updateAccountBasicInformation.setSex(Sex.getSex((String) data.get("sex")));
        }

        if (data.containsKey("birthDate")) {
            updateAccountBasicInformation.setBirthDate((String) data.get("birthDate"));
        }

        if (data.containsKey("avatarUrl")) {
            updateAccountBasicInformation.setAvatarUrl((String) data.get("avatarUrl"));
        }

        if (data.containsKey("company")) {
            updateAccountBasicInformation.setCompany((String) data.get("company"));
        }

        if (data.containsKey("address")) {
            updateAccountBasicInformation.setAddress((String) data.get("address"));
        }

        if (data.containsKey("city")) {
            updateAccountBasicInformation.setCity((String) data.get("city"));
        }

        if (data.containsKey("province")) {
            updateAccountBasicInformation.setProvince((String) data.get("province"));
        }

        if (data.containsKey("zipCode")) {
            updateAccountBasicInformation.setZipCode((String) data.get("zipCode"));
        }

        if (data.containsKey("countryCode")) {
            updateAccountBasicInformation.setCountryCode((String) data.get("countryCode"));
        }

        if (data.containsKey("attributes")) {
            Attributes attributes = attributesMapper((HashMap<String, Object>) data.get("attributes"));
            updateAccountBasicInformation.setAttributes(attributes);
        }

        if (data.containsKey("agreements")) {
            Agreements agreements = agreementsMapper((Map) data.get("agreements"));
            updateAccountBasicInformation.setAgreements(agreements);
        }

        if (updateAccountBasicInformationCall != null) updateAccountBasicInformationCall.cancel();

        updateAccountBasicInformationCall = Client.updateAccountBasicInformation(updateAccountBasicInformation);
        updateAccountBasicInformationCall.execute(
                () -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result)
        );
    }

    public void requestPasswordReset(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;

        if (data != null && data.containsKey("email")) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }
        if (passwordResetCall != null) passwordResetCall.cancel();
        PasswordResetRequest passwordResetRequest = new PasswordResetRequest(email);
        passwordResetCall = Client.requestPasswordReset(passwordResetRequest);
        passwordResetCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
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
            return;
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
            return;
        }

        PasswordResetConfirmation passwordResetConfirmation = new PasswordResetConfirmation(password, token);
        IApiCall confirmPasswordReset = Client.confirmPasswordReset(passwordResetConfirmation);
        confirmPasswordReset.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }


    public void changePassword(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;

        String oldPassword = null;
        String password = null;

        if (data != null && data.containsKey("oldPassword")) {
            oldPassword = (String) data.get("oldPassword");
        } else {
            result.error("oldPassword missing", null, null);
            return;
        }

        if (data != null && data.containsKey("password")) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
            return;
        }

        IApiCall changePasswordCall = Client.changePassword(oldPassword, password);
        changePasswordCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void requestEmailChange(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String email = null;
        String password = null;
        String externalToken = null;
        String authId = null;

        if (data != null && data.get("email") != null) {
            email = (String) data.get("email");
        } else {
            result.error("email missing", null, null);
            return;
        }

        if (data.get("password") != null) {
            password = (String) data.get("password");
        } else {
            result.error("password missing", null, null);
            return;
        }

        if (data.get("externalToken") != null) {
            externalToken = (String) data.get("externalToken");
        }

        if (data.get("authID") != null) {
            authId = (String) data.get("authID");
        }

        IApiCall emailChangeCall = Client.requestEmailChange(email, password, externalToken, authId);
        emailChangeCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void confirmEmailChange(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String token = null;
        boolean newsletterAgreement;

        if (data != null && data.containsKey("token")) {
            token = (String) data.get("token");
        } else {
            result.error("token missing", null, null);
            return;
        }
        newsletterAgreement = (boolean) data.get("newsletterAgreement");

        IApiCall confirmEmailChange = Client.confirmEmailChange(token, newsletterAgreement);
        confirmEmailChange.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void requestPhoneUpdate(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String phone = null;

        if (data != null && data.containsKey("phone")) {
            phone = (String) data.get("phone");
        } else {
            result.error("phone missing", null, null);
            return;
        }

        IApiCall requestPhoneUpdateCall = Client.requestPhoneUpdate(phone);
        requestPhoneUpdateCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void confirmPhoneUpdate(MethodCall call, MethodChannel.Result result) {
        Map data = (Map) call.arguments;
        String phone = null;
        String confirmationCode = null;
        boolean smsAgreement;

        if (data != null && data.containsKey("phone")) {
            phone = (String) data.get("phone");
        } else {
            result.error("phone missing", null, null);
            return;
        }
        if (data.containsKey("confirmationCode")) {
            confirmationCode = (String) data.get("confirmationCode");
        } else {
            result.error("phone missing", null, null);
            return;
        }
        smsAgreement = (boolean) data.get("smsAgreement");

        IApiCall confirmPhoneUpdateCall = Client.confirmPhoneUpdate(phone, confirmationCode, smsAgreement);
        confirmPhoneUpdateCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
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
            return;
        }

        IApiCall deleteAccountCall = Client.deleteAccount(clientAuthFactor, clientIdentityProvider, authId);
        deleteAccountCall.execute(() -> SyneriseModule.executeSuccessResult(true, result),
                (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    private static ClientSignOutMode clientSignOutModeMapper(String mode) {
        ClientSignOutMode nativeMode;
        switch (mode) {
            case "SIGN_OUT":
                nativeMode = ClientSignOutMode.SIGN_OUT;
                return nativeMode;
            case "SIGN_OUT_WITH_SESSION_DESTROY":
                nativeMode = ClientSignOutMode.SIGN_OUT_WITH_SESSION_DESTROY;
                return nativeMode;
            default:
                return ClientSignOutMode.SIGN_OUT;
        }
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
                    attributes.add(pair.getKey().toString(), pair.getValue());
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
