//
//  FBaseModule.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <SyneriseSDK/SyneriseSDK.h>
#import "NSDictionary+Flutter.h"
#import "NSMutableDictionary+Flutter.h"
#import "FMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBaseModule : NSObject

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod;

- (FlutterError *)defaultFlutterError;
- (FlutterError *)makeFlutterErrorWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
