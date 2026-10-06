//
//  FInlineInAppView.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FInlineInAppView : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    messenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
