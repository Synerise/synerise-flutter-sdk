package com.synerise.synerise_flutter_sdk.views;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import com.synerise.synerise_flutter_sdk.views.InlineInAppPlatformView.InlineInAppViewCommands;

import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Exercises the command dispatch and dispose ordering of InlineInAppPlatformView through hand-written
 * fakes; the concrete InlineInAppView (a FrameLayout) and the Flutter MethodChannel are not JVM-testable.
 */
public class InlineInAppPlatformViewTest {

    private static final class RecordingCommands implements InlineInAppViewCommands {
        final List<String> invocations = new ArrayList<>();
        String lastPlacementKey;
        String lastIdentifier;
        boolean rendered;
        Map<String, Object> data;

        @Override
        public void render() {
            invocations.add("render");
        }

        @Override
        public void release() {
            invocations.add("release");
        }

        @Override
        public void setPlacementKey(String placementKey) {
            invocations.add("setPlacementKey");
            lastPlacementKey = placementKey;
        }

        @Override
        public void setIdentifier(String identifier) {
            invocations.add("setIdentifier");
            lastIdentifier = identifier;
        }

        @Override
        public void clearViewListener() {
            invocations.add("clearViewListener");
        }

        @Override
        public boolean isRendered() {
            invocations.add("isRendered");
            return rendered;
        }

        @Override
        public Map<String, Object> getData() {
            invocations.add("getData");
            return data;
        }
    }

    @Test
    public void dispatchCommand_givenRender_shouldCallRenderOnly() {
        RecordingCommands commands = new RecordingCommands();

        Object value = InlineInAppPlatformView.dispatchCommand("render", null, commands);

        assertEquals(List.of("render"), commands.invocations);
        assertNull(value);
    }

    @Test
    public void dispatchCommand_givenRelease_shouldCallReleaseOnly() {
        RecordingCommands commands = new RecordingCommands();

        InlineInAppPlatformView.dispatchCommand("release", null, commands);

        assertEquals(List.of("release"), commands.invocations);
    }

    @Test
    public void dispatchCommand_givenSetPlacementKey_shouldForwardArgument() {
        RecordingCommands commands = new RecordingCommands();

        InlineInAppPlatformView.dispatchCommand("setPlacementKey", "checkout", commands);

        assertEquals(List.of("setPlacementKey"), commands.invocations);
        assertEquals("checkout", commands.lastPlacementKey);
    }

    @Test
    public void dispatchCommand_givenSetIdentifier_shouldForwardArgument() {
        RecordingCommands commands = new RecordingCommands();

        InlineInAppPlatformView.dispatchCommand("setIdentifier", "variant-b", commands);

        assertEquals(List.of("setIdentifier"), commands.invocations);
        assertEquals("variant-b", commands.lastIdentifier);
    }

    @Test
    public void dispatchCommand_givenIsRendered_shouldReturnTheViewState() {
        RecordingCommands commands = new RecordingCommands();
        commands.rendered = true;

        Object value = InlineInAppPlatformView.dispatchCommand("isRendered", null, commands);

        assertEquals(List.of("isRendered"), commands.invocations);
        assertEquals(Boolean.TRUE, value);
    }

    @Test
    public void dispatchCommand_givenGetData_shouldReturnTheViewDataMap() {
        RecordingCommands commands = new RecordingCommands();
        commands.data = new HashMap<>();
        commands.data.put("campaignHash", "abc");

        Object value = InlineInAppPlatformView.dispatchCommand("getData", null, commands);

        assertEquals(List.of("getData"), commands.invocations);
        assertSame(commands.data, value);
    }

    @Test
    public void dispatchCommand_givenGetDataWithoutCampaign_shouldReturnNull() {
        RecordingCommands commands = new RecordingCommands();

        assertNull(InlineInAppPlatformView.dispatchCommand("getData", null, commands));
    }

    @Test
    public void dispatchCommand_givenUnknownCommand_shouldNotTouchTheView() {
        RecordingCommands commands = new RecordingCommands();

        InlineInAppPlatformView.dispatchCommand("nonexistent", "ignored", commands);

        assertTrue(commands.invocations.isEmpty());
    }

    @Test
    public void dispatchCommand_givenNullCommand_shouldNotTouchTheView() {
        RecordingCommands commands = new RecordingCommands();

        InlineInAppPlatformView.dispatchCommand(null, null, commands);

        assertTrue(commands.invocations.isEmpty());
    }

    @Test
    public void disposeView_shouldReleaseClearListenerThenClearChannelHandler() {
        RecordingCommands commands = new RecordingCommands();
        boolean[] channelHandlerCleared = {false};

        InlineInAppPlatformView.disposeView(commands, () -> channelHandlerCleared[0] = true);

        assertEquals(List.of("release", "clearViewListener"), commands.invocations);
        assertTrue(channelHandlerCleared[0]);
    }

    @Test
    public void disposeView_shouldClearChannelHandlerAfterReleasingView() {
        List<String> order = new ArrayList<>();
        InlineInAppViewCommands commands = new InlineInAppViewCommands() {
            @Override
            public void render() {
            }

            @Override
            public void release() {
                order.add("release");
            }

            @Override
            public void setPlacementKey(String placementKey) {
            }

            @Override
            public void setIdentifier(String identifier) {
            }

            @Override
            public void clearViewListener() {
                order.add("clearViewListener");
            }

            @Override
            public boolean isRendered() {
                return false;
            }

            @Override
            public Map<String, Object> getData() {
                return null;
            }
        };

        InlineInAppPlatformView.disposeView(commands, () -> order.add("clearChannelHandler"));

        assertEquals(List.of("release", "clearViewListener", "clearChannelHandler"), order);
    }

    @Test
    public void resolvePlacementKey_givenNonNull_shouldReturnAsIs() {
        assertEquals("home", InlineInAppPlatformView.resolvePlacementKey("home"));
    }

    @Test
    public void resolvePlacementKey_givenNull_shouldReturnEmptyString() {
        assertEquals("", InlineInAppPlatformView.resolvePlacementKey(null));
    }

    @Test
    public void resolvePlacementKey_givenEmptyString_shouldReturnEmptyString() {
        assertEquals("", InlineInAppPlatformView.resolvePlacementKey(""));
    }
}
