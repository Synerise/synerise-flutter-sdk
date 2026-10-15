package com.synerise.synerise_flutter_sdk.modules;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import com.synerise.sdk.injector.inapp.InAppCustomMethodCompletion;
import com.synerise.sdk.injector.inapp.inline.InlineInAppMessageData;

import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Exercises the pure inline-in-app helpers of SyneriseInjector: the pending custom-method completion
 * registry, resolve/fail behaviour, the inline dataMap contract, and the release-before-emit ordering.
 * The native emit path (main Handler + static MethodChannel) is out of scope for JVM unit tests.
 */
public class SyneriseInjectorInlineTest {

    private static final class RecordingCompletion implements InAppCustomMethodCompletion {
        boolean successCalled;
        Object successResult;
        boolean failureCalled;
        String failureMessage;

        @Override
        public void success(Object result) {
            successCalled = true;
            successResult = result;
        }

        @Override
        public void failure(String errorMessage) {
            failureCalled = true;
            failureMessage = errorMessage;
        }
    }

    private ConcurrentHashMap<String, InAppCustomMethodCompletion> pendingCompletions;

    @Before
    public void setUp() {
        pendingCompletions = SyneriseInAppManager.pendingInlineCustomMethodCompletions();
        pendingCompletions.clear();
    }

    @Test
    public void resolveInlineCustomMethod_givenSuccessWithResult_shouldPassResultToCompletion() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-1", completion);
        Map<String, Object> result = new HashMap<>();
        result.put("status", "ok");

        SyneriseInAppManager.resolveInlineCustomMethod("call-1", true, result, null);

        assertTrue(completion.successCalled);
        assertEquals(result, completion.successResult);
        assertFalse(completion.failureCalled);
    }

    @Test
    public void resolveInlineCustomMethod_givenSuccessWithNullResult_shouldPassNullToCompletion() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-2", completion);

        SyneriseInAppManager.resolveInlineCustomMethod("call-2", true, null, null);

        assertTrue(completion.successCalled);
        assertNull(completion.successResult);
    }

    @Test
    public void resolveInlineCustomMethod_givenFailure_shouldPassErrorToCompletion() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-3", completion);

        SyneriseInAppManager.resolveInlineCustomMethod("call-3", false, null, "BOOM");

        assertTrue(completion.failureCalled);
        assertEquals("BOOM", completion.failureMessage);
        assertFalse(completion.successCalled);
    }

    @Test
    public void resolveInlineCustomMethod_givenUnknownCallId_shouldDoNothing() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("known", completion);

        SyneriseInAppManager.resolveInlineCustomMethod("unknown", true, null, null);

        assertFalse(completion.successCalled);
        assertFalse(completion.failureCalled);
        assertTrue(pendingCompletions.containsKey("known"));
    }

    @Test
    public void resolveInlineCustomMethod_shouldRemoveCompletionSoItCannotResolveTwice() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-4", completion);

        SyneriseInAppManager.resolveInlineCustomMethod("call-4", true, "first", null);
        SyneriseInAppManager.resolveInlineCustomMethod("call-4", false, null, "second");

        assertFalse(pendingCompletions.containsKey("call-4"));
        assertTrue(completion.successCalled);
        assertEquals("first", completion.successResult);
        assertFalse(completion.failureCalled);
    }

    @Test
    public void failPendingInlineCustomMethodCompletions_shouldFailEveryPendingCompletionAndClearMap() {
        RecordingCompletion first = new RecordingCompletion();
        RecordingCompletion second = new RecordingCompletion();
        pendingCompletions.put("call-a", first);
        pendingCompletions.put("call-b", second);

        SyneriseInAppManager.failPendingInlineCustomMethodCompletions();

        assertTrue(first.failureCalled);
        assertEquals("LISTENER_REMOVED", first.failureMessage);
        assertTrue(second.failureCalled);
        assertEquals("LISTENER_REMOVED", second.failureMessage);
        assertTrue(pendingCompletions.isEmpty());
    }

    @Test
    public void failPendingInlineCustomMethodCompletions_givenThrowingCompletion_shouldStillClearMap() {
        InAppCustomMethodCompletion throwing = new InAppCustomMethodCompletion() {
            @Override
            public void success(Object result) {
            }

            @Override
            public void failure(String errorMessage) {
                throw new IllegalStateException("bridge gone");
            }
        };
        RecordingCompletion healthy = new RecordingCompletion();
        pendingCompletions.put("throwing", throwing);
        pendingCompletions.put("healthy", healthy);

        SyneriseInAppManager.failPendingInlineCustomMethodCompletions();

        assertTrue(pendingCompletions.isEmpty());
    }

    @Test
    public void failPendingInlineCustomMethodCompletions_givenEmptyMap_shouldBeNoOp() {
        SyneriseInAppManager.failPendingInlineCustomMethodCompletions();

        assertTrue(pendingCompletions.isEmpty());
    }

    @Test
    public void createMapFromInlineInAppMessageData_givenFullData_shouldMapEveryKey() {
        Map<String, Object> additionalParameters = new HashMap<>();
        additionalParameters.put("segment", "vip");
        InlineInAppMessageData data = new InlineInAppMessageData("hash-1", "variant-1", "placement-1", additionalParameters, true);

        Map<String, Object> dataMap = SyneriseInAppManager.createMapFromInlineInAppMessageData(data);

        assertEquals("hash-1", dataMap.get("campaignHash"));
        assertEquals("variant-1", dataMap.get("variantIdentifier"));
        assertEquals("placement-1", dataMap.get("placementKey"));
        assertEquals(additionalParameters, dataMap.get("additionalParameters"));
        assertEquals(true, dataMap.get("isTest"));
    }

    @Test
    public void createMapFromInlineInAppMessageData_givenNullAdditionalParameters_shouldEmitEmptyMap() {
        InlineInAppMessageData data = new InlineInAppMessageData("hash-2", "variant-2", "placement-2", null, false);

        Map<String, Object> dataMap = SyneriseInAppManager.createMapFromInlineInAppMessageData(data);

        assertEquals(new HashMap<>(), dataMap.get("additionalParameters"));
        assertEquals(false, dataMap.get("isTest"));
    }

    @Test
    public void createMapFromInlineInAppMessageData_givenNullData_shouldReturnEmptyMap() {
        Map<String, Object> dataMap = SyneriseInAppManager.createMapFromInlineInAppMessageData(null);

        assertTrue(dataMap.isEmpty());
    }
}
