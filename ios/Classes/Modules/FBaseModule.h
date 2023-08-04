//
//  FBaseModule.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <SyneriseSDK/SyneriseSDK.h>
#import "FSyneriseManager.h"
#import "NSDictionary+Flutter.h"
#import "NSMutableDictionary+Flutter.h"
#import "FMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBaseModule : NSObject

- (void)syneriseInitialized;

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod;

- (FlutterError *)defaultFlutterError;
- (FlutterError *)makeFlutterErrorWithError:(NSError *)error;
- (FlutterError *)makeFlutterErrorWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
