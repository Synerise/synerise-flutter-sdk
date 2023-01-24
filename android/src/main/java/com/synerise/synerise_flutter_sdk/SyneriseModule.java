package com.synerise.synerise_flutter_sdk;

import com.synerise.sdk.error.ApiError;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public interface SyneriseModule {
    void handleMethodCall(MethodCall call, Result result, String calledMethod);

    static Result executeFailureResult(ApiError apiError, Result result) {

        String errorCode = Integer.toString(apiError.getHttpCode());
        if (errorCode == null) {
            errorCode = "";
        }
        String errorMessage = apiError.getErrorType().toString();
        if (errorMessage == null) {
            errorMessage = "";
        }
        Object errorDetails = apiError.getErrorBody().getMessage();
        if (errorDetails == null) {
            errorDetails = "";
        }

        result.error(errorCode, errorMessage, errorDetails);
        return result;
    }

    static Result executeSuccessResult(Object data, Result result) {
        result.success(data);
        return result;
    }
}
