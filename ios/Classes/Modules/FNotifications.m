//
//  FNotifications.m
//  synerise_flutter_sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FNotifications.h"
#import "FSyneriseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FNotifications ()

@end

@implementation FNotifications

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"registerForNotifications"]) {
        [self registerForNotifications:call result:result];
    } else if ([calledMethod isEqualToString:@"handleNotification"]) {
        [self handleNotification:call result:result];
    } else if ([calledMethod isEqualToString:@"handleNotificationClick"]) {
        [self handleNotificationClick:call result:result];
    }
}

- (void)executeRegistrationRequired {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Notifications#NotificationsListener#onRegistrationRequired" arguments:@(YES)];
}

#pragma mark - Methods

- (void)registerForNotifications:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *registrationToken = [dictionary getStringForKey:@"registrationToken"];
    NSNumber *mobileAgreement = [dictionary getNumberForKey:@"mobileAgreement"];

    [SNRClient registerForPush:registrationToken mobilePushAgreement:[mobileAgreement boolValue] success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)handleNotification:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSDictionary *notification = [dictionary getDictionaryForKey:@"notification"];
    NSString *actionIdentifier = [dictionary getStringForKey:@"actionIdentifier"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SNRSynerise handleNotification:payload actionIdentifier:actionIdentifier];
        });
    }
    
    result(@YES);
}

- (void)handleNotificationClick:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSDictionary *notification = [dictionary getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SNRSynerise handleNotification:payload actionIdentifier:UNNotificationDefaultActionIdentifier];
        });
    }
    
    result(@YES);
}

#pragma mark - SDK Mapping

- (nullable NSDictionary *)payloadDictionaryWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        @try {
            NSMutableDictionary *payload = [@{} mutableCopy];
            
            NSDictionary *notificationDictionary = [dictionary getDictionaryForKey:@"notification"];
            if (notificationDictionary != nil) {
                NSString *title = notificationDictionary[@"title"];
                NSString *body = notificationDictionary[@"body"];
                if (title != nil && body != nil) {
                    [payload setDictionary:@{
                        @"alert": @{
                            @"title": title,
                            @"body": body
                        }
                    } forKey:@"aps"];
                }
            }

            [payload addEntriesFromDictionary:dictionary[@"data"]];
            
            return payload;
        }
        @catch(NSException *exception) {
            return nil;
        }
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END

