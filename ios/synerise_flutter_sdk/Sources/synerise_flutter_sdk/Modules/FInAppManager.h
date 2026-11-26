//
//  FInAppManager.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FInAppManager : NSObject

- (void)activate;

- (void)closeInAppMessage:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)setInlineInAppListenerEnabled:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)removeInlineInAppListener:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)resolveInAppCustomMethod:(FlutterMethodCall *)call result:(FlutterResult)result;
- (void)resolveInlineCustomMethod:(FlutterMethodCall *)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
