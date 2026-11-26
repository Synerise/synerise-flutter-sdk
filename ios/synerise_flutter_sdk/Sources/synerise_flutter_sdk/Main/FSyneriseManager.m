//
//  FSyneriseManager.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FSyneriseManager.h"
#import "FSettings.h"
#import "FSynerise.h"
#import "FNotifications.h"
#import "FClient.h"
#import "FTracker.h"
#import "FInjector.h"
#import "FContent.h"
#import "FPromotions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSyneriseManager ()

@property (strong, nonatomic, nonnull, readonly) NSMutableDictionary *modules;

@end

@implementation FSyneriseManager

#pragma mark - Lifecycle

+ (id)sharedInstance {
    static FSyneriseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _modules = [@{} mutableCopy];
    }
    
    return self;
}

#pragma mark - Custom Accessors

- (nullable FSettings *)settings {
    return [self getModuleForClass:FSettings.class];
}

- (nullable FSynerise *)synerise {
    return [self getModuleForClass:FSynerise.class];
}

- (nullable FNotifications *)notifications {
    return [self getModuleForClass:FNotifications.class];
}

- (nullable FClient *)client {
    return [self getModuleForClass:FClient.class];
}

- (nullable FTracker *)tracker {
    return [self getModuleForClass:FTracker.class];
}

- (nullable FInjector *)injector {
    return [self getModuleForClass:FInjector.class];
}

- (nullable FContent *)content {
    return [self getModuleForClass:FContent.class];
}

- (nullable FPromotions *)promotions {
    return [self getModuleForClass:FPromotions.class];
}


#pragma mark - Public

- (void)createModules {
    NSArray *nativeModulesToCreate = @[
        FSettings.class,
        FSynerise.class,
        FNotifications.class,
        FClient.class,
        FTracker.class,
        FInjector.class,
        FContent.class,
        FPromotions.class
    ];
    
    for (Class aClass in nativeModulesToCreate) {
        [self createModuleFromClass:aClass];
    }
}

- (void)notifyModulesWhenSyneriseInitialized {
    for (NSString *moduleKey in self.modules) {
        FBaseModule *module = self.modules[moduleKey];
        [module syneriseInitialized];
    }
}

#pragma mark - Private

- (void)createModuleFromClass:(Class)aClass {
    FBaseModule *module = [[aClass alloc] init];
    [self.modules setObject:module forKey:NSStringFromClass(aClass)];
}

- (nullable id)getModuleForClass:(Class)aClass {
    id module = self.modules[NSStringFromClass(aClass)];
    if (module != nil && [module isKindOfClass:aClass] == YES) {
        return module;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
