//
//  FInlineInAppViewFactory.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import "FInlineInAppViewFactory.h"
#import "FInlineInAppView.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FInlineInAppViewFactory {
    NSObject<FlutterBinaryMessenger> *_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[FInlineInAppView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args messenger:_messenger];
}

@end

NS_ASSUME_NONNULL_END
