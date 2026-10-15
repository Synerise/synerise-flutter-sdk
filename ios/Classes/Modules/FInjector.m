//
//  FInjector.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FInjector.h"
#import "FInAppManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FInjector ()

@property (strong, nonatomic, nonnull) FInAppManager *inAppManager;

@end

@implementation FInjector

- (FInAppManager *)inAppManager {
    if (_inAppManager == nil) {
        _inAppManager = [[FInAppManager alloc] init];
    }
    return _inAppManager;
}

#pragma mark - Public

- (void)syneriseInitialized {
    [self.inAppManager activate];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"setInAppContext"]) {
        [self setInAppContext:call result:result];
    } else if ([calledMethod isEqualToString:@"notifyInAppContextChange"]) {
        [self notifyInAppContextChange:call result:result];
    } else if ([calledMethod isEqualToString:@"closeInAppMessage"]) {
        [self.inAppManager closeInAppMessage:call result:result];
    } else if ([calledMethod isEqualToString:@"handleDeepLinkBySDK"]) {
        [self handleDeepLinkBySDK:call result:result];
    } else if ([calledMethod isEqualToString:@"handleOpenUrlBySDK"]) {
        [self handleOpenUrlBySDK:call result:result];
    } else if ([calledMethod isEqualToString:@"resolveInAppCustomMethod"]) {
        [self.inAppManager resolveInAppCustomMethod:call result:result];
    } else if ([calledMethod isEqualToString:@"setInlineInAppListenerEnabled"]) {
        [self.inAppManager setInlineInAppListenerEnabled:call result:result];
    } else if ([calledMethod isEqualToString:@"removeInlineInAppListener"]) {
        [self.inAppManager removeInlineInAppListener:call result:result];
    } else if ([calledMethod isEqualToString:@"resolveInlineCustomMethod"]) {
        [self.inAppManager resolveInlineCustomMethod:call result:result];
    }
}

#pragma mark - Methods

- (void)setInAppContext:(FlutterMethodCall *)call result:(FlutterResult)result {
    id context = call.arguments;
    if ([context isKindOfClass:[NSDictionary class]] == YES) {
        [SNRInjector setInAppContext:context];
    }

    result([NSNumber numberWithBool:YES]);
}

- (void)notifyInAppContextChange:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRInjector notifyInAppContextChange];
    result([NSNumber numberWithBool:YES]);
}

- (void)executeURLAction:(NSURL *)URL source:(SNRSyneriseSource)source {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorListener#onOpenUrl" arguments:@{
        @"url": URL.absoluteString,
        @"source": [self stringWithSyneriseSource:source]
    }];
}

- (void)executeDeepLinkAction:(NSString *)deepLink source:(SNRSyneriseSource)source {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorListener#onDeepLink" arguments:@{
        @"deepLink": deepLink,
        @"source": [self stringWithSyneriseSource:source]
    }];
}

- (void)handleOpenUrlBySDK:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *urlString = (NSString *)call.arguments;
    NSURL *URL = [NSURL URLWithString:urlString];

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            if (@available(iOS 10, *)) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:URL];
            }
        }
    });
}

- (void)handleDeepLinkBySDK:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *deepLink = (NSString *)call.arguments;
    NSURL *deepLinkURL = [NSURL URLWithString:deepLink];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:deepLinkURL options:@{} completionHandler:^(BOOL success) {

            }];
        } else {
            [[UIApplication sharedApplication] openURL:deepLinkURL];
        }
    });
}

#pragma mark - Dart Mapping

- (NSString *)stringWithSyneriseSource:(SNRSyneriseSource)source {
    if (source == SNRSyneriseSourceSimplePush) {
        return @"SIMPLE_PUSH";
    } else if (source == SNRSyneriseSourceInAppMessage) {
        return @"IN_APP_MESSAGE";
    } else if (source == SNRSyneriseSourceInlineInAppMessage) {
        return @"INLINE_IN_APP_MESSAGE";
    } else {
        return @"NOT_SPECIFIED";
    }
}

@end

NS_ASSUME_NONNULL_END
