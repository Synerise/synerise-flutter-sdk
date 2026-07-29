//
//  FInjector.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FInjector.h"

NS_ASSUME_NONNULL_BEGIN

@interface FInjector () <SNRInjectorInAppMessageDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, SNRInAppCustomMethodCompletion *> *pendingInAppCustomMethodCompletions;

@end

@implementation FInjector

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];

    if (self) {
        _pendingInAppCustomMethodCompletions = [NSMutableDictionary dictionary];
    }

    return self;
}

#pragma mark - Public

- (void)syneriseInitialized {
    [SNRInjector setInAppMessageDelegate:self];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"setInAppContext"]) {
        [self setInAppContext:call result:result];
    } else if ([calledMethod isEqualToString:@"notifyInAppContextChange"]) {
        [self notifyInAppContextChange:call result:result];
    } else if ([calledMethod isEqualToString:@"closeInAppMessage"]) {
        [self closeInAppMessage:call result:result];
    } else if ([calledMethod isEqualToString:@"handleOpenUrlBySDK"]) {
        [self handleOpenUrlBySDK:call result:result];
    } else if ([calledMethod isEqualToString:@"handleDeepLinkBySDK"]) {
        [self handleDeepLinkBySDK:call result:result];
    }  else if ([calledMethod isEqualToString:@"resolveInAppCustomMethod"]) {
        [self resolveInAppCustomMethod:call result:result];
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

- (void)closeInAppMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *campaignHash = (NSString *)call.arguments;
    [SNRInjector closeInAppMessageWithCampaignHash:campaignHash];
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

- (void)resolveInAppCustomMethod:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *callId = [dictionary getStringForKey:@"callId"];
    if (callId == nil) {
        return;
    }

    BOOL isSuccess = [dictionary getBoolForKey:@"success"];
    id methodResult = dictionary[@"result"];
    if ([methodResult isKindOfClass:[NSNull class]] == YES) {
        methodResult = nil;
    }
    NSString *error = [dictionary getStringForKey:@"error"];

    SNRInAppCustomMethodCompletion *completion;
    @synchronized (self) {
        completion = self.pendingInAppCustomMethodCompletions[callId];
        [self.pendingInAppCustomMethodCompletions removeObjectForKey:callId];
    }

    if (completion == nil) {
        return;
    }

    if (isSuccess == YES) {
        [completion success:methodResult];
    } else {
        if (error == nil) {
          error = @"Unknown error.";
        }

        [completion failure:error];
    }
}

#pragma mark - Dart Mapping

- (NSString *)stringWithSyneriseSource:(SNRSyneriseSource)source {
    if (source == SNRSyneriseSourceSimplePush) {
        return @"SIMPLE_PUSH";
    } else if (source == SNRSyneriseSourceInAppMessage) {
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

- (nullable NSDictionary *)SNR_inAppMessageContextIsNeeded:(SNRInAppMessageData *)data {
    return nil;
}

- (void)SNR_inAppMessageHandledURLAction:(SNRInAppMessageData *)data url:(NSURL *)url {
    NSDictionary *dictionary = @{
       @"data": [self dictionaryWithInAppMessageData:data],
       @"url": url.absoluteString
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onOpenUrl" arguments:dictionary];
}

- (void)SNR_inAppMessageHandledDeepLinkAction:(SNRInAppMessageData *)data deepLink:(NSString *)deepLink {
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

- (void)SNR_inAppMessageHandledCustomMethod:(SNRInAppMessageData *)data name:(NSString *)name parameters:(NSDictionary *)parameters completion:(SNRInAppCustomMethodCompletion *)completion {
    NSString *callId = [[NSUUID UUID] UUIDString];
    @synchronized (self) {
        self.pendingInAppCustomMethodCompletions[callId] = completion;
    }

    NSDictionary *dataDictionary = [self dictionaryWithInAppMessageData:data];
    NSDictionary *dictionary = @{
       @"callId": callId,
       @"name": name,
       @"parameters": parameters != nil ? parameters : @{},
       @"data": dataDictionary != nil ? dataDictionary : @{}
    };
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onCustomMethod" arguments:dictionary];
}

@end

NS_ASSUME_NONNULL_END
