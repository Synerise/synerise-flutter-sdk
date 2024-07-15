package com.synerise.synerise_flutter_sdk.modules;

import com.google.gson.Gson;
import com.synerise.sdk.content.Content;
import com.synerise.sdk.content.model.Audience;
import com.synerise.sdk.content.model.DocumentsApiQuery;
import com.synerise.sdk.content.model.DocumentsApiQueryType;
import com.synerise.sdk.content.model.ScreenViewResponse;
import com.synerise.sdk.content.model.document.Document;
import com.synerise.sdk.content.model.document.DocumentApiQuery;
import com.synerise.sdk.content.model.recommendation.FiltersJoinerRule;
import com.synerise.sdk.content.model.recommendation.RecommendationRequestBody;
import com.synerise.sdk.content.model.recommendation.RecommendationResponse;
import com.synerise.sdk.content.model.screenview.ScreenView;
import com.synerise.sdk.content.model.screenview.ScreenViewApiQuery;
import com.synerise.sdk.content.widgets.dataModel.Recommendation;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
    private IDataApiCall<ScreenView> generateScreenViewApiCall;
    private IDataApiCall<Document> generateDocumentApiCall;
    private Gson gson = new Gson();

    public SyneriseContent() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {

        switch (calledMethod) {
            case "getDocument":
                getDocument(call, result);
                return;
            case "generateDocument":
                generateDocument(call, result);
                return;
            case "generateDocumentWithApiQuery":
                generateDocumentWithApiQuery(call, result);
                return;
            case "getDocuments":
                getDocuments(call, result);
                return;
            case "getRecommendations":
                getRecommendations(call, result);
                return;
            case "getRecommendationsV2":
                getRecommendationsV2(call, result);
                return;
            case "getScreenView":
                getScreenView(result);
                return;
            case "generateScreenView":
                generateScreenView(call, result);
                return;
            case "generateScreenViewWithApiQuery":
                generateScreenViewWithApiQuery(call, result);
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

    public void generateDocument(MethodCall call, MethodChannel.Result result) {
        String slug = (String) call.arguments;
        Map<String, Object> documentMap = new HashMap<>();
        if (generateDocumentApiCall != null) generateDocumentApiCall.cancel();
        generateDocumentApiCall = Content.generateDocument(slug);
        generateDocumentApiCall.execute(document -> {
            if (document.getContent() instanceof String) {
                try {
                    HashMap<String, Object> contentMap = new Gson().fromJson((String) document.getContent(), HashMap.class);
                    documentMap.put("content", contentMap);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                documentMap.put("content", document.getContent());
            }
            documentMap.put("identifier", document.getUuid());
            documentMap.put("slug", document.getSlug());
            documentMap.put("schema", document.getSchema());
            SyneriseModule.executeSuccessResult(documentMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void generateDocumentWithApiQuery(MethodCall call, MethodChannel.Result result) {
        Map documentApiQueryMap = (Map) call.arguments;
        String productID = null;
        String slugName = null;
        if (call.arguments != null) {
            productID = (String) documentApiQueryMap.get("productId");
            slugName = (String) documentApiQueryMap.get("slug");
        }

        DocumentApiQuery documentApiQuery = new DocumentApiQuery(slugName);
        documentApiQuery.setProductId(productID);
        documentApiQuery.setItemsIds(documentApiQueryMap.get("itemsIds") != null ? (ArrayList<String>) documentApiQueryMap.get("itemsIds") : null);
        documentApiQuery.setItemsExcluded((ArrayList<String>) documentApiQueryMap.get("itemsExcluded"));
        documentApiQuery.setAdditionalFilters((String) documentApiQueryMap.get("additionalFilters"));
        if (documentApiQueryMap.get("filtersJoiner") != null) {
            documentApiQuery.setFiltersJoiner(getFiltersJoinerRuleFromString((String) documentApiQueryMap.get("filtersJoiner")));
        }
        if (documentApiQueryMap.get("elasticFiltersJoiner") != null) {
            documentApiQuery.setElasticFiltersJoiner(getFiltersJoinerRuleFromString((String) documentApiQueryMap.get("elasticFiltersJoiner")));
        }
        documentApiQuery.setAdditionalElasticFilters((String) documentApiQueryMap.get("additionalElasticFilters"));
        documentApiQuery.setDisplayAttributes((ArrayList<String>) documentApiQueryMap.get("displayAttributes"));
        documentApiQuery.setIncludeContextItems((boolean) documentApiQueryMap.get("includeContextItems"));


        Map<String, Object> documentMap = new HashMap<>();
        if (generateDocumentApiCall != null) generateDocumentApiCall.cancel();
        generateDocumentApiCall = Content.generateDocument(documentApiQuery);
        generateDocumentApiCall.execute(document -> {
            if (document.getContent() instanceof String) {
                try {
                    HashMap<String, Object> contentMap = new Gson().fromJson((String) document.getContent(), HashMap.class);
                    documentMap.put("content", contentMap);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                documentMap.put("content", document.getContent());
            }
            documentMap.put("identifier", document.getUuid());
            documentMap.put("slug", document.getSlug());
            documentMap.put("schema", document.getSchema());
            SyneriseModule.executeSuccessResult(documentMap, result);
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

    public void getRecommendationsV2(MethodCall call, MethodChannel.Result result) {
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
        recommendationRequestBody.setItemsIds(recommendationOptions.get("itemsIds") != null ? (ArrayList<String>) recommendationOptions.get("itemsIds") : null);
        recommendationRequestBody.setItemsExcluded((ArrayList<String>) recommendationOptions.get("itemsExcluded"));
        recommendationRequestBody.setAdditionalFilters((String) recommendationOptions.get("additionalFilters"));
        if (recommendationOptions.get("filtersJoiner") != null) {
            recommendationRequestBody.setFiltersJoiner(getFiltersJoinerRuleFromString((String) recommendationOptions.get("filtersJoiner")));
        }
        if (recommendationOptions.get("elasticFiltersJoiner") != null) {
            recommendationRequestBody.setElasticFiltersJoiner(getFiltersJoinerRuleFromString((String) recommendationOptions.get("elasticFiltersJoiner")));
        }
        recommendationRequestBody.setAdditionalElasticFilters((String) recommendationOptions.get("additionalElasticFilters"));
        recommendationRequestBody.setDisplayAttributes((ArrayList<String>) recommendationOptions.get("displayAttributes"));
        recommendationRequestBody.setIncludeContextItems((boolean) recommendationOptions.get("includeContextItems"));

        Map<String, Object> recommendationMap = new HashMap<>();

        getRecommendationsApiCall = Content.getRecommendationsV2(slugName, recommendationRequestBody);
        getRecommendationsApiCall.execute(responseBody -> {
            recommendationMap.put("name", responseBody.getName());
            recommendationMap.put("correlationID", responseBody.getCorrelationId());
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

    public void generateScreenView(MethodCall call, MethodChannel.Result result) {
        String slug = (String) call.arguments;
        Map<String, Object> screenViewMap = new HashMap<>();
        if (generateScreenViewApiCall != null) generateScreenViewApiCall.cancel();
        generateScreenViewApiCall = Content.generateScreenView(slug);
        generateScreenViewApiCall.execute(screenView -> {
            screenViewMap.put("audience", screenViewAudienceToWritableMap(screenView.getAudience()));
            screenViewMap.put("identifier", screenView.getId());
            screenViewMap.put("hashString", screenView.getHash());
            screenViewMap.put("path", screenView.getPath());
            screenViewMap.put("name", screenView.getName());
            screenViewMap.put("priority", screenView.getPriority());
            screenViewMap.put("data", screenViewDataMapper(screenView.getData()));
            try {
                Date createdAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(screenView.getCreatedAt());
                Date updatedAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(screenView.getUpdatedAt());
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

    public void generateScreenViewWithApiQuery(MethodCall call, MethodChannel.Result result) {
        Map screenViewApiQueryMap = (Map) call.arguments;
        String productID = null;
        String slugName = null;
        if (call.arguments != null) {
            productID = (String) screenViewApiQueryMap.get("productId");
            slugName = (String) screenViewApiQueryMap.get("feedSlug");
        }
        ScreenViewApiQuery screenViewApiQuery = new ScreenViewApiQuery(slugName, productID);
        Map<String, Object> screenViewMap = new HashMap<>();
        if (generateScreenViewApiCall != null) generateScreenViewApiCall.cancel();
        generateScreenViewApiCall = Content.generateScreenView(screenViewApiQuery);
        generateScreenViewApiCall.execute(screenView -> {
            screenViewMap.put("audience", screenViewAudienceToWritableMap(screenView.getAudience()));
            screenViewMap.put("identifier", screenView.getId());
            screenViewMap.put("hashString", screenView.getHash());
            screenViewMap.put("path", screenView.getPath());
            screenViewMap.put("name", screenView.getName());
            screenViewMap.put("priority", screenView.getPriority());
            screenViewMap.put("data", screenViewDataMapper(screenView.getData()));
            try {
                Date createdAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(screenView.getCreatedAt());
                Date updatedAtDate = new SimpleDateFormat(ISO8601_FORMAT, Locale.getDefault()).parse(screenView.getUpdatedAt());
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

    private ArrayList<Map<String, Object>> recommendationToArrayList(List<Recommendation> array) {

        ArrayList<Map<String, Object>> arrayList = new ArrayList();
        for (int i = 0; i < array.size(); i++) {
            Recommendation recommendation = array.get(i);
            Map<String, Object> recommendationMap = new HashMap<>();
            Map<String, Object> feed = recommendation.getFeed();
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

    private Map screenViewAudienceToWritableMap(com.synerise.sdk.content.model.screenview.Audience audience) {
        Map<String, Object> audienceMap = new HashMap<>();
        List<String> segmentsList = audience.getSegments();
        audienceMap.put("query", audience.getQuery());
        audienceMap.put("targetType", audience.getTargetType());
        audienceMap.put("segments", segmentsList != null ? listOfStringsToArrayList(segmentsList) : null);
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

    private FiltersJoinerRule getFiltersJoinerRuleFromString(String filtersJoiner) {
        switch (filtersJoiner) {
            case "and":
                return FiltersJoinerRule.AND;
            case "or":
                return FiltersJoinerRule.OR;
            case "replace":
                return FiltersJoinerRule.REPLACE;
            default:
                return null;
        }
    }

    public static SyneriseContent getInstance() {
        if (instance == null) {
            instance = new SyneriseContent();
        }
        return instance;
    }
}
