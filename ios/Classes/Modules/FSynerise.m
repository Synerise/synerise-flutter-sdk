//
//  FSynerise.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FSynerise.h"
#import "FSyneriseManager.h"
#import "FNotifications.h"
#import "FInjector.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const sdkPluginVersion = @"2.1.0";

@interface FSynerise () <SNRSyneriseDelegate>

@end

@implementation FSynerise

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [SNRSynerise setDelegate:self];
    }
    
    return self;
}

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"initialize"]) {
        [self initialize:call result:result];
    } else if ([calledMethod isEqualToString:@"changeApiKey"]) {
        [self changeApiKey:call result:result];}
}

#pragma mark - Private

- (void)overwriteDefaultSettings {
    SNRSynerise.settings.tracker.autoTracking.enabled = NO;
}

#pragma mark - Methods

- (void)initialize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSDictionary *initializationParameters = dictionary[@"initializationParameters"];
    
    NSString *apiKey = [initializationParameters getStringForKey:@"apiKey"];
    NSString *baseUrl = [initializationParameters getStringForKey:@"baseUrl"];
    NSString *requestValidationSalt = [initializationParameters getStringForKey:@"requestValidationSalt"];
    BOOL debugModeEnabled = [initializationParameters getBoolForKey:@"debugModeEnabled"];
    BOOL crashHandlingEnabled = [initializationParameters getBoolForKey:@"crashHandlingEnabled"];
    
    [self overwriteDefaultSettings];
    
    [SNRSynerise initializeWithApiKey:apiKey andBaseUrl:baseUrl];
    if (requestValidationSalt != nil) {
        [SNRSynerise setRequestValidationSalt:requestValidationSalt];
    }
    [SNRSynerise setDebugModeEnabled:debugModeEnabled];
    [SNRSynerise setCrashHandlingEnabled:crashHandlingEnabled];
    [SNRSynerise setHostApplicationType:SNRHostApplicationTypeFlutter];
    [SNRSynerise setHostApplicationSDKPluginVersion:sdkPluginVersion];
    result([NSNumber numberWithBool:YES]);
}

- (void)changeApiKey:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *apiKey = [dictionary getStringForKey:@"apiKey"];
    if (apiKey == nil) {
        result([self defaultFlutterError]);
        return;
    }

    SNRInitializationConfig *initializationConfig = [SNRInitializationConfig new];
    NSDictionary *initializationConfigDictionary = [dictionary getDictionaryForKey:@"config"];
    if (initializationConfigDictionary != nil) {
        NSString *requestValidationSalt = [initializationConfigDictionary getStringForKey:@"requestValidationSalt"];
        if (requestValidationSalt != nil) {
            initializationConfig.requestValidationSalt = requestValidationSalt;
        }
    }

    [SNRSynerise changeApiKey:apiKey config:initializationConfig];
    result([NSNumber numberWithBool:YES]);
}

#pragma mark - SNRSyneriseDelegate

- (void)SNR_initialized {
    [[FSyneriseManager sharedInstance] notifyModulesWhenSyneriseInitialized];
}

- (void)SNR_initializationError:(NSError *)error {
    
}

- (void)SNR_registerForPushNotificationsIsNeeded {
    [[FSyneriseManager sharedInstance].notifications executeRegistrationRequired];
}

- (void)SNR_handledActionWithURL:(NSURL *)url source:(SNRSyneriseSource)source {
    [[FSyneriseManager sharedInstance].injector executeURLAction:url source:source];
}

- (void)SNR_handledActionWithDeepLink:(NSString *)deepLink source:(SNRSyneriseSource)source {
    [[FSyneriseManager sharedInstance].injector executeDeepLinkAction:deepLink source:source];
}

@end

NS_ASSUME_NONNULL_END
