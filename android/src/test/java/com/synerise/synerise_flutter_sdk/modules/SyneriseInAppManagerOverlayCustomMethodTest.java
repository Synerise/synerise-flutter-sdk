package com.synerise.synerise_flutter_sdk.modules;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import com.synerise.sdk.injector.inapp.InAppCustomMethodCompletion;

import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Exercises the overlay in-app custom-method completion registry now owned by SyneriseInAppManager,
 * so both in-app types resolve through the same code path.
 */
public class SyneriseInAppManagerOverlayCustomMethodTest {

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
        pendingCompletions = SyneriseInAppManager.pendingInAppCustomMethodCompletions();
        pendingCompletions.clear();
    }

    @Test
    public void resolveInAppCustomMethod_givenSuccessWithAnyResultType_shouldPassItThrough() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-1", completion);

        SyneriseInAppManager.resolveInAppCustomMethod("call-1", true, "plain string", null);

        assertTrue(completion.successCalled);
        assertEquals("plain string", completion.successResult);
        assertFalse(pendingCompletions.containsKey("call-1"));
    }

    @Test
    public void resolveInAppCustomMethod_givenFailureWithoutMessage_shouldFallBackToUnknownError() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-2", completion);

        SyneriseInAppManager.resolveInAppCustomMethod("call-2", false, null, null);

        assertTrue(completion.failureCalled);
        assertEquals("Unknown error.", completion.failureMessage);
    }

    @Test
    public void resolveInAppCustomMethod_givenUnknownCallId_shouldDoNothing() {
        RecordingCompletion completion = new RecordingCompletion();
        pendingCompletions.put("call-3", completion);

        SyneriseInAppManager.resolveInAppCustomMethod("other", true, new HashMap<String, Object>(), null);

        assertFalse(completion.successCalled);
        assertFalse(completion.failureCalled);
        assertTrue(pendingCompletions.containsKey("call-3"));
    }

    @Test
    public void inlineAndOverlayRegistries_shouldBeIndependent() {
        RecordingCompletion overlay = new RecordingCompletion();
        pendingCompletions.put("shared-id", overlay);
        Map<String, InAppCustomMethodCompletion> inline = SyneriseInAppManager.pendingInlineCustomMethodCompletions();
        inline.clear();

        SyneriseInAppManager.resolveInlineCustomMethod("shared-id", true, null, null);

        assertFalse(overlay.successCalled);
        assertNull(inline.get("shared-id"));
        assertTrue(pendingCompletions.containsKey("shared-id"));
    }
}
