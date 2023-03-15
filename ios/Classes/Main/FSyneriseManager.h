//
//  FSyneriseManager.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@class FSettings;
@class FSynerise;
@class FNotifications;
@class FClient;
@class FTracker;
@class FInjector;
@class FContent;

@interface FSyneriseManager : NSObject

@property (weak, nonatomic, nullable, readonly) FSettings *settings;
@property (weak, nonatomic, nullable, readonly) FSynerise *synerise;
@property (weak, nonatomic, nullable, readonly) FNotifications *notifications;
@property (weak, nonatomic, nullable, readonly) FClient *client;
@property (weak, nonatomic, nullable, readonly) FTracker *tracker;
@property (weak, nonatomic, nullable, readonly) FInjector *injector;
@property (weak, nonatomic, nullable, readonly) FContent *content;

@property (strong, nonatomic, nonnull, readwrite) FlutterMethodChannel *mainChannel;
@property (strong, nonatomic, nonnull, readwrite) FlutterMethodChannel *reverseChannel;
@property (strong, nonatomic, nonnull, readwrite) FlutterMethodChannel *backgroundChannel;

+ (instancetype)sharedInstance;

- (void)createModules;
- (void)notifyModulesWhenSyneriseInitialized;

@end

NS_ASSUME_NONNULL_END
