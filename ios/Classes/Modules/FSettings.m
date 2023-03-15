//
//  FSettings.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FSettings.h"

static NSString * const FSettingsSDKEnabled = @"SDK_ENABLED";
static NSString * const FSettingsSDKAppGroupIdentifier = @"SDK_APP_GROUP_IDENTIFIER";
static NSString * const FSettingsSDKKeychainGroupIdentifier = @"SDK_KEYCHAIN_GROUP_IDENTIFIER";
static NSString * const FSettingsSDKMinTokenRefreshInterval = @"SDK_MIN_TOKEN_REFRESH_INTERVAL";
static NSString * const FSettingsSDKShouldDestroySessionOnApiKeyChange = @"SDK_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE";

static NSString * const FSettingsTrackerIsBackendTimeSyncRequired = @"TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED";
static NSString * const FSettingsTrackerMinBatchSize = @"TRACKER_MIN_BATCH_SIZE";
static NSString * const FSettingsTrackerMaxBatchSize = @"TRACKER_MAX_BATCH_SIZE";
static NSString * const FSettingsTrackerAutoFlushTimeout = @"TRACKER_AUTO_FLUSH_TIMEOUT";

static NSString * const FSettingsNotificationsEnabled = @"NOTIFICATIONS_ENABLED";
static NSString * const FSettingsNotificationsEncryption = @"NOTIFICATIONS_ENCRYPTION";
static NSString * const FSettingsNotificationsDisableInAppAlerts = @"NOTIFICATIONS_DISABLE_IN_APP_ALERTS";

static NSString * const FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit = @"IN_APP_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT";
static NSString * const FSettingsInAppMessagingRenderingTimeout = @"IN_APP_MESSAGING_RENDERING_TIMEOUT";

static NSString * const FSettingsInjectorAutomatic = @"INJECTOR_AUTOMATIC";

NS_ASSUME_NONNULL_BEGIN

@interface FSettings ()

@end

@implementation FSettings

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"getAllSettings"]) {
        [self getAllSettings:call result:result];
    } else if ([calledMethod isEqualToString:@"setOne"]) {
        [self setOne:call result:result];
    } else if ([calledMethod isEqualToString:@"setMany"]) {
        [self setMany:call result:result];
    }
}

#pragma mark - Private

- (void)updateSettingsWithDictionary:(NSDictionary *)dictionary {
    [self updateSettingsKeyPath:@"sdk.enabled" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKEnabled]];
    [self updateSettingsKeyPath:@"sdk.appGroupIdentifier" expectedClass:[NSString class] object:dictionary[FSettingsSDKAppGroupIdentifier]];
    [self updateSettingsKeyPath:@"sdk.keychainGroupIdentifier" expectedClass:[NSString class] object:dictionary[FSettingsSDKKeychainGroupIdentifier]];
    [self updateSettingsKeyPath:@"sdk.minTokenRefreshInterval" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKMinTokenRefreshInterval]];
    [self updateSettingsKeyPath:@"sdk.shouldDestroySessionOnApiKeyChange" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKShouldDestroySessionOnApiKeyChange]];
    
    [self updateSettingsKeyPath:@"tracker.isBackendTimeSyncRequired" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerIsBackendTimeSyncRequired]];
    [self updateSettingsKeyPath:@"tracker.minBatchSize" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerMinBatchSize]];
    [self updateSettingsKeyPath:@"tracker.maxBatchSize" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerMaxBatchSize]];
    [self updateSettingsKeyPath:@"tracker.autoFlushTimeout" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerAutoFlushTimeout]];
    
    [self updateSettingsKeyPath:@"notifications.enabled" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsEnabled]];
    [self updateSettingsKeyPath:@"notifications.encryption" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsEncryption]];
    [self updateSettingsKeyPath:@"notifications.disableInAppAlerts" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsDisableInAppAlerts]];
    
    [self updateSettingsKeyPath:@"inAppMessaging.maxDefinitionUpdateIntervalLimit" expectedClass:[NSNumber class] object:dictionary[FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit]];
    [self updateSettingsKeyPath:@"inAppMessaging.renderingTimeout" expectedClass:[NSNumber class] object:dictionary[FSettingsInAppMessagingRenderingTimeout]];
    
    [self updateSettingsKeyPath:@"injector.automatic" expectedClass:[NSNumber class] object:dictionary[FSettingsInjectorAutomatic]];
}

- (void)updateSettingsKeyPath:(NSString *)keyPath expectedClass:(Class)expectedClass object:(nullable id)object {
    @try {
        if (object == nil) {
            return;
        }
        
        if ([object isKindOfClass:expectedClass] == NO) {
            return;
        }
        
        [SNRSynerise.settings setValue:object forKeyPath:keyPath];
    }
    @catch (NSException *expection) {}
    @finally {}
}

#pragma mark - Methods

- (void)getAllSettings:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *settingsDictionary = [self settingsDictionary];
    result(settingsDictionary);
}

- (void)setOne:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *key = dictionary[@"key"];
    id value = dictionary[@"value"];
    
    if (key == nil || value == nil) {
        result(nil);
        return;
    }
    
    NSMutableDictionary *settingsDictionary = [[self settingsDictionary] mutableCopy];
    
    if ([[settingsDictionary allKeys] containsObject:key]) {
        [self updateSettingsWithDictionary:@{ key: value }];
    }

    result(nil);
}

- (void)setMany:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    if (dictionary == nil || [dictionary count] == 0) {
        result(nil);
        return;
    }
    
    NSMutableDictionary *settingsDictionary = [[self settingsDictionary] mutableCopy];
    [settingsDictionary addEntriesFromDictionary:dictionary];
    
    [self updateSettingsWithDictionary:settingsDictionary];
    
    result(nil);
}

#pragma mark - Dart Mapping

- (NSDictionary *)settingsDictionary {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    dictionary[FSettingsSDKEnabled] = [NSNumber numberWithBool:SNRSynerise.settings.sdk.enabled];
    dictionary[FSettingsSDKAppGroupIdentifier] = SNRSynerise.settings.sdk.appGroupIdentifier ?: [NSNull null];
    dictionary[FSettingsSDKKeychainGroupIdentifier] = SNRSynerise.settings.sdk.keychainGroupIdentifier ?: [NSNull null];
    dictionary[FSettingsSDKMinTokenRefreshInterval] = [NSNumber numberWithDouble:SNRSynerise.settings.sdk.minTokenRefreshInterval];
    dictionary[FSettingsSDKShouldDestroySessionOnApiKeyChange] = [NSNumber numberWithDouble:SNRSynerise.settings.sdk.shouldDestroySessionOnApiKeyChange];
    
    dictionary[FSettingsTrackerIsBackendTimeSyncRequired] = [NSNumber numberWithBool:SNRSynerise.settings.tracker.isBackendTimeSyncRequired];
    dictionary[FSettingsTrackerMinBatchSize] = [NSNumber numberWithInteger:SNRSynerise.settings.tracker.minBatchSize];
    dictionary[FSettingsTrackerMaxBatchSize] = [NSNumber numberWithInteger:SNRSynerise.settings.tracker.maxBatchSize];
    dictionary[FSettingsTrackerAutoFlushTimeout] = [NSNumber numberWithDouble:SNRSynerise.settings.tracker.autoFlushTimeout];

    dictionary[FSettingsNotificationsEnabled] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.enabled];
    dictionary[FSettingsNotificationsEncryption] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.encryption];
    dictionary[FSettingsNotificationsDisableInAppAlerts] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.disableInAppAlerts];
    
    dictionary[FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit] = [NSNumber numberWithDouble:SNRSynerise.settings.inAppMessaging.maxDefinitionUpdateIntervalLimit];
    dictionary[FSettingsInAppMessagingRenderingTimeout] = [NSNumber numberWithDouble:SNRSynerise.settings.inAppMessaging.renderingTimeout];
    
    dictionary[FSettingsInjectorAutomatic] = [NSNumber numberWithBool:SNRSynerise.settings.injector.automatic];
    
    return dictionary;
}

@end

NS_ASSUME_NONNULL_END





