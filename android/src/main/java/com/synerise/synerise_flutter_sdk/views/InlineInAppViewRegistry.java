package com.synerise.synerise_flutter_sdk.views;

import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;

import com.synerise.sdk.injector.inapp.ui.inline.InlineInAppView;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Holds SDK-created inline views announced through the global listener until Dart mounts them.
 * A native view instance cannot cross the method channel, so the view is parked here under a
 * generated id that travels to Dart and comes back as the {@code adoptViewId} creation parameter.
 */
public final class InlineInAppViewRegistry {

    private static final Store<InlineInAppView> store = new Store<>(InlineInAppView::release);

    private InlineInAppViewRegistry() {
    }

    public static String retain(String placementKey, InlineInAppView view) {
        return store.retain(placementKey, view);
    }

    @Nullable
    static InlineInAppView take(String viewId) {
        return store.take(viewId);
    }

    /** Generic retain/take store so the policy is unit-testable without an Android View. */
    @VisibleForTesting
    static final class Store<T> {

        interface Releaser<T> {
            void release(T view);
        }

        private final Map<String, Retained<T>> retained = new HashMap<>();
        private final AtomicLong idGenerator = new AtomicLong();
        private final Releaser<T> releaser;

        Store(Releaser<T> releaser) {
            this.releaser = releaser;
        }

        synchronized String retain(String placementKey, T view) {
            releaseRetainedViewsForPlacementKey(placementKey);
            String viewId = "inline-" + idGenerator.incrementAndGet();
            retained.put(viewId, new Retained<>(placementKey, view));
            return viewId;
        }

        @Nullable
        synchronized T take(String viewId) {
            Retained<T> entry = retained.remove(viewId);
            return entry != null ? entry.view : null;
        }

        /**
         * A newer campaign for the same placement supersedes anything still waiting to be mounted,
         * so the older view is released rather than left holding a WebView forever.
         */
        private void releaseRetainedViewsForPlacementKey(String placementKey) {
            Iterator<Map.Entry<String, Retained<T>>> entries = retained.entrySet().iterator();
            while (entries.hasNext()) {
                Retained<T> entry = entries.next().getValue();
                if (Objects.equals(entry.placementKey, placementKey)) {
                    entries.remove();
                    releaser.release(entry.view);
                }
            }
        }

        private static final class Retained<T> {
            final String placementKey;
            final T view;

            Retained(String placementKey, T view) {
                this.placementKey = placementKey;
                this.view = view;
            }
        }
    }
}
