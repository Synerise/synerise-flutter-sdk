package com.synerise.synerise_flutter_sdk.views;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

/**
 * Exercises the retain/take store behind InlineInAppViewRegistry with plain objects; the concrete
 * InlineInAppView (an Android View) is not JVM-testable, so the store is generic and the registry
 * only binds it to InlineInAppView::release.
 */
public class InlineInAppViewRegistryTest {

    private final List<String> released = new ArrayList<>();
    private final InlineInAppViewRegistry.Store<String> store = new InlineInAppViewRegistry.Store<>(released::add);

    @Test
    public void retain_shouldReturnUniqueIdsPerCall() {
        String first = store.retain("home", "view-1");
        String second = store.retain("checkout", "view-2");

        assertNotEquals(first, second);
    }

    @Test
    public void take_givenRetainedId_shouldReturnTheViewOnceOnly() {
        String id = store.retain("home", "view-1");

        assertSame("view-1", store.take(id));
        assertNull(store.take(id));
    }

    @Test
    public void take_givenUnknownId_shouldReturnNull() {
        assertNull(store.take("inline-999"));
    }

    @Test
    public void retain_givenSamePlacementKeyAgain_shouldReleaseTheSupersededView() {
        String stale = store.retain("home", "view-1");
        store.retain("home", "view-2");

        assertEquals(List.of("view-1"), released);
        assertNull(store.take(stale));
    }

    @Test
    public void retain_givenDifferentPlacementKey_shouldKeepEarlierViews() {
        String first = store.retain("home", "view-1");
        store.retain("checkout", "view-2");

        assertTrue(released.isEmpty());
        assertSame("view-1", store.take(first));
    }

    @Test
    public void take_shouldNotReleaseTheHandedOverView() {
        String id = store.retain("home", "view-1");
        store.take(id);

        assertTrue(released.isEmpty());
    }
}
