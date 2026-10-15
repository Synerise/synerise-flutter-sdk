package com.synerise.synerise_flutter_sdk.views;

import static org.junit.Assert.assertEquals;

import com.synerise.sdk.injector.inapp.inline.InlineInAppSize;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/**
 * Locks the wire names of the onSizeChanged payload. Dart reads them in InlineInAppSize.fromMap and
 * defaults anything missing to zero, so a rename here would silently zero the app's measurements while
 * every existing test stayed green.
 */
public class InlineInAppSizePayloadTest {

    private static final int WIDTH_PX = 1080;
    private static final int HEIGHT_PX = 450;
    private static final float WIDTH_DP = 360f;
    private static final float HEIGHT_DP = 150f;
    private static final float WIDTH_SCREEN_RATIO = 1f;
    private static final float HEIGHT_SCREEN_RATIO = 0.1875f;

    private static InlineInAppSize size() {
        return new InlineInAppSize(WIDTH_PX, HEIGHT_PX, WIDTH_DP, HEIGHT_DP,
                WIDTH_SCREEN_RATIO, HEIGHT_SCREEN_RATIO);
    }

    @Test
    public void putSizeInto_carriesEveryMeasurementUnderTheNameDartReads() {
        Map<String, Object> payload = InlineInAppPlatformView.putSizeInto(new HashMap<>(), size());

        assertEquals(WIDTH_PX, payload.get("widthPx"));
        assertEquals(HEIGHT_PX, payload.get("heightPx"));
        assertEquals((double) WIDTH_DP, payload.get("width"));
        assertEquals((double) HEIGHT_DP, payload.get("height"));
        assertEquals((double) WIDTH_SCREEN_RATIO, payload.get("widthScreenRatio"));
        assertEquals((double) HEIGHT_SCREEN_RATIO, payload.get("heightScreenRatio"));
    }

    @Test
    public void putSizeInto_addsExactlyTheSixMeasurementKeys() {
        Map<String, Object> payload = InlineInAppPlatformView.putSizeInto(new HashMap<>(), size());

        assertEquals(Set.of("widthPx", "heightPx", "width", "height",
                "widthScreenRatio", "heightScreenRatio"), payload.keySet());
    }

    @Test
    public void putSizeInto_widensDensityIndependentValuesToDouble() {
        Map<String, Object> payload = InlineInAppPlatformView.putSizeInto(new HashMap<>(), size());

        assertEquals(Double.class, payload.get("width").getClass());
        assertEquals(Double.class, payload.get("height").getClass());
        assertEquals(Integer.class, payload.get("widthPx").getClass());
    }

    @Test
    public void putSizeInto_keepsTheCampaignDataAlreadyInThePayload() {
        Map<String, Object> payload = new HashMap<>();
        payload.put("data", "campaign-data");

        InlineInAppPlatformView.putSizeInto(payload, size());

        assertEquals("campaign-data", payload.get("data"));
    }
}
