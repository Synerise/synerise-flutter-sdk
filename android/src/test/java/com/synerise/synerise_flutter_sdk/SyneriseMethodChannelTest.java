package com.synerise.synerise_flutter_sdk;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.nio.ByteBuffer;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class SyneriseMethodChannelTest {

    private FakeBinaryMessenger uiEngineMessenger;
    private FakeBinaryMessenger backgroundEngineMessenger;

    @Before
    public void setUp() {
        SyneriseMethodChannel.methodChannel = null;
        uiEngineMessenger = new FakeBinaryMessenger();
        backgroundEngineMessenger = new FakeBinaryMessenger();
    }

    @After
    public void tearDown() {
        SyneriseMethodChannel.methodChannel = null;
    }

    @Test
    public void invokeMethodIfChannelAttachedDoesNothingWhenNoChannelIsBound() {
        assertFalse(SyneriseMethodChannel.isChannelAttached());

        SyneriseMethodChannel.invokeMethodIfChannelAttached("Injector#InjectorInAppMessageListener#onPresent", null);
    }

    @Test
    public void invokeMethodIfChannelAttachedSendsOnTheBoundChannel() {
        SyneriseMethodChannel.bindChannel(SyneriseMethodChannel.createChannel(uiEngineMessenger));

        SyneriseMethodChannel.invokeMethodIfChannelAttached("Injector#InjectorInAppMessageListener#onPresent", null);

        assertEquals(1, uiEngineMessenger.sentMessageCount);
        assertEquals(SyneriseMethodChannel.REVERSE_CHANNEL_NAME, uiEngineMessenger.lastChannelName);
    }

    @Test
    public void invokeMethodIfChannelAttachedDropsInlineListenerCallsWhenNoChannelIsBound() {
        SyneriseMethodChannel.invokeMethodIfChannelAttached(
                "Injector#InjectorInlineInAppMessageListener#onInlineInAppAvailable", null);

        assertEquals(0, uiEngineMessenger.sentMessageCount);
    }

    @Test
    public void delayedMethodCallDoesNothingWhenNoChannelIsGiven() {
        SyneriseMethodChannel.delayedMethodCall(null, "Injector#InjectorListener#onDeepLink", null, 0);
    }

    @Test
    public void bindChannelIfNoneBoundBindsWhenNothingIsBoundYet() {
        MethodChannel backgroundEngineChannel = SyneriseMethodChannel.createChannel(backgroundEngineMessenger);

        SyneriseMethodChannel.bindChannelIfNoneBound(backgroundEngineChannel);

        assertSame(backgroundEngineChannel, SyneriseMethodChannel.methodChannel);
    }

    @Test
    public void bindChannelIfNoneBoundKeepsTheAlreadyBoundChannel() {
        MethodChannel uiEngineChannel = SyneriseMethodChannel.createChannel(uiEngineMessenger);
        SyneriseMethodChannel.bindChannel(uiEngineChannel);

        SyneriseMethodChannel.bindChannelIfNoneBound(SyneriseMethodChannel.createChannel(backgroundEngineMessenger));

        assertSame(uiEngineChannel, SyneriseMethodChannel.methodChannel);
    }

    @Test
    public void bindChannelReplacesTheBackgroundEngineChannelWhenTheActivityEngineAttaches() {
        SyneriseMethodChannel.bindChannelIfNoneBound(SyneriseMethodChannel.createChannel(backgroundEngineMessenger));
        MethodChannel uiEngineChannel = SyneriseMethodChannel.createChannel(uiEngineMessenger);

        SyneriseMethodChannel.bindChannel(uiEngineChannel);
        SyneriseMethodChannel.invokeMethodIfChannelAttached("Injector#InjectorInAppMessageListener#onPresent", null);

        assertSame(uiEngineChannel, SyneriseMethodChannel.methodChannel);
        assertEquals(1, uiEngineMessenger.sentMessageCount);
        assertEquals(0, backgroundEngineMessenger.sentMessageCount);
    }

    @Test
    public void unbindChannelClearsTheBoundChannel() {
        MethodChannel uiEngineChannel = SyneriseMethodChannel.createChannel(uiEngineMessenger);
        SyneriseMethodChannel.bindChannel(uiEngineChannel);

        SyneriseMethodChannel.unbindChannel(uiEngineChannel);

        assertNull(SyneriseMethodChannel.methodChannel);
        assertFalse(SyneriseMethodChannel.isChannelAttached());
    }

    @Test
    public void unbindChannelKeepsTheBoundChannelWhenAnotherEngineDetaches() {
        MethodChannel uiEngineChannel = SyneriseMethodChannel.createChannel(uiEngineMessenger);
        SyneriseMethodChannel.bindChannel(uiEngineChannel);

        SyneriseMethodChannel.unbindChannel(SyneriseMethodChannel.createChannel(backgroundEngineMessenger));

        assertSame(uiEngineChannel, SyneriseMethodChannel.methodChannel);
        assertTrue(SyneriseMethodChannel.isChannelAttached());
    }

    private static class FakeBinaryMessenger implements BinaryMessenger {

        int sentMessageCount;
        String lastChannelName;

        @Override
        public void send(String channelName, ByteBuffer message) {
            send(channelName, message, null);
        }

        @Override
        public void send(String channelName, ByteBuffer message, BinaryReply callback) {
            sentMessageCount++;
            lastChannelName = channelName;
        }

        @Override
        public void setMessageHandler(String channelName, BinaryMessageHandler handler) {
        }
    }
}
