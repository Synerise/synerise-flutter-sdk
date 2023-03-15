//
//  FSynerisePlugin.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FSynerisePlugin.h"
#import "FSyneriseManager.h"
#import "FBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSynerisePlugin ()

@end

@implementation FSynerisePlugin

#pragma mark - Static

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *mainChannel = [FlutterMethodChannel methodChannelWithName:@"synerise_flutter_sdk" binaryMessenger:[registrar messenger]];
    FlutterMethodChannel *reverseChannel = [FlutterMethodChannel methodChannelWithName:@"synerise_dart_channel" binaryMessenger:[registrar messenger]];
    FlutterMethodChannel *backgroundChannel = [[FlutterMethodChannel alloc] initWithName:@"synerise_flutter_sdk_background" binaryMessenger:[registrar messenger] codec:[FlutterStandardMethodCodec sharedInstance] taskQueue:[[registrar messenger] makeBackgroundTaskQueue]];
    
    FSynerisePlugin *plugin = [[FSynerisePlugin alloc] init];
    [registrar addMethodCallDelegate:plugin channel:mainChannel];
    [registrar addMethodCallDelegate:plugin channel:reverseChannel];
    [registrar addMethodCallDelegate:plugin channel:backgroundChannel];
    
    [FSyneriseManager sharedInstance].mainChannel = mainChannel;
    [FSyneriseManager sharedInstance].reverseChannel = reverseChannel;
    [FSyneriseManager sharedInstance].backgroundChannel = backgroundChannel;
    
    [[FSyneriseManager sharedInstance] createModules];
}

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *callMethod = call.method;
    NSArray *callMethodComponents = [callMethod componentsSeparatedByString:@"/"];
    if ([callMethodComponents count] != 2) {
        return;
    }

    NSString *callMethodModule = callMethodComponents.firstObject;
    NSString *calledMethod = callMethodComponents.lastObject;
        
     NSDictionary *availableModules = @{
        @"Settings": [FSyneriseManager sharedInstance].settings,
        @"Synerise": [FSyneriseManager sharedInstance].synerise,
        @"Notifications": [FSyneriseManager sharedInstance].notifications,
        @"Client": [FSyneriseManager sharedInstance].client,
        @"Tracker": [FSyneriseManager sharedInstance].tracker,
        @"Injector": [FSyneriseManager sharedInstance].injector,
        @"Content": [FSyneriseManager sharedInstance].content
    };

    FBaseModule *module = [availableModules objectForKey:callMethodModule];
    if (module != nil) {
        [module handleMethodCall:call result:result calledMethod:calledMethod];
    }
}

@end

NS_ASSUME_NONNULL_END
