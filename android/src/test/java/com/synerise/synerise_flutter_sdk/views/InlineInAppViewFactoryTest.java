package com.synerise.synerise_flutter_sdk.views;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import com.synerise.synerise_flutter_sdk.views.InlineInAppViewFactory.CreationParams;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

/**
 * Exercises the pure creationParams parsing that PlatformViewFactory.create relies on; the native
 * PlatformView construction that follows parsing is out of scope for JVM unit tests.
 */
public class InlineInAppViewFactoryTest {

    @Test
    public void parseCreationParams_givenPlacementKeyAndIdentifier_shouldReadBoth() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", "home_banner");
        arguments.put("identifier", "variant-a");

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("home_banner", creationParams.placementKey);
        assertEquals("variant-a", creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenNoIdentifierKey_shouldLeaveIdentifierNull() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", "home_banner");

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("home_banner", creationParams.placementKey);
        assertNull(creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenMissingPlacementKey_shouldDefaultToEmptyString() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("identifier", "variant-a");

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("", creationParams.placementKey);
        assertEquals("variant-a", creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenEmptyPlacementKey_shouldKeepEmptyString() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", "");

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("", creationParams.placementKey);
    }

    @Test
    public void parseCreationParams_givenNullPlacementKeyValue_shouldDefaultToEmptyString() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", null);
        arguments.put("identifier", null);

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("", creationParams.placementKey);
        assertNull(creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenNonStringPlacementKey_shouldDefaultToEmptyString() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", 42);
        arguments.put("identifier", 7);

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("", creationParams.placementKey);
        assertNull(creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenAdoptViewId_shouldReadIt() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", "globalonly");
        arguments.put("adoptViewId", "inline-7");

        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(arguments);

        assertEquals("globalonly", creationParams.placementKey);
        assertEquals("inline-7", creationParams.adoptViewId);
    }

    @Test
    public void parseCreationParams_givenNoAdoptViewId_shouldLeaveItNull() {
        Map<String, Object> arguments = new HashMap<>();
        arguments.put("placementKey", "home_banner");
        arguments.put("adoptViewId", null);

        assertNull(InlineInAppViewFactory.parseCreationParams(arguments).adoptViewId);
    }

    @Test
    public void parseCreationParams_givenArgsNotAMap_shouldReturnDefaults() {
        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams("not-a-map");

        assertEquals("", creationParams.placementKey);
        assertNull(creationParams.identifier);
    }

    @Test
    public void parseCreationParams_givenNullArgs_shouldReturnDefaults() {
        CreationParams creationParams = InlineInAppViewFactory.parseCreationParams(null);

        assertEquals("", creationParams.placementKey);
        assertNull(creationParams.identifier);
        assertNull(creationParams.adoptViewId);
    }
}
