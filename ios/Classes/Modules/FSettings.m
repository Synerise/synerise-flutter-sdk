//
//  FSettings.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FSettings.h"

static NSString * const FSettingsSDKEnabled = @"SDK_ENABLED";
static NSString * const FSettingsSDKDoNotTrack = @"SDK_DO_NOT_TRACK";
static NSString * const FSettingsSDKAppGroupIdentifier = @"SDK_APP_GROUP_IDENTIFIER";
static NSString * const FSettingsSDKKeychainGroupIdentifier = @"SDK_KEYCHAIN_GROUP_IDENTIFIER";
static NSString * const FSettingsSDKMinTokenRefreshInterval = @"SDK_MIN_TOKEN_REFRESH_INTERVAL";
static NSString * const FSettingsSDKShouldDestroySessionOnApiKeyChange = @"SDK_SHOULD_DESTROY_SESSION_ON_API_KEY_CHANGE";
static NSString * const FSettingsSDKLocalizable = @"SDK_LOCALIZABLE";

static NSString * const FSettingsTrackerIsBackendTimeSyncRequired = @"TRACKER_IS_BACKEND_TIME_SYNC_REQUIRED";
static NSString * const FSettingsTrackerMinBatchSize = @"TRACKER_MIN_BATCH_SIZE";
static NSString * const FSettingsTrackerMaxBatchSize = @"TRACKER_MAX_BATCH_SIZE";
static NSString * const FSettingsTrackerAutoFlushTimeout = @"TRACKER_AUTO_FLUSH_TIMEOUT";
static NSString * const FSettingsTrackerEventsTriggeringFlush = @"TRACKER_EVENTS_TRIGGERING_FLUSH";

static NSString * const FSettingsNotificationsEnabled = @"NOTIFICATIONS_ENABLED";
static NSString * const FSettingsNotificationsEncryption = @"NOTIFICATIONS_ENCRYPTION";
static NSString * const FSettingsNotificationsDisableInAppAlerts = @"NOTIFICATIONS_DISABLE_IN_APP_ALERTS";

static NSString * const FSettingsInjectorAutomatic = @"INJECTOR_AUTOMATIC";

static NSString * const FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit = @"IN_APP_MAX_DEFINITION_UPDATE_INTERVAL_LIMIT";
static NSString * const FSettingsInAppMessagingContentBaseUrl = @"IN_APP_MESSAGING_CONTENT_BASE_URL";
static NSString * const FSettingsInAppMessagingRenderingTimeout = @"IN_APP_MESSAGING_RENDERING_TIMEOUT";
static NSString * const FSSettingsInAppMessagingShouldSendInAppCappingEvent = @"IN_APP_MESSAGING_SHOULD_SEND_IN_APP_CAPPING_EVENT";
static NSString * const FSSettingsInAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch = @"IN_APP_MESSAGING_CHECK_GLOBAL_CONTROL_GROUPS_ON_DEFINITIONS_FETCH";

NS_ASSUME_NONNULL_BEGIN

@interface FSettings ()

@end

@implementation FSettings

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"getAllSettings"]) {
        [self getAllSettings:call result:result];
    } else if ([calledMethod isEqualToString:@"getOne"]) {
        [self getOne:call result:result];
    } else if ([calledMethod isEqualToString:@"setMany"]) {
        [self setMany:call result:result];
    } else if ([calledMethod isEqualToString:@"setOne"]) {
        [self setOne:call result:result];
    } 
}

#pragma mark - Private

- (void)updateSettingsWithDictionary:(NSDictionary *)dictionary {
    [self updateSettingsKeyPath:@"sdk.enabled" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKEnabled]];
    [self updateSettingsKeyPath:@"sdk.doNotTrack" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKDoNotTrack]];
    [self updateSettingsKeyPath:@"sdk.appGroupIdentifier" expectedClass:[NSString class] object:dictionary[FSettingsSDKAppGroupIdentifier]];
    [self updateSettingsKeyPath:@"sdk.keychainGroupIdentifier" expectedClass:[NSString class] object:dictionary[FSettingsSDKKeychainGroupIdentifier]];
    [self updateSettingsKeyPath:@"sdk.minTokenRefreshInterval" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKMinTokenRefreshInterval]];
    [self updateSettingsKeyPath:@"sdk.shouldDestroySessionOnApiKeyChange" expectedClass:[NSNumber class] object:dictionary[FSettingsSDKShouldDestroySessionOnApiKeyChange]];
    [self updateSettingsKeyPath:@"sdk.localizable" expectedClass:[NSDictionary class] object:[self normalizeSDKLocalizableDictionary:dictionary[FSettingsSDKLocalizable]]];
    
    [self updateSettingsKeyPath:@"tracker.isBackendTimeSyncRequired" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerIsBackendTimeSyncRequired]];
    [self updateSettingsKeyPath:@"tracker.minBatchSize" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerMinBatchSize]];
    [self updateSettingsKeyPath:@"tracker.maxBatchSize" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerMaxBatchSize]];
    [self updateSettingsKeyPath:@"tracker.autoFlushTimeout" expectedClass:[NSNumber class] object:dictionary[FSettingsTrackerAutoFlushTimeout]];
    [self updateSettingsKeyPath:@"tracker.eventsTriggeringFlush" expectedClass:[NSArray class] object:dictionary[FSettingsTrackerEventsTriggeringFlush]];
    
    [self updateSettingsKeyPath:@"notifications.enabled" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsEnabled]];
    [self updateSettingsKeyPath:@"notifications.encryption" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsEncryption]];
    [self updateSettingsKeyPath:@"notifications.disableInAppAlerts" expectedClass:[NSNumber class] object:dictionary[FSettingsNotificationsDisableInAppAlerts]];
    
    [self updateSettingsKeyPath:@"injector.automatic" expectedClass:[NSNumber class] object:dictionary[FSettingsInjectorAutomatic]];
    
    [self updateSettingsKeyPath:@"inAppMessaging.maxDefinitionUpdateIntervalLimit" expectedClass:[NSNumber class] object:dictionary[FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit]];
    [self updateSettingsKeyPath:@"inAppMessaging.contentBaseUrl" expectedClass:[NSString class] object:dictionary[FSettingsInAppMessagingContentBaseUrl]];
    [self updateSettingsKeyPath:@"inAppMessaging.renderingTimeout" expectedClass:[NSNumber class] object:dictionary[FSettingsInAppMessagingRenderingTimeout]];
    [self updateSettingsKeyPath:@"inAppMessaging.shouldSendInAppCappingEvent" expectedClass:[NSNumber class] object:dictionary[FSSettingsInAppMessagingShouldSendInAppCappingEvent]];
    [self updateSettingsKeyPath:@"inAppMessaging.checkGlobalControlGroupsOnDefinitionsFetch" expectedClass:[NSNumber class] object:dictionary[FSSettingsInAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch]];
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

- (nullable id)getSettingsForKey:(NSString *)key expectedClass:(Class)expectedClass {
    @try {
      id object;

      if ([key isEqualToString:FSettingsSDKDoNotTrack] == YES) {
          object = [NSNumber numberWithBool:SNRSynerise.settings.sdk.doNotTrack];
      }

      if ([object isKindOfClass:expectedClass] == NO) {
          return nil;
      }

      return object;
    }
    @catch (NSException *expection) {}
    @finally {}

    return nil;
}

#pragma mark - Methods

- (void)getAllSettings:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *settingsDictionary = [self settingsDictionary];
    result(settingsDictionary);
}

- (void)getOne:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *key = dictionary[@"key"];
    if (key == nil) {
        result(nil);
        return;
    }

    id settingsOption = [self getSettingsForKey:key expectedClass:[NSNumber class]];
    result(settingsOption);
    return;
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

#pragma mark - Dart Mapping

- (NSDictionary *)settingsDictionary {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    dictionary[FSettingsSDKEnabled] = [NSNumber numberWithBool:SNRSynerise.settings.sdk.enabled];
    dictionary[FSettingsSDKDoNotTrack] = [NSNumber numberWithBool:SNRSynerise.settings.sdk.doNotTrack];
    dictionary[FSettingsSDKAppGroupIdentifier] = SNRSynerise.settings.sdk.appGroupIdentifier ?: [NSNull null];
    dictionary[FSettingsSDKKeychainGroupIdentifier] = SNRSynerise.settings.sdk.keychainGroupIdentifier ?: [NSNull null];
    dictionary[FSettingsSDKMinTokenRefreshInterval] = [NSNumber numberWithDouble:SNRSynerise.settings.sdk.minTokenRefreshInterval];
    dictionary[FSettingsSDKShouldDestroySessionOnApiKeyChange] = [NSNumber numberWithBool:SNRSynerise.settings.sdk.shouldDestroySessionOnApiKeyChange];
    dictionary[FSettingsSDKLocalizable] = SNRSynerise.settings.sdk.localizable ?: [NSNull null];
    
    dictionary[FSettingsTrackerIsBackendTimeSyncRequired] = [NSNumber numberWithBool:SNRSynerise.settings.tracker.isBackendTimeSyncRequired];
    dictionary[FSettingsTrackerMinBatchSize] = [NSNumber numberWithInteger:SNRSynerise.settings.tracker.minBatchSize];
    dictionary[FSettingsTrackerMaxBatchSize] = [NSNumber numberWithInteger:SNRSynerise.settings.tracker.maxBatchSize];
    dictionary[FSettingsTrackerAutoFlushTimeout] = [NSNumber numberWithDouble:SNRSynerise.settings.tracker.autoFlushTimeout];
    dictionary[FSettingsTrackerEventsTriggeringFlush] = SNRSynerise.settings.tracker.eventsTriggeringFlush ?: [NSNull null];

    dictionary[FSettingsNotificationsEnabled] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.enabled];
    dictionary[FSettingsNotificationsEncryption] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.encryption];
    dictionary[FSettingsNotificationsDisableInAppAlerts] = [NSNumber numberWithBool:SNRSynerise.settings.notifications.disableInAppAlerts];
    
    dictionary[FSettingsInjectorAutomatic] = [NSNumber numberWithBool:SNRSynerise.settings.injector.automatic];
    
    dictionary[FSettingsInAppMessagingMaxDefinitionUpdateIntervalLimit] = [NSNumber numberWithDouble:SNRSynerise.settings.inAppMessaging.maxDefinitionUpdateIntervalLimit];
    dictionary[FSettingsInAppMessagingContentBaseUrl] = SNRSynerise.settings.inAppMessaging.contentBaseUrl ?: [NSNull null];
    dictionary[FSettingsInAppMessagingRenderingTimeout] = [NSNumber numberWithDouble:SNRSynerise.settings.inAppMessaging.renderingTimeout];
    dictionary[FSSettingsInAppMessagingShouldSendInAppCappingEvent] = [NSNumber numberWithBool:SNRSynerise.settings.inAppMessaging.shouldSendInAppCappingEvent];
    dictionary[FSSettingsInAppMessagingCheckGlobalControlGroupsOnDefinitionsFetch] = [NSNumber numberWithBool:SNRSynerise.settings.inAppMessaging.checkGlobalControlGroupsOnDefinitionsFetch];

    return dictionary;
}

- (NSDictionary *)normalizeSDKLocalizableDictionary:(nullable NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:NSNull.class] == YES || dictionary == nil) {
        return nil;
    }

    static NSString *LocalizableKeyOK = @"LocalizableStringKeyOK";
    static NSString *LocalizableKeyCancel = @"LocalizableStringKeyCancel";

    NSMutableDictionary *newDictionary = [@{} mutableCopy];

    NSString *localizableKeyOK = dictionary[LocalizableKeyOK];
    if (localizableKeyOK != nil) {
        newDictionary[_SNR_Constants.LOCALIZABLE_STRING_KEY_OK] = localizableKeyOK;
    }

    NSString *localizableKeyCancel = dictionary[LocalizableKeyCancel];
    if (localizableKeyCancel != nil) {
        newDictionary[_SNR_Constants.LOCALIZABLE_STRING_KEY_CANCEL] = localizableKeyCancel;
    }

    if ([newDictionary count] == 0) {
        return nil;
    }

    return [[NSDictionary alloc] initWithDictionary:newDictionary];
}


@end

NS_ASSUME_NONNULL_END





