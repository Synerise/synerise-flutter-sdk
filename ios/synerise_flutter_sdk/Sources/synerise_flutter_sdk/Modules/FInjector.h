//
//  FInjector.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface FInjector : FBaseModule

- (void)executeURLAction:(NSURL *)URL source:(SNRSyneriseSource)activity;
- (void)executeDeepLinkAction:(NSString *)deepLink source:(SNRSyneriseSource)activity;

@end

NS_ASSUME_NONNULL_END
