//
//  FInlineInAppViewRegistry.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNRInlineInAppView;

NS_ASSUME_NONNULL_BEGIN

/**
 * Holds SDK-created inline views announced through the global listener until Dart mounts them.
 * A native view instance cannot cross the method channel, so the view is parked here under a
 * generated id that travels to Dart and comes back as the `adoptViewId` creation parameter.
 */
@interface FInlineInAppViewRegistry : NSObject

+ (NSString *)retainInlineInAppView:(SNRInlineInAppView *)view placementKey:(nullable NSString *)placementKey;
+ (nullable SNRInlineInAppView *)takeRetainedViewWithIdentifier:(NSString *)viewIdentifier;

@end

NS_ASSUME_NONNULL_END
