package com.synerise.synerise_flutter_sdk.modules;

import com.synerise.sdk.core.listeners.DataActionListener;
import com.synerise.sdk.core.net.IApiCall;
import com.synerise.sdk.core.net.IDataApiCall;
import com.synerise.sdk.core.types.enums.ApiQuerySortingOrder;
import com.synerise.sdk.error.ApiError;
import com.synerise.sdk.promotions.Promotions;
import com.synerise.sdk.promotions.model.AssignVoucherData;
import com.synerise.sdk.promotions.model.AssignVoucherResponse;
import com.synerise.sdk.promotions.model.VoucherCodesData;
import com.synerise.sdk.promotions.model.VoucherCodesResponse;
import com.synerise.sdk.promotions.model.promotion.DiscountModeDetails;
import com.synerise.sdk.promotions.model.promotion.DiscountStep;
import com.synerise.sdk.promotions.model.promotion.Promotion;
import com.synerise.sdk.promotions.model.promotion.PromotionActivationKey;
import com.synerise.sdk.promotions.model.promotion.PromotionDetails;
import com.synerise.sdk.promotions.model.promotion.PromotionIdentifier;
import com.synerise.sdk.promotions.model.promotion.PromotionImage;
import com.synerise.sdk.promotions.model.promotion.PromotionResponse;
import com.synerise.sdk.promotions.model.promotion.PromotionSortingKey;
import com.synerise.sdk.promotions.model.promotion.PromotionStatus;
import com.synerise.sdk.promotions.model.promotion.PromotionType;
import com.synerise.sdk.promotions.model.promotion.PromotionsApiQuery;
import com.synerise.sdk.promotions.model.promotion.SinglePromotionResponse;
import com.synerise.synerise_flutter_sdk.SyneriseModule;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SynerisePromotions implements SyneriseModule {

    IDataApiCall<PromotionResponse> getPromotionsCall;
    IDataApiCall<SinglePromotionResponse> getSinglePromotionCall;
    IDataApiCall<AssignVoucherResponse> getOrAssignVoucherCall;
    IApiCall activatePromotionCall;
    IApiCall deactivatePromotionCall;
    private static SynerisePromotions instance;
    private static volatile boolean isInitialized = false;

    public SynerisePromotions() {
    }

    @Override
    public void handleMethodCall(MethodCall call, MethodChannel.Result result, String calledMethod) {

        switch (calledMethod) {
            case "getAllPromotions":
                getAllPromotions(call, result);
                return;
            case "getPromotions":
                getPromotions(call, result);
                return;
            case "getPromotionByUUID":
                getPromotionByUUID(call, result);
                return;
            case "getPromotionByCode":
                getPromotionByCode(call, result);
                return;
            case "activatePromotionByUUID":
                activatePromotionByUUID(call, result);
                return;
            case "activatePromotionByCode":
                activatePromotionByCode(call, result);
                return;
            case "deactivatePromotionByUUID":
                deactivatePromotionByUUID(call, result);
                return;
            case "deactivatePromotionByCode":
                deactivatePromotionByCode(call, result);
                return;
            case "activatePromotionsBatch":
                activatePromotionsBatch(call, result);
                return;
            case "deactivatePromotionsBatch":
                deactivatePromotionsBatch(call, result);
                return;
            case "getOrAssignVoucher":
                getOrAssignVoucher(call, result);
                return;
            case "assignVoucherCode":
                assignVoucherCode(call, result);
                return;
            case "getAssignedVoucherCodes":
                getAssignedVoucherCodes(call, result);
                return;
        }
    }

    public void getAllPromotions(MethodCall call, MethodChannel.Result result) {
        if (getPromotionsCall != null) getPromotionsCall.cancel();
        getPromotionsCall = Promotions.getPromotions();
        getPromotionsCall.execute((DataActionListener<PromotionResponse>) promotionResponse -> {
            Map<String, Object> promotionMap = new HashMap<>();
            if (promotionResponse.getPromotionMetadata() != null) {
                promotionMap = insertMetaDataToMap(promotionMap, promotionResponse);
            }

            if (promotionResponse.getPromotions() != null) {
                promotionMap.put("items", promotionsToArrayList(promotionResponse.getPromotions()));
            }

            SyneriseModule.executeSuccessResult(promotionMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getPromotions(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> promotionsMap = (Map) call.arguments;
        PromotionsApiQuery promotionsApiQuery = new PromotionsApiQuery();
        promotionsApiQuery.setStatuses(promotionsMap.containsKey("statuses") ? arrayListToPromotionStatusList((ArrayList<String>) promotionsMap.get("statuses")) : null);
        promotionsApiQuery.setTypes(promotionsMap.containsKey("types") ? arrayListToPromotionTypesList((ArrayList<String>) promotionsMap.get("types")) : null);
        promotionsApiQuery.setLimit(promotionsMap.containsKey("limit") ? (int) promotionsMap.get("limit") : 100);
        promotionsApiQuery.setPage(promotionsMap.containsKey("page") ? (int) promotionsMap.get("page") : 1);
        promotionsApiQuery.setIncludeMeta(promotionsMap.containsKey("includeMeta") ? (boolean) promotionsMap.get("includeMeta") : false);
        if (promotionsMap.containsKey("sorting")) {
            promotionsApiQuery.setSortParameters(arrayListToLinkedHashMapSorting((ArrayList) promotionsMap.get("sorting")));
        }

        if (getPromotionsCall != null) getPromotionsCall.cancel();
        getPromotionsCall = Promotions.getPromotions(promotionsApiQuery);

        getPromotionsCall.execute((DataActionListener<PromotionResponse>) promotionResponse -> {

            Map<String, Object> promotionMap = new HashMap<>();

            if (promotionResponse.getPromotionMetadata() != null) {
                promotionMap = insertMetaDataToMap(promotionMap, promotionResponse);
            }

            if (promotionResponse.getPromotions() != null) {
                promotionMap.put("items", promotionsToArrayList(promotionResponse.getPromotions()));
            }

            SyneriseModule.executeSuccessResult(promotionMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getPromotionByUUID(MethodCall call, MethodChannel.Result result) {
        String uuid = (String) call.arguments;
        if (getSinglePromotionCall != null) getSinglePromotionCall.cancel();
        getSinglePromotionCall = Promotions.getPromotionByUuid(uuid);
        getSinglePromotionCall.execute(promotionResponse -> {
            Map promotionMap = promotionToMap(promotionResponse.getPromotion());

            SyneriseModule.executeSuccessResult(promotionMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getPromotionByCode(MethodCall call, MethodChannel.Result result) {
        String code = (String) call.arguments;
        if (getSinglePromotionCall != null) getSinglePromotionCall.cancel();
        getSinglePromotionCall = Promotions.getPromotionByCode(code);
        getSinglePromotionCall.execute(promotionResponse -> {
            Map promotionMap = promotionToMap(promotionResponse.getPromotion());
            SyneriseModule.executeSuccessResult(promotionMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void activatePromotionByUUID(MethodCall call, MethodChannel.Result result) {
        String uuid = (String) call.arguments;
        if (activatePromotionCall != null) activatePromotionCall.cancel();
        activatePromotionCall = Promotions.activatePromotionByUuid(uuid);
        activatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }


    public void activatePromotionByCode(MethodCall call, MethodChannel.Result result) {
        String code = (String) call.arguments;
        if (activatePromotionCall != null) activatePromotionCall.cancel();
        activatePromotionCall = Promotions.activatePromotionByCode(code);
        activatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void deactivatePromotionByUUID(MethodCall call, MethodChannel.Result result) {
        String uuid = (String) call.arguments;
        if (deactivatePromotionCall != null) deactivatePromotionCall.cancel();
        deactivatePromotionCall = Promotions.deactivatePromotionByUuid(uuid);
        deactivatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void deactivatePromotionByCode(MethodCall call, MethodChannel.Result result) {
        String code = (String) call.arguments;
        if (deactivatePromotionCall != null) deactivatePromotionCall.cancel();
        deactivatePromotionCall = Promotions.deactivatePromotionByCode(code);
        deactivatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void activatePromotionsBatch(MethodCall call, MethodChannel.Result result) {
        ArrayList array = (ArrayList) call.arguments;
        if (activatePromotionCall != null) activatePromotionCall.cancel();
        activatePromotionCall = Promotions.activatePromotionsBatch(arrayListToPromotionIdentifierList(array));
        activatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void deactivatePromotionsBatch(MethodCall call, MethodChannel.Result result) {
        ArrayList array = (ArrayList) call.arguments;
        if (deactivatePromotionCall != null) deactivatePromotionCall.cancel();
        deactivatePromotionCall = Promotions.deactivatePromotionsBatch(arrayListToPromotionIdentifierList(array));
        deactivatePromotionCall.execute(() -> SyneriseModule.executeSuccessResult(true, result), (DataActionListener<ApiError>) apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getOrAssignVoucher(MethodCall call, MethodChannel.Result result) {
        String poolUuid = (String) call.arguments;
        if (getOrAssignVoucherCall != null) getOrAssignVoucherCall.cancel();
        getOrAssignVoucherCall = Promotions.getOrAssignVoucher(poolUuid);
        getOrAssignVoucherCall.execute(assignVoucherResponse -> {
            Map<String, Object> voucherMap = new HashMap<>();

            if (assignVoucherResponse.getMessage() != null) {
                voucherMap.put("message", assignVoucherResponse.getMessage());
            }

            if (assignVoucherResponse.getData() != null) {
                voucherMap.put("data", assignVoucherDataToMap(assignVoucherResponse.getData()));
            }

            SyneriseModule.executeSuccessResult(voucherMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void assignVoucherCode(MethodCall call, MethodChannel.Result result) {
        String poolUuid = (String) call.arguments;
        if (getOrAssignVoucherCall != null) getOrAssignVoucherCall.cancel();
        getOrAssignVoucherCall = Promotions.assignVoucherCode(poolUuid);
        getOrAssignVoucherCall.execute(assignVoucherResponse -> {
            Map<String, Object> voucherMap = new HashMap<>();

            if (assignVoucherResponse.getMessage() != null) {
                voucherMap.put("message", assignVoucherResponse.getMessage());
            }

            if (assignVoucherResponse.getData() != null) {
                voucherMap.put("data", assignVoucherDataToMap(assignVoucherResponse.getData()));
            }

            SyneriseModule.executeSuccessResult(voucherMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    public void getAssignedVoucherCodes(MethodCall call, MethodChannel.Result result) {
        IDataApiCall<VoucherCodesResponse> getVoucherCodesCall = Promotions.getAssignedVoucherCodes();
        getVoucherCodesCall.execute(voucherCodesResponse -> {
            Map<String, Object> voucherCodesMap = new HashMap<>();

            if (voucherCodesResponse.getData() != null) {
                voucherCodesMap.put("data", voucherDataToArrayList(voucherCodesResponse.getData()));
            }

            SyneriseModule.executeSuccessResult(voucherCodesMap, result);
        }, apiError -> SyneriseModule.executeFailureResult(apiError, result));
    }

    private ArrayList promotionsToArrayList(List<Promotion> array) {
        ArrayList<Map<String, Object>> arrayList = new ArrayList();

        for (int i = 0; i < array.size(); i++) {
            Promotion promotion = array.get(i);
            Map<String, Object> promotionMap = new HashMap<>();

            promotionMap.put("uuid", promotion.getUuid());
            promotionMap.put("code", promotion.getCode());
            promotionMap.put("status", promotion.getStatus().getStatus());
            promotionMap.put("type", promotion.getType().getType());
            promotionMap.put("redeemLimitPerClient", promotion.getRedeemLimitPerClient());
            promotionMap.put("redeemQuantityPerActivation", promotion.getRedeemQuantityPerActivation());
            promotionMap.put("currentRedeemedQuantity", promotion.getCurrentRedeemedQuantity());
            promotionMap.put("currentRedeemLimit", promotion.getCurrentRedeemLimit());
            promotionMap.put("activationCounter", promotion.getActivationCounter());
            promotionMap.put("possibleRedeems", promotion.getPossibleRedeems());
            promotionMap.put("discountType", promotion.getDiscountType().getApiName());
            promotionMap.put("discountValue", promotion.getDiscountValue());
            promotionMap.put("discountMode", promotion.getDiscountMode());
            promotionMap.put("requireRedeemedPoints", promotion.getRequireRedeemedPoints());
            promotionMap.put("name", promotion.getName());
            promotionMap.put("headline", promotion.getHeadline());
            promotionMap.put("descriptionText", promotion.getDescription());
            promotionMap.put("price", promotion.getPrice());
            promotionMap.put("priority", promotion.getPriority());
            promotionMap.put("itemScope", promotion.getItermScope());
            promotionMap.put("displayFrom", promotion.getDisplayFrom());
            promotionMap.put("displayTo", promotion.getDisplayTo());
            promotionMap.put("lastingTime", promotion.getLastingTime());
            if (promotion.getMinBasketValue() != null) {
                promotionMap.put("minBasketValue", promotion.getMinBasketValue());
            }
            if (promotion.getMaxBasketValue() != null) {
                promotionMap.put("maxBasketValue", promotion.getMaxBasketValue());
            }
            if (promotion.getAssignedAt() != null) {
                promotionMap.put("assignedAt", promotion.getAssignedAt().getTime());
            }
            if (promotion.getStartAt() != null) {
                promotionMap.put("startAt", promotion.getStartAt().getTime());
            }
            if (promotion.getLastingAt() != null) {
                promotionMap.put("lastingAt", promotion.getLastingAt().getTime());
            }
            if (promotion.getExpireAt() != null) {
                promotionMap.put("expireAt", promotion.getExpireAt().getTime());
            }
            if (promotion.getImages() != null) {
                promotionMap.put("images", promotionImageToArrayList(promotion.getImages()));
            }
            if (promotion.getCatalogIndexItems() != null) {
                promotionMap.put("catalogIndexItems", promotion.getCatalogIndexItems());
            }
            if (promotion.getParams() != null) {
                promotionMap.put("params", promotion.getParams());
            }
            if (promotion.getDetails() != null) {
                promotionMap.put("details", promotionDetailsToMap(promotion.getDetails()));
            }
            if (promotion.getDiscountModeDetails() != null) {
                promotionMap.put("discountModeDetails", discountModeDetailsToMap(promotion.getDiscountModeDetails()));
            }

            arrayList.add(promotionMap);
        }

        return arrayList;
    }

    private Map promotionToMap(Promotion promotion) {
        Map<String, Object> promotionMap = new HashMap<>();

        promotionMap.put("uuid", promotion.getUuid());
        promotionMap.put("code", promotion.getCode());
        promotionMap.put("status", promotion.getStatus().getStatus());
        promotionMap.put("type", promotion.getType().getType());
        promotionMap.put("redeemLimitPerClient", promotion.getRedeemLimitPerClient());
        promotionMap.put("redeemQuantityPerActivation", promotion.getRedeemQuantityPerActivation());
        promotionMap.put("currentRedeemedQuantity", promotion.getCurrentRedeemedQuantity());
        promotionMap.put("currentRedeemLimit", promotion.getCurrentRedeemLimit());
        promotionMap.put("activationCounter", promotion.getActivationCounter());
        promotionMap.put("possibleRedeems", promotion.getPossibleRedeems());
        promotionMap.put("discountType", promotion.getDiscountType().getApiName());
        promotionMap.put("discountValue", promotion.getDiscountValue());
        promotionMap.put("discountMode", promotion.getDiscountMode());
        promotionMap.put("requireRedeemedPoints", promotion.getRequireRedeemedPoints());
        promotionMap.put("name", promotion.getName());
        promotionMap.put("headline", promotion.getHeadline());
        promotionMap.put("descriptionText", promotion.getDescription());
        promotionMap.put("price", promotion.getPrice());
        promotionMap.put("priority", promotion.getPriority());
        promotionMap.put("itemScope", promotion.getItermScope());
        promotionMap.put("displayFrom", promotion.getDisplayFrom());
        promotionMap.put("displayTo", promotion.getDisplayTo());
        promotionMap.put("lastingTime", promotion.getLastingTime());

        if (promotion.getMinBasketValue() != null) {
            promotionMap.put("minBasketValue", promotion.getMinBasketValue());
        }
        if (promotion.getMaxBasketValue() != null) {
            promotionMap.put("maxBasketValue", promotion.getMaxBasketValue());
        }
        if (promotion.getAssignedAt() != null) {
            promotionMap.put("assignedAt", promotion.getAssignedAt().getTime());
        }
        if (promotion.getStartAt() != null) {
            promotionMap.put("startAt", promotion.getStartAt().getTime());
        }
        if (promotion.getLastingAt() != null) {
            promotionMap.put("lastingAt", promotion.getLastingAt().getTime());
        }
        if (promotion.getExpireAt() != null) {
            promotionMap.put("expireAt", promotion.getExpireAt().getTime());
        }
        if (promotion.getImages() != null) {
            promotionMap.put("images", promotionImageToArrayList(promotion.getImages()));
        }
        if (promotion.getCatalogIndexItems() != null) {
            promotionMap.put("catalogIndexItems", promotion.getCatalogIndexItems());
        }
        if (promotion.getParams() != null) {
            promotionMap.put("params", promotion.getParams());
        }
        if (promotion.getDetails() != null) {
            promotionMap.put("details", promotionDetailsToMap(promotion.getDetails()));
        }
        if (promotion.getDiscountModeDetails() != null) {
            promotionMap.put("discountModeDetails", discountModeDetailsToMap(promotion.getDiscountModeDetails()));
        }

        return promotionMap;
    }

    private static List<PromotionStatus> arrayListToPromotionStatusList(ArrayList<String> arrayList) {
        PromotionStatus[] array = new PromotionStatus[arrayList.size()];
        for (int i = 0; i < arrayList.size(); i++) {
            PromotionStatus status = PromotionStatus.getByPromotionStatus((String) arrayList.get(i));
            array[i] = status;
        }

        List<PromotionStatus> list = Arrays.asList(array);
        return list;
    }

    private static List<PromotionType> arrayListToPromotionTypesList(ArrayList<String> arrayList) {
        PromotionType[] array = new PromotionType[arrayList.size()];
        for (int i = 0; i < arrayList.size(); i++) {
            PromotionType types = PromotionType.getByPromotionType((String) arrayList.get(i));
            array[i] = types;
        }

        List<PromotionType> list = Arrays.asList(array);
        return list;
    }

    private List<PromotionIdentifier> arrayListToPromotionIdentifierList(ArrayList<Map<String, Object>> array) {
        List<PromotionIdentifier> list = new ArrayList<>(array.size());
        for (int i = 0; i < array.size(); i++) {
            PromotionActivationKey key = PromotionActivationKey.valueOf((String) array.get(i).get("key"));
            String value = (String) array.get(i).get("value");
            list.add(new PromotionIdentifier(key, value));
        }

        return list;
    }

    private static LinkedHashMap<PromotionSortingKey, ApiQuerySortingOrder> arrayListToLinkedHashMapSorting(ArrayList<Map<String, Object>> arrayList) {
        LinkedHashMap<PromotionSortingKey, ApiQuerySortingOrder> sorting = new LinkedHashMap<>();
        for (int i = 0; i < arrayList.size(); i++) {
            PromotionSortingKey key = PromotionSortingKey.getByPromotionSortingKey((String) arrayList.get(i).get("key"));
            ApiQuerySortingOrder order = ApiQuerySortingOrder.getBySortingOrder((String) arrayList.get(i).get("order"));
            sorting.put(key, order);
        }
        return null;
    }

    private ArrayList promotionImageToArrayList(List<PromotionImage> array) {
        ArrayList<Map<String, Object>> arrayList = new ArrayList();
        for (int i = 0; i < array.size(); i++) {
            PromotionImage image = array.get(i);
            Map<String, Object> imageMap = new HashMap<>();
            imageMap.put("url", image.getUrl());
            imageMap.put("type", image.getType().getApiName());

            arrayList.add(imageMap);
        }

        return arrayList;
    }

    private Map promotionDetailsToMap(PromotionDetails details) {
        Map<String, Object> promotionDetailsMap = new HashMap<>();
        Map<String, Object> promotionDiscountType = new HashMap<>();

        if (details.getDiscountType() != null) {
            promotionDiscountType.put("name", details.getDiscountType().getName());
            promotionDiscountType.put("outerScope", details.getDiscountType().getOuterScope());
            promotionDiscountType.put("requiredItemsCount", details.getDiscountType().getRequiredItemsCount());
            promotionDiscountType.put("discountedItemsCount", details.getDiscountType().getDiscountedItemsCount());
        }

        promotionDetailsMap.put("discountType", promotionDiscountType);
        return promotionDetailsMap;
    }

    private Map discountModeDetailsToMap(DiscountModeDetails discountModeDetails) {
        Map<String, Object> discountModeDetailsMap = new HashMap<>();
        discountModeDetailsMap.put("discountUsageTrigger", discountModeDetails.getDiscountUsageTrigger());

        ArrayList<Map<String, Object>> discountStepsArray = new ArrayList();
        List<DiscountStep> discountSteps = discountModeDetails.getDiscountSteps();
        for (int i = 0; i < discountSteps.size(); i++) {
            DiscountStep step = discountSteps.get(i);
            Map<String, Object> discountStepMap = new HashMap<>();
            discountStepMap.put("discountValue", step.getDiscountValue());
            discountStepMap.put("usageThreshold", step.getUsageThreshold());
            discountStepsArray.add(discountStepMap);
        }

        discountModeDetailsMap.put("discountSteps", discountStepsArray);
        return discountModeDetailsMap;
    }

    private Map insertMetaDataToMap(Map promotionMap, PromotionResponse promotionResponse) {
        promotionMap.put("totalCount", promotionResponse.getPromotionMetadata().getTotalCount());
        promotionMap.put("totalPages", promotionResponse.getPromotionMetadata().getTotalPages());
        promotionMap.put("page", promotionResponse.getPromotionMetadata().getPage());
        promotionMap.put("limit", promotionResponse.getPromotionMetadata().getLimit());
        promotionMap.put("code", promotionResponse.getPromotionMetadata().getCode());

        return promotionMap;
    }

    private Map assignVoucherDataToMap(AssignVoucherData voucherData) {
        Map<String, Object> voucherDataMap = new HashMap<>();

        if (voucherData.getCode() != null) {
            voucherDataMap.put("code", voucherData.getCode());
        }
        if (voucherData.getExpireIn() != null) {
            voucherDataMap.put("expireIn", voucherData.getExpireIn().getTime());
        }
        if (voucherData.getRedeemAt() != null) {
            voucherDataMap.put("redeemAt", voucherData.getRedeemAt().getTime());
        }
        if (voucherData.getAssignedAt() != null) {
            voucherDataMap.put("assignedAt", voucherData.getAssignedAt().getTime());
        }
        if (voucherData.getCreatedAt() != null) {
            voucherDataMap.put("createdAt", voucherData.getCreatedAt().getTime());
        }
        if (voucherData.getUpdatedAt() != null) {
            voucherDataMap.put("updatedAt", voucherData.getUpdatedAt().getTime());
        }

        return voucherDataMap;
    }

    private ArrayList voucherDataToArrayList(List<VoucherCodesData> array) {
        ArrayList<Map<String, Object>> arrayList = new ArrayList();

        for (int i = 0; i < array.size(); i++) {
            VoucherCodesData voucherCodesData = array.get(i);
            Map<String, Object> voucherMap = new HashMap<>();
            voucherMap.put("code", voucherCodesData.getCode());
            voucherMap.put("status", voucherCodesData.getStatus().getStatus());
            voucherMap.put("clientId", voucherCodesData.getClientId());
            voucherMap.put("clientUuid", voucherCodesData.getClientUuid());
            voucherMap.put("poolUuid", voucherCodesData.getPoolUuid());
            if (voucherCodesData.getExpireIn() != null) {
                voucherMap.put("expireIn", voucherCodesData.getExpireIn().getTime());
            }
            if (voucherCodesData.getRedeemAt() != null) {
                voucherMap.put("redeemAt", voucherCodesData.getRedeemAt().getTime());
            }
            if (voucherCodesData.getAssignedAt() != null) {
                voucherMap.put("assignedAt", voucherCodesData.getAssignedAt().getTime());
            }
            if (voucherCodesData.getCreatedAt() != null) {
                voucherMap.put("createdAt", voucherCodesData.getCreatedAt().getTime());
            }
            if (voucherCodesData.getUpdatedAt() != null) {
                voucherMap.put("updatedAt", voucherCodesData.getUpdatedAt().getTime());
            }

            arrayList.add(voucherMap);
        }

        return arrayList;
    }

    public static SynerisePromotions getInstance() {
        if (instance == null) {
            instance = new SynerisePromotions();
        }
        return instance;
    }
}
