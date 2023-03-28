package com.synerise.synerise_flutter_sdk.modules;

import com.google.gson.Gson;
import com.synerise.sdk.content.Content;
import com.synerise.sdk.content.model.Audience;
import com.synerise.sdk.content.model.DocumentsApiQuery;
import com.synerise.sdk.content.model.DocumentsApiQueryType;
import com.synerise.sdk.content.model.ScreenViewResponse;
import com.synerise.sdk.content.model.recommendation.RecommendationRequestBody;
import com.synerise.sdk.content.model.recommendation.RecommendationResponse;
import com.synerise.sdk.content.widgets.dataModel.Recommendation;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseContent implements SyneriseModule {

    private static SyneriseContent instance;
    private static volatile boolean isInitialized = false;

    IDataApiCall<Object> getDocumentApiCall;
    IDataApiCall<List<Object>> getDocumentsApiCall;
    private final String ISO8601_FORMAT = "yyyy-MM-dd'T'kk:mm:ss.SSS'Z'";
    private IDataApiCall<RecommendationResponse> getRecommendationsApiCall;
    private IDataApiCall<ScreenViewResponse> getScreenViewApiCall;
    private Gson gson = new Gson();

    public SyneriseContent() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {

        switch (calledMethod) {
            case "getDocument":
                getDocument(call,result);
                return;
            case "getDocuments":
                getDocuments(call,result);
                return;
            case "getRecommendations":
                getRecommendations(call,result);
                return;
            case "getScreenView":
                getScreenView(result);
                return;
        }
    }

    public void getDocument(MethodCall call, MethodChannel.Result result) {
        String slugName = (String) call.arguments;
        if (getDocumentApiCall != null) getDocumentApiCall.cancel();
        getDocumentApiCall = Content.getDocument(slugName);
        getDocumentApiCall.execute(document -> {
            String jsonObject = gson.toJson(document);
            HashMap<String, Object> objectMap = new Gson().fromJson(jsonObject, HashMap.class);
            SyneriseModule.executeSuccessResult(objectMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getDocuments(MethodCall call, MethodChannel.Result result) {
        Map documentApiQueryMap = (Map) call.arguments;
        DocumentsApiQuery documentsApiQuery = new DocumentsApiQuery();
        DocumentsApiQueryType type = DocumentsApiQueryType.getByPathType((String) documentApiQueryMap.get("type"));
        documentsApiQuery.setDocumentQueryParameters(type, (String) documentApiQueryMap.get("typeValue"));
        documentsApiQuery.setVersion((String) documentApiQueryMap.get("version"));

        if (getDocumentsApiCall != null) getDocumentsApiCall.cancel();
        getDocumentsApiCall = Content.getDocuments(documentsApiQuery);

        getDocumentsApiCall.execute(documents -> {
            ArrayList<Map<String, Object>> documentsList = new ArrayList();
            for (Object object : documents) {
                try {
                    String jsonString = gson.toJson(object);
                    final Map<String, Object> documentMap = gson.fromJson(jsonString, Map.class);
                    documentsList.add(documentMap);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            SyneriseModule.executeSuccessResult(documentsList, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getRecommendations(MethodCall call, MethodChannel.Result result) {
        Map recommendationOptions = (Map) call.arguments;
        String productID = null;
        String slugName = null;
        if (call.arguments != null) {
            productID = (String) recommendationOptions.get("productID");
            slugName = (String) recommendationOptions.get("slug");
        }
        if (getRecommendationsApiCall != null) getRecommendationsApiCall.cancel();

        RecommendationRequestBody recommendationRequestBody = new RecommendationRequestBody();
        recommendationRequestBody.setProductId(productID);
        Map<String, Object> recommendationMap = new HashMap<>();

        getRecommendationsApiCall = Content.getRecommendations(slugName, recommendationRequestBody);
        getRecommendationsApiCall.execute(responseBody -> {
            recommendationMap.put("name", responseBody.getName());
            recommendationMap.put("campaignHash", responseBody.getCampaignHash());
            recommendationMap.put("campaignID", responseBody.getCampaignId());
            recommendationMap.put("schema", responseBody.getSchema());
            recommendationMap.put("slug", responseBody.getSlug());
            recommendationMap.put("uuid", responseBody.getUuid());
            recommendationMap.put("items", recommendationToArrayList(responseBody.getRecommendations()));
            SyneriseModule.executeSuccessResult(recommendationMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getScreenView(MethodChannel.Result result) {
        getScreenViewApiCall = Content.getScreenView();
        getScreenViewApiCall.execute(response -> {
            Map<String, Object> screenViewMap = new HashMap<>();
            screenViewMap.put("audience", audienceToWritableMap(response.getAudience()));
            screenViewMap.put("identifier", response.getId());
            screenViewMap.put("hashString", response.getHash());
            screenViewMap.put("path", response.getPath());
            screenViewMap.put("name", response.getName());
            screenViewMap.put("priority", response.getPriority());
            screenViewMap.put("data", screenViewDataMapper(response.getData()));
            screenViewMap.put("version", response.getVersion());
            screenViewMap.put("parentVersion", response.getParentVersion());
            try {
                Date createdAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(response.getCreatedAt());
                Date updatedAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(response.getUpdatedAt());
                if (createdAtDate != null) {
                    screenViewMap.put("createdAt", createdAtDate.getTime());
                }
                if (updatedAtDate != null) {
                    screenViewMap.put("updatedAt", updatedAtDate.getTime());
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
            SyneriseModule.executeSuccessResult(screenViewMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    private ArrayList<Map<String,Object>> recommendationToArrayList(List<Recommendation> array) {

        ArrayList<Map<String, Object>> arrayList = new ArrayList();
        for (int i = 0; i < array.size(); i++) {
            Recommendation recommendation = array.get(i);
            Map<String, Object> recommendationMap = new HashMap<>();
            Map<String,Object> feed = recommendation.getFeed();
            recommendationMap.put("itemID", recommendation.getItemId());
            recommendationMap.put("attributes", feed);
            arrayList.add(recommendationMap);
        }

        return arrayList;
    }

    private ArrayList<Object> listOfStringsToArrayList(List<String> array) {
        ArrayList<Object> arrayList = new ArrayList();
        for (int i = 0; i < array.size(); i++) {
            arrayList.add(array.get(i));
        }

        return arrayList;
    }

    private Map audienceToWritableMap(Audience audience) {
        Map<String, Object> audienceMap = new HashMap<>();
        List<String> idsList = audience.getIds();
        audienceMap.put("query", audience.getQuery());
        audienceMap.put("IDs", idsList != null ? listOfStringsToArrayList(idsList) : null);
        return audienceMap;
    }

    private Map screenViewDataMapper(Object data) {
        Map screenViewData = (Map) data;
        String jsonObject = gson.toJson(data);
        try {
            screenViewData = gson.fromJson(jsonObject, Map.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return screenViewData;
    }

    public static SyneriseContent getInstance() {
        if (instance == null) {
            instance = new SyneriseContent();
        }
        return instance;
    }
}
