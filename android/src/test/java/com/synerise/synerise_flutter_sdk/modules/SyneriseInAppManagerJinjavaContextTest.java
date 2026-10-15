package com.synerise.synerise_flutter_sdk.modules;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

/**
 * Exercises the pure mapping from the app-owned in-app context to the Jinja context handed to the
 * native SDK when a campaign with a dynamic variant is rendered. Reading `Injector.inAppContext`
 * itself is a static SDK call and is out of scope for JVM unit tests.
 */
public class SyneriseInAppManagerJinjavaContextTest {

    @Test
    public void jinjavaContextFrom_givenMapUnderKey_shouldReturnItsEntries() {
        Map<String, Object> jinjavaContext = new HashMap<>();
        jinjavaContext.put("tier", "gold");
        jinjavaContext.put("cart", 3);
        Map<String, Object> inAppContext = new HashMap<>();
        inAppContext.put("jinjavaContext", jinjavaContext);
        inAppContext.put("unrelated", "value");

        HashMap<String, Object> result = SyneriseInAppManager.jinjavaContextFrom(inAppContext);

        assertEquals(2, result.size());
        assertEquals("gold", result.get("tier"));
        assertEquals(3, result.get("cart"));
    }

    @Test
    public void jinjavaContextFrom_shouldReturnACopyNotTheStoredMap() {
        Map<String, Object> jinjavaContext = new HashMap<>();
        jinjavaContext.put("tier", "gold");
        Map<String, Object> inAppContext = new HashMap<>();
        inAppContext.put("jinjavaContext", jinjavaContext);

        HashMap<String, Object> result = SyneriseInAppManager.jinjavaContextFrom(inAppContext);
        result.put("mutated", true);

        assertNotSame(jinjavaContext, result);
        assertEquals(1, jinjavaContext.size());
    }

    @Test
    public void jinjavaContextFrom_givenNonMapUnderKey_shouldReturnEmptyMap() {
        Map<String, Object> inAppContext = new HashMap<>();
        inAppContext.put("jinjavaContext", "not a map");

        assertTrue(SyneriseInAppManager.jinjavaContextFrom(inAppContext).isEmpty());
    }

    @Test
    public void jinjavaContextFrom_givenMissingKey_shouldReturnEmptyMap() {
        Map<String, Object> inAppContext = new HashMap<>();
        inAppContext.put("tier", "gold");

        assertTrue(SyneriseInAppManager.jinjavaContextFrom(inAppContext).isEmpty());
    }

    @Test
    public void jinjavaContextFrom_givenNullContext_shouldReturnEmptyMap() {
        assertTrue(SyneriseInAppManager.jinjavaContextFrom(null).isEmpty());
    }
}
