//
//  FInjector.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FInjector.h"

NS_ASSUME_NONNULL_BEGIN

@interface FInjector () <SNRInjectorBannerDelegate, SNRInjectorWalkthroughDelegate, SNRInjectorInAppMessageDelegate>

@end

@implementation FInjector

#pragma mark - Public

- (void)syneriseInitialized {
    [SNRInjector setBannerDelegate:self];
    [SNRInjector setWalkthroughDelegate:self];
    [SNRInjector setInAppMessageDelegate:self];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"handleOpenUrlBySDK"]) {
        [self handleOpenUrlBySDK:call result:result];
    } else if ([calledMethod isEqualToString:@"handleDeepLinkBySDK"]) {
        [self handleDeepLinkBySDK:call result:result];
    } else if ([calledMethod isEqualToString:@"getWalkthrough"]) {
        [self getWalkthrough:call result:result];
    } else if ([calledMethod isEqualToString:@"showWalkthrough"]) {
        [self showWalkthrough:call result:result];
    } else if ([calledMethod isEqualToString:@"isWalkthroughLoaded"]) {
        [self isWalkthroughLoaded:call result:result];
    } else if ([calledMethod isEqualToString:@"isLoadedWalkthroughUnique"]) {
        [self isLoadedWalkthroughUnique:call result:result];
    }
}

- (void)executeURLAction:(NSURL *)URL activity:(SNRSyneriseActivity)activity {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorListener#onOpenUrl" arguments:@{
        @"url": URL.absoluteString,
        @"source": [self stringWithSyneriseActivity:activity]
    }];
}

- (void)executeDeepLinkAction:(NSString *)deepLink activity:(SNRSyneriseActivity)activity {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorListener#onDeepLink" arguments:@{
        @"deepLink": deepLink,
        @"source": [self stringWithSyneriseActivity:activity]
    }];
}

#pragma mark - Methods

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

- (void)getWalkthrough:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRInjector getWalkthrough];
    result(nil);
}

- (void)showWalkthrough:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRInjector showWalkthrough];
    result(nil);
}

- (void)isWalkthroughLoaded:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRInjector isWalkthroughLoaded]]);
}

- (void)isLoadedWalkthroughUnique:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRInjector isLoadedWalkthroughUnique]]);
}

#pragma mark - Dart Mapping

- (NSString *)stringWithSyneriseActivity:(SNRSyneriseActivity)activity {
    if (activity == SNRSyneriseActivitySimplePush) {
        return @"SIMPLE_PUSH";
    } else if (activity == SNRSyneriseActivityBanner) {
        return @"BANNER";
    } else if (activity == SNRSyneriseActivityWalkthrough) {
        return @"WALKTHROUGH";
    } else if (activity == SNRSyneriseActivityInAppMessage) {
        return @"IN_APP_MESSAGE";
    } else {
        return @"NOT_SPECIFIED";
    }
}

- (nullable NSDictionary *)dictionaryWithInAppMessageData:(nullable SNRInAppMessageData *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.campaignHash forKey:@"campaignHash"];
        [dictionary setString:model.variantIdentifier forKey:@"variantIdentifier"];
        [dictionary setDictionary:(model.additionalParameters ?: @{}) forKey:@"additionalParameters"];
        [dictionary setBool:model.isTest forKey:@"isTest"];

        return dictionary;
    }
    
    return nil;
}

#pragma mark - SNRInjectorBannerDelegate

- (void)SNR_bannerDidAppear {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorBannerListener#onPresent" arguments:nil];
}

- (void)SNR_bannerDidDisappear {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorBannerListener#onHide" arguments:nil];
}

#pragma mark - SNRInjectorWalkthroughDelegate

- (void)SNR_walkthroughDidLoad {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorWalkthroughListener#onLoad" arguments:nil];
}

- (void)SNR_walkthroughLoadingError:(NSError *)error {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorWalkthroughListener#onLoad" arguments:nil];
}

- (void)SNR_walkthroughDidAppear {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorWalkthroughListener#onPresent" arguments:nil];
}

- (void)SNR_walkthroughDidDisappear {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorWalkthroughListener#onHide" arguments:nil];
}

#pragma mark - SNRInjectorInAppMessageDelegate

- (void)SNR_inAppMessageDidAppear:(SNRInAppMessageData *)data {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data]
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onPresent" arguments:dictionary];
}

- (void)SNR_inAppMessageDidDisappear:(SNRInAppMessageData *)data {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data]
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onHide" arguments:dictionary];
}

- (void)SNR_inAppMessageHandledURLAction:(SNRInAppMessageData *)data url:(NSURL *)url {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data],
       @"url": url.absoluteString
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onOpenUrl" arguments:dictionary];
}

- (void)SNR_inAppMessageHandledDeeplinkAction:(SNRInAppMessageData *)data deeplink:(NSString *)deepLink {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data],
       @"deepLink": deepLink
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onDeepLink" arguments:dictionary];
}

- (void)SNR_inAppMessageHandledCustomAction:(SNRInAppMessageData *)data name:(NSString *)name parameters:(NSDictionary *)parameters {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data],
       @"name": name,
       @"parameters": parameters
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onCustomAction" arguments:dictionary];
}

@end

NS_ASSUME_NONNULL_END
