//
//  FSynerisePlugin.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FSynerisePlugin.h"
#import "FSynerise.h"
#import "FSettings.h"
#import "FClient.h"
#import "FTracker.h"
#import "FContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSynerisePlugin ()

@end

@implementation FSynerisePlugin

#pragma mark - Static

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"synerise_flutter_sdk" binaryMessenger:[registrar messenger]];
    FSynerisePlugin *plugin = [[FSynerisePlugin alloc] init];
    
    [registrar addMethodCallDelegate:plugin channel:channel];
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
        @"Settings": [FSettings sharedInstance],
        @"Synerise": [FSynerise sharedInstance],
        @"Client": [FClient sharedInstance],
        @"Tracker": [FTracker sharedInstance],
        @"Content": [FContent sharedInstance]
    };

    FBaseModule *module = [availableModules objectForKey:callMethodModule];
    if (module != nil) {
        [module handleMethodCall:call result:result calledMethod:calledMethod];
    }
}

@end

NS_ASSUME_NONNULL_END
