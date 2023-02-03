//
//  FSynerise.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FSynerise.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSynerise () <SNRSyneriseDelegate>

@end

@implementation FSynerise

#pragma mark - Static

+ (FSynerise *)sharedInstance {
    static FSynerise *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Lifecycle

- (FSynerise *)init {
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

}

- (void)SNR_initializationError:(NSError *)error {

}

@end

NS_ASSUME_NONNULL_END
