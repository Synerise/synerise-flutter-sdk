//
//  FInlineInAppView.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import "FInlineInAppView.h"
#import "FInlineInAppViewRegistry.h"

#import <SyneriseSDK/SyneriseSDK.h>

#import "NSMutableDictionary+Flutter.h"

NS_ASSUME_NONNULL_BEGIN

@interface FInlineInAppView () <SNRInlineInAppViewDelegate>

@end

@implementation FInlineInAppView {
    UIView *_containerView;
    SNRInlineInAppView *_inlineView;
    FlutterMethodChannel *_channel;
    NSString *_placementKey;
    NSString *_identifier;
    BOOL _adopted;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    messenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] initWithFrame:frame];
        NSDictionary *parameters = [args isKindOfClass:[NSDictionary class]] ? args : @{};
        _placementKey = [self stringFromValue:parameters[@"placementKey"]] ?: @"";
        _identifier = [self stringFromValue:parameters[@"identifier"]];

        NSString *channelName = [NSString stringWithFormat:@"synerise_flutter_sdk/inline_in_app_view/%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            [weakSelf handleMethodCall:call result:result];
        }];

        // A stale id (the view was already taken, e.g. after a remount or hot restart) falls back
        // to the regular placement-key path.
        NSString *adoptViewId = [self stringFromValue:parameters[@"adoptViewId"]];
        SNRInlineInAppView *retainedView = adoptViewId != nil ? [FInlineInAppViewRegistry takeRetainedViewWithIdentifier:adoptViewId] : nil;
        if (retainedView != nil) {
            [self adoptInlineView:retainedView];
        } else {
            [self createInlineViewIfPossible];
        }
    }
    return self;
}

- (UIView *)view {
    return _containerView;
}

- (void)dealloc {
    [self teardownInlineView];
    [_channel setMethodCallHandler:nil];
}

#pragma mark - Commands

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = call.method;
    if ([method isEqualToString:@"render"]) {
        [self createInlineViewIfPossible];
        [_inlineView render];
        result(nil);
    } else if ([method isEqualToString:@"release"]) {
        [self teardownInlineView];
        result(nil);
    } else if ([method isEqualToString:@"setPlacementKey"]) {
        [self updatePlacementKey:[self stringFromValue:call.arguments]];
        result(nil);
    } else if ([method isEqualToString:@"setIdentifier"]) {
        [self updateIdentifier:[self stringFromValue:call.arguments]];
        result(nil);
    } else if ([method isEqualToString:@"isRendered"]) {
        // A ternary / `&&` over BOOLs is promoted to int in C, and `@(int)` would reach Dart as an
        // integer, so box through the boolean literals to keep the reply a real boolean.
        BOOL rendered = _inlineView != nil && [_inlineView isRendered];
        result(rendered ? @YES : @NO);
    } else if ([method isEqualToString:@"getData"]) {
        SNRInlineInAppMessageData *data = [_inlineView getData];
        result(data != nil ? [self dictionaryWithInlineInAppMessageData:data] : [NSNull null]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)updateIdentifier:(nullable NSString *)identifier {
    _identifier = identifier;
    [self applyIdentifier];
}

/** An adopted view already holds its campaign; re-applying a placement key would destroy it. */
- (void)updatePlacementKey:(nullable NSString *)placementKey {
    NSString *newPlacementKey = placementKey ?: @"";
    if (_adopted || [newPlacementKey isEqualToString:_placementKey]) {
        return;
    }
    _placementKey = newPlacementKey;
    [self teardownInlineView];
    [self createInlineViewIfPossible];
}

#pragma mark - Native view

- (void)createInlineViewIfPossible {
    if (_placementKey.length == 0 || _inlineView != nil) {
        return;
    }
    SNRInlineInAppView *inlineView = [SNRInjector createInlineInAppViewWithPlacementKey:_placementKey];
    if (inlineView == nil) {
        return;
    }
    [self attachInlineView:inlineView];
}

/** Mounts the already rendered view the SDK announced instead of rendering the placement again. */
- (void)adoptInlineView:(SNRInlineInAppView *)retainedView {
    [self teardownInlineView];
    [retainedView removeFromSuperview];
    _adopted = YES;
    [self attachInlineView:retainedView];
}

- (void)attachInlineView:(SNRInlineInAppView *)inlineView {
    inlineView.delegate = self;
    inlineView.frame = _containerView.bounds;
    inlineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _inlineView = inlineView;
    [self applyIdentifier];
    [_containerView addSubview:inlineView];
}

/** The identifier can arrive before the SDK view exists, so it is re-applied whenever a view is created or adopted. */
- (void)applyIdentifier {
    if (_inlineView != nil && _identifier != nil) {
        [_inlineView setIdentifier:_identifier];
    }
}

- (void)teardownInlineView {
    if (_inlineView != nil) {
        _inlineView.delegate = nil;
        [_inlineView removeFromSuperview];
        _inlineView = nil;
    }
}

#pragma mark - Mapping

- (nullable NSString *)stringFromValue:(id)value {
    return [value isKindOfClass:[NSString class]] ? value : nil;
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

- (void)invokeCallback:(NSString *)method arguments:(nullable id)arguments {
    [_channel invokeMethod:method arguments:arguments];
}

#pragma mark - SNRInlineInAppViewDelegate

- (void)SNR_inlineInAppViewDidStartProcessing:(SNRInlineInAppView *)view {
    [self invokeCallback:@"onProcessingStarted" arguments:nil];
}

- (void)SNR_inlineInAppViewDidLoad:(SNRInlineInAppView *)view data:(SNRInlineInAppMessageData *)data {
    [self invokeCallback:@"onLoaded" arguments:@{@"data": [self dictionaryWithInlineInAppMessageData:data]}];
}

- (void)SNR_inlineInAppViewDidUpdate:(SNRInlineInAppView *)view data:(SNRInlineInAppMessageData *)data {
    [self invokeCallback:@"onUpdated" arguments:@{@"data": [self dictionaryWithInlineInAppMessageData:data]}];
}

- (void)SNR_inlineInAppViewDidFail:(SNRInlineInAppView *)view error:(NSError *)error {
    [self invokeCallback:@"onFailed" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:[view getData]],
        @"error": error.localizedDescription ?: @""
    }];
}

- (void)SNR_inlineInAppViewShouldBeRemoved:(SNRInlineInAppView *)view data:(SNRInlineInAppMessageData *)data {
    [self invokeCallback:@"onRemove" arguments:@{@"data": [self dictionaryWithInlineInAppMessageData:data]}];
}

- (void)SNR_inlineInAppViewChangeSizeIsNeeded:(SNRInlineInAppView *)view data:(SNRInlineInAppMessageData *)data size:(SNRInlineInAppSize *)size {
    [self invokeCallback:@"onSizeChanged" arguments:@{
        @"data": [self dictionaryWithInlineInAppMessageData:data],
        @"widthPx": @(size.widthPx),
        @"heightPx": @(size.heightPx),
        @"width": @(size.widthPt),
        @"height": @(size.heightPt),
        @"widthScreenRatio": @(size.widthScreenRatio),
        @"heightScreenRatio": @(size.heightScreenRatio)
    }];
}

@end

NS_ASSUME_NONNULL_END
