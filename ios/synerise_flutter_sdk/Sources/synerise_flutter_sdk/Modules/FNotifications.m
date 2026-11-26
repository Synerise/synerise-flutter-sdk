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
    } else if ([calledMethod isEqualToString:@"isSyneriseNotification"]) {
        [self isSyneriseNotification:call result:result];
    } else if ([calledMethod isEqualToString:@"isSyneriseSimplePush"]) {
        [self isSyneriseSimplePush:call result:result];
    } else if ([calledMethod isEqualToString:@"isSilentCommand"]) {
        [self isSilentCommand:call result:result];
    } else if ([calledMethod isEqualToString:@"isSilentSDKCommand"]) {
        [self isSilentSDKCommand:call result:result];
    } else if ([calledMethod isEqualToString:@"isNotificationEncrypted"]) {
        [self isNotificationEncrypted:call result:result];
    } else if ([calledMethod isEqualToString:@"decryptNotification"]) {
        [self decryptNotification:call result:result];
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
    
    if (mobileAgreement != nil) {
        [SNRClient registerForPush:registrationToken mobilePushAgreement:[mobileAgreement boolValue] success:^() {
            result([NSNumber numberWithBool:YES]);
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    } else {
        [SNRClient registerForPush:registrationToken success:^() {
            result([NSNumber numberWithBool:YES]);
        } failure:^(SNRApiError * _Nonnull error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    }
}

- (void)handleNotification:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSDictionary *notification = [dictionary getDictionaryForKey:@"notification"];
    NSString *actionIdentifier = [dictionary getStringForKey:@"actionIdentifier"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SNRSynerise handleNotification:payload actionIdentifier:actionIdentifier];
            result([NSNumber numberWithBool:YES]);
        });
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)handleNotificationClick:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSDictionary *notification = [dictionary getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SNRSynerise handleNotification:payload actionIdentifier:UNNotificationDefaultActionIdentifier];
            result([NSNumber numberWithBool:YES]);
        });
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)isSyneriseNotification:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        NSNumber *isSyneriseNotification = [NSNumber numberWithBool:[SNRSynerise isSyneriseNotification:payload]];
        result(isSyneriseNotification);
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)isSyneriseSimplePush:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        NSNumber *isSyneriseSimplePush = [NSNumber numberWithBool:[SNRSynerise isSyneriseSimplePush:payload]];
        result(isSyneriseSimplePush);
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)isSilentCommand:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        NSNumber *isSilentCommand = [NSNumber numberWithBool:[SNRSynerise isSyneriseSilentCommand:payload]];
        result(isSilentCommand);
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)isSilentSDKCommand:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    if (payload != nil) {
        NSNumber *isSilentSDKCommand = [NSNumber numberWithBool:[SNRSynerise isSyneriseSilentSDKCommand:payload]];
        result(isSilentSDKCommand);
    } else {
        result([self makeFlutterErrorWithMessage:@"payload mapping failure"]);
        return;
    }
}

- (void)isNotificationEncrypted:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    NSNumber *isNotificationEncrypted = [NSNumber numberWithBool:[SNRSynerise isNotificationEncrypted:payload]];
    result(isNotificationEncrypted);
}

- (void)decryptNotification:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *userInfo = call.arguments;
    
    NSDictionary *notification = [userInfo getDictionaryForKey:@"notification"];
    NSDictionary *payload = [self payloadDictionaryWithDictionary:notification];
    NSDictionary *decryptedUserInfo = [SNRSynerise decryptNotification:payload];
    if (decryptedUserInfo != nil) {
        result(decryptedUserInfo);
    } else {
        result([self makeFlutterErrorWithMessage:@"notification decryption failed"]);
        return;
    }
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

