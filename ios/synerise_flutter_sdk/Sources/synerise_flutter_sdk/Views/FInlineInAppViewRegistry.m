//
//  FInlineInAppViewRegistry.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import "FInlineInAppViewRegistry.h"

#import <SyneriseSDK/SyneriseSDK.h>

NS_ASSUME_NONNULL_BEGIN

@implementation FInlineInAppViewRegistry

static NSMutableDictionary<NSString *, SNRInlineInAppView *> *retainedViews;
static NSMutableDictionary<NSString *, NSString *> *placementKeysByIdentifier;
static NSUInteger identifierCounter;

+ (void)initialize {
    if (self == [FInlineInAppViewRegistry class]) {
        retainedViews = [NSMutableDictionary dictionary];
        placementKeysByIdentifier = [NSMutableDictionary dictionary];
        identifierCounter = 0;
    }
}

+ (NSString *)retainInlineInAppView:(SNRInlineInAppView *)view placementKey:(nullable NSString *)placementKey {
    @synchronized (self) {
        [self releaseRetainedViewsForPlacementKey:placementKey];

        identifierCounter += 1;
        NSString *viewIdentifier = [NSString stringWithFormat:@"inline-%lu", (unsigned long)identifierCounter];
        retainedViews[viewIdentifier] = view;
        if (placementKey != nil) {
            placementKeysByIdentifier[viewIdentifier] = placementKey;
        }

        return viewIdentifier;
    }
}

+ (nullable SNRInlineInAppView *)takeRetainedViewWithIdentifier:(NSString *)viewIdentifier {
    @synchronized (self) {
        SNRInlineInAppView *view = retainedViews[viewIdentifier];
        [retainedViews removeObjectForKey:viewIdentifier];
        [placementKeysByIdentifier removeObjectForKey:viewIdentifier];

        return view;
    }
}

/**
 * A newer campaign for the same placement supersedes anything still waiting to be mounted, so the
 * older view is dropped rather than left retained forever.
 */
+ (void)releaseRetainedViewsForPlacementKey:(nullable NSString *)placementKey {
    if (placementKey == nil) {
        return;
    }

    NSArray<NSString *> *identifiers = [placementKeysByIdentifier allKeys];
    for (NSString *identifier in identifiers) {
        if ([placementKeysByIdentifier[identifier] isEqualToString:placementKey] == YES) {
            SNRInlineInAppView *staleView = retainedViews[identifier];
            staleView.delegate = nil;
            [staleView removeFromSuperview];
            [retainedViews removeObjectForKey:identifier];
            [placementKeysByIdentifier removeObjectForKey:identifier];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
