//
//  FInlineInAppViewFactory.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2024 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FInlineInAppViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;

@end

NS_ASSUME_NONNULL_END
