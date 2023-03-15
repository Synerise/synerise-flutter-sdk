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

- (void)executeURLAction:(NSURL *)URL;
- (void)executeDeepLinkAction:(NSString *)deepLink;

@end

NS_ASSUME_NONNULL_END
