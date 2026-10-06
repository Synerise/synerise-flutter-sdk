package com.synerise.synerise_flutter_sdk.modules;

import static org.junit.Assert.assertEquals;

import com.synerise.sdk.injector.callback.SyneriseSource;

import org.junit.Test;

import java.util.Map;
import java.util.Set;

/**
 * Locks the contract between the native source enum and SyneriseSource.fromString in Dart: the payload
 * carries the enum's own name, and anything Dart does not recognise falls back to notSpecified. A
 * rename on either side would silently turn every action into an unidentified source.
 */
public class SyneriseInjectorActionPayloadTest {

    @Test
    public void buildActionPayload_sendsTheEnumNameAsSource() {
        Map<String, Object> payload = SyneriseInjector.buildActionPayload(
                "url", "https://synerise.com", SyneriseSource.INLINE_IN_APP_MESSAGE);

        assertEquals("INLINE_IN_APP_MESSAGE", payload.get("source"));
        assertEquals("https://synerise.com", payload.get("url"));
    }

    @Test
    public void buildActionPayload_distinguishesInlineFromOverlay() {
        Map<String, Object> inlinePayload = SyneriseInjector.buildActionPayload(
                "url", "https://synerise.com", SyneriseSource.INLINE_IN_APP_MESSAGE);
        Map<String, Object> overlayPayload = SyneriseInjector.buildActionPayload(
                "url", "https://synerise.com", SyneriseSource.IN_APP_MESSAGE);

        assertEquals("INLINE_IN_APP_MESSAGE", inlinePayload.get("source"));
        assertEquals("IN_APP_MESSAGE", overlayPayload.get("source"));
    }

    @Test
    public void buildActionPayload_usesTheTargetKeyTheListenerExpects() {
        Map<String, Object> deepLinkPayload = SyneriseInjector.buildActionPayload(
                "deepLink", "syne://product/123", SyneriseSource.SIMPLE_PUSH);

        assertEquals(Set.of("deepLink", "source"), deepLinkPayload.keySet());
        assertEquals("syne://product/123", deepLinkPayload.get("deepLink"));
        assertEquals("SIMPLE_PUSH", deepLinkPayload.get("source"));
    }

    @Test
    public void buildActionPayload_coversEverySourceTheNativeEnumDeclares() {
        for (SyneriseSource source : SyneriseSource.values()) {
            Map<String, Object> payload =
                    SyneriseInjector.buildActionPayload("url", "https://synerise.com", source);

            assertEquals(source.name(), payload.get("source"));
        }
    }
}
