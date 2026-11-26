//
//  FInAppManager.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import "FInAppManager.h"

#import <SyneriseSDK/SyneriseSDK.h>

#import "FSyneriseManager.h"
#import "NSMutableDictionary+Flutter.h"
#import "FInlineInAppViewRegistry.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const FInAppManagerJinjavaContextKey = @"jinjavaContext";

@interface FInAppManager () <SNRInjectorInAppMessageDelegate, SNRInjectorInlineInAppMessageDelegate>

@property (strong, nonatomic, nonnull) NSMutableDictionary<NSString *, SNRInAppCustomMethodCompletion *> *pendingInAppCustomMethodCompletions;
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSString *, SNRInAppCustomMethodCompletion *> *pendingInlineCustomMethodCompletions;

@end

@implementation FInAppManager

- (NSMutableDictionary<NSString *, SNRInAppCustomMethodCompletion *> *)pendingInAppCustomMethodCompletions {
    if (_pendingInAppCustomMethodCompletions == nil) {
        _pendingInAppCustomMethodCompletions = [NSMutableDictionary dictionary];
    }
    return _pendingInAppCustomMethodCompletions;
}

- (NSMutableDictionary<NSString *, SNRInAppCustomMethodCompletion *> *)pendingInlineCustomMethodCompletions {
    if (_pendingInlineCustomMethodCompletions == nil) {
        _pendingInlineCustomMethodCompletions = [NSMutableDictionary dictionary];
    }
    return _pendingInlineCustomMethodCompletions;
}

#pragma mark - Public

- (void)activate {
    [SNRInjector setInAppMessageDelegate:self];
}

- (void)closeInAppMessage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *campaignHash = (NSString *)call.arguments;
    [SNRInjector closeInAppMessageWithCampaignHash:campaignHash];
}

- (void)setInlineInAppListenerEnabled:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRInjector setInlineInAppMessageDelegate:self];
    result(nil);
}

- (void)removeInlineInAppListener:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRInjector setInlineInAppMessageDelegate:nil];
    [self failPendingInlineCustomMethodCompletions];
    result(nil);
}

- (void)resolveInAppCustomMethod:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
    NSString *callId = arguments[@"callId"];
    BOOL success = [arguments[@"success"] boolValue];
    id resultValue = arguments[@"result"];
    if ([resultValue isKindOfClass:[NSNull class]] == YES) {
        resultValue = nil;
    }
    id errorValue = arguments[@"error"];
    NSString *error = [errorValue isKindOfClass:[NSString class]] ? errorValue : nil;

    SNRInAppCustomMethodCompletion *completion;
    @synchronized (self) {
        completion = self.pendingInAppCustomMethodCompletions[callId];
        [self.pendingInAppCustomMethodCompletions removeObjectForKey:callId];
    }

    if (completion == nil) {
        result(nil);
        return;
    }

    if (success) {
        [completion success:resultValue];
    } else {
        [completion failure:error ?: @"Unknown error."];
    }
    result(nil);
}

- (void)resolveInlineCustomMethod:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = [call.arguments isKindOfClass:[NSDictionary class]] ? call.arguments : @{};
    NSString *callId = arguments[@"callId"];
    BOOL success = [arguments[@"success"] boolValue];
    id resultValue = arguments[@"result"];
    NSDictionary *resultData = [resultValue isKindOfClass:[NSDictionary class]] ? resultValue : nil;
    id errorValue = arguments[@"error"];
    NSString *error = [errorValue isKindOfClass:[NSString class]] ? errorValue : nil;

    SNRInAppCustomMethodCompletion *completion;
    @synchronized (self) {
        completion = self.pendingInlineCustomMethodCompletions[callId];
        [self.pendingInlineCustomMethodCompletions removeObjectForKey:callId];
    }

    if (completion == nil) {
        result(nil);
        return;
    }

    if (success) {
        [completion success:resultData];
    } else {
        [completion failure:error ?: @""];
    }
    result(nil);
}

- (void)failPendingInlineCustomMethodCompletions {
    NSArray<SNRInAppCustomMethodCompletion *> *pendingCompletions;
    @synchronized (self) {
        pendingCompletions = [self.pendingInlineCustomMethodCompletions allValues];
        [self.pendingInlineCustomMethodCompletions removeAllObjects];
    }
    for (SNRInAppCustomMethodCompletion *completion in pendingCompletions) {
        [completion failure:@"LISTENER_REMOVED"];
    }
}

/**
 * The app-owned context the backend evaluates on render. Read straight from the dictionary the app
 * already mirrors into the SDK through `SNRInjector.setInAppContext:`, so the SDK's render thread is
 * never blocked waiting on Dart.
 */
- (NSDictionary *)jinjavaContextFromApp {
    id jinjavaContext = SNRInjector.inAppContext[FInAppManagerJinjavaContextKey];
    return [jinjavaContext isKindOfClass:[NSDictionary class]] ? jinjavaContext : @{};
}

#pragma mark - Dart Mapping

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

- (NSDictionary *)dictionaryWithInlineInAppMessageData:(nullable SNRInlineInAppMessageData *)model {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    if (model != nil) {
        [dictionary setString:model.campaignHash forKey:@"campaignHash"];
        [dictionary setString:model.variantIdentifier forKey:@"variantIdentifier"];
        [dictionary setString:model.placementKey forKey:@"placementKey"];
        [dictionary setDictionary:(model.additionalParameters ?: @{}) forKey:@"additionalParameters"];
        [dictionary setBool:model.isTest forKey:@"isTest"];
    }
    return dictionary;
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
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInAppMessageListener#onCustomMethod" arguments:@{
        @"callId": callId,
        @"name": name,
        @"parameters": parameters != nil ? parameters : @{},
        @"data": [self dictionaryWithInAppMessageData:data] ?: @{}
    }];
}

- (nullable NSDictionary *)SNR_inAppMessageContextIsNeeded:(SNRInAppMessageData *)data {
    return [self jinjavaContextFromApp];
}

#pragma mark - SNRInjectorInlineInAppMessageDelegate

/** The SDK-rendered view stays retained in the registry under `viewId` until Dart mounts it. */
- (void)SNR_inlineInAppMessageDidBecomeAvailable:(SNRInlineInAppView *)view data:(SNRInlineInAppMessageData *)data {
    NSString *viewId = [FInlineInAppViewRegistry retainInlineInAppView:view placementKey:data.placementKey];
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInlineInAppMessageListener#onInlineInAppAvailable" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:data],
        @"viewId": viewId
    }];
}

- (nullable NSDictionary *)SNR_inlineInAppMessageContextIsNeeded:(SNRInlineInAppMessageData *)data {
    return [self jinjavaContextFromApp];
}

- (void)SNR_inlineInAppMessageHandledURLAction:(SNRInlineInAppMessageData *)data url:(NSURL *)url {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInlineInAppMessageListener#onOpenUrl" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:data],
        @"url": url.absoluteString
    }];
}

- (void)SNR_inlineInAppMessageHandledDeepLinkAction:(SNRInlineInAppMessageData *)data deepLink:(NSString *)deepLink {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInlineInAppMessageListener#onDeepLink" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:data],
        @"deepLink": deepLink
    }];
}

- (void)SNR_inlineInAppMessageHandledCustomAction:(SNRInlineInAppMessageData *)data name:(NSString *)name parameters:(NSDictionary *)parameters {
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInlineInAppMessageListener#onCustomAction" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:data],
        @"name": name,
        @"parameters": parameters
    }];
}

- (void)SNR_inlineInAppMessageHandledCustomMethod:(SNRInlineInAppMessageData *)data name:(NSString *)name parameters:(NSDictionary *)parameters completion:(SNRInAppCustomMethodCompletion *)completion {
    NSString *callId = [[NSUUID UUID] UUIDString];
    @synchronized (self) {
        self.pendingInlineCustomMethodCompletions[callId] = completion;
    }
    [[FSyneriseManager sharedInstance].reverseChannel invokeMethod:@"Injector#InjectorInlineInAppMessageListener#onCustomMethod" arguments:@{
        @"callId": callId,
        @"name": name,
        @"parameters": parameters,
        @"data": [self dictionaryWithInlineInAppMessageData:data]
    }];
}

@end

NS_ASSUME_NONNULL_END
