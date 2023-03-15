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
    }
}

#pragma mark - Private

- (void)overwriteDefaultSettings {
    SNRSynerise.settings.tracker.autoTracking.enabled = NO;
}

#pragma mark - Methods

- (void)initialize:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSDictionary *initializationParameters = dictionary[@"initializationParameters"];

    NSString *clientApiKey = [initializationParameters getStringForKey:@"clientApiKey"];
    NSString *baseUrl = [initializationParameters getStringForKey:@"baseUrl"];
    BOOL debugModeEnabled = [initializationParameters getBoolForKey:@"debugModeEnabled"];
    BOOL crashHandlingEnabled = [initializationParameters getBoolForKey:@"crashHandlingEnabled"];

    [self overwriteDefaultSettings];
    
    [SNRSynerise initializeWithClientApiKey:clientApiKey andBaseUrl:baseUrl];
    [SNRSynerise setDebugModeEnabled:debugModeEnabled];
    [SNRSynerise setCrashHandlingEnabled:crashHandlingEnabled];
    [SNRSynerise setHostApplicationType:SNRHostApplicationTypeFlutter];

    result(@YES);
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

- (void)SNR_handledActionWithURL:(NSURL *)url activity:(SNRSyneriseActivity)activity completionHandler:(SNRSyneriseActivityCompletionHandler)completionHandler {
    if (activity == SNRSyneriseActivityInAppMessage) {
        return;
    }
    
    completionHandler(SNRSyneriseActivityActionHide, ^{
        [[FSyneriseManager sharedInstance].injector executeURLAction:url];
    });
}

- (void)SNR_handledActionWithDeepLink:(NSString *)deepLink activity:(SNRSyneriseActivity)activity completionHandler:(SNRSyneriseActivityCompletionHandler)completionHandler {
    if (activity == SNRSyneriseActivityInAppMessage) {
        return;
    }
    
    completionHandler(SNRSyneriseActivityActionHide, ^{
        [[FSyneriseManager sharedInstance].injector executeDeepLinkAction:deepLink];
    });
}

@end

NS_ASSUME_NONNULL_END
