//
//  FTracker.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FTracker.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTracker ()

@end

@implementation FTracker

#pragma mark - Static

+ (FTracker *)sharedInstance {
    static FTracker *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Lifecycle

- (id)init {
    self = [super init];

    if (self) {
        
    }

    return self;
}

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"setCustomIdentifier"]) {
        [self setCustomIdentifier:call result:result];
    } else if ([calledMethod isEqualToString:@"setCustomEmail"]) {
        [self setCustomEmail:call result:result];
    } else if ([calledMethod isEqualToString:@"send"]) {
        [self send:call result:result];
    } else if ([calledMethod isEqualToString:@"flush"]) {
        [self flush:call result:result];
    }
}

#pragma mark - Methods

- (void)setCustomIdentifier:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    NSString *customIdentifier = [dictionary getStringForKey:@"customIdentifier"];
    if (customIdentifier != nil) {
        [SNRTracker setCustomIdentifier:customIdentifier];
        result(nil);
    }
}

- (void)setCustomEmail:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    NSString *customEmail = [dictionary getStringForKey:@"customEmail"];
    if (customEmail != nil) {
        [SNRTracker setCustomEmail:customEmail];
        result(nil);
    }
}

- (void)send:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    SNREvent *event = [self eventWithDictionary:dictionary];
    if (event == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRTracker send:event];
    result(nil);
}

- (void)flush:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRTracker flushEventsWithCompletionHandler:^() {
        result(nil);
    }];
}

#pragma mark - SDK Mapping

- (SNRCustomEvent *)eventWithDictionary:(NSDictionary *)dictionary {
    NSString *label = [dictionary getStringForKey:@"label"];
    NSString *action = [dictionary getStringForKey:@"action"];
    NSDictionary *parameters = [dictionary getDictionaryForKey:@"parameters"];
    
    if (label != nil && action != nil) {
        SNRTrackerParams *params = [SNRTrackerParams makeWithBuilder:^(SNRTrackerParamsBuilder *builder) {
            if (parameters != nil && [parameters count] > 0) {
                for (NSString *paramKey in parameters) {
                    id paramValue = parameters[paramKey];
                    
                    if ([paramValue isKindOfClass:[NSString class]] == YES) {
                        [builder setString:paramValue forKey:paramKey];
                        continue;
                    }
                    
                    if ([paramValue isKindOfClass:[NSNumber class]] == YES) {
                        if ([self isBoolNumber:paramValue] == YES) {
                            [builder setBool:[paramValue boolValue] forKey:paramKey];
                            continue;
                        }
                        
                        if ([self isDoubleNumber:paramValue] == YES) {
                            [builder setDouble:[paramValue doubleValue] forKey:paramKey];
                            continue;
                        }
                        
                        [builder setInt:[paramValue integerValue] forKey:paramKey];
                        continue;
                    }
                    
                    if ([paramValue isKindOfClass:[NSDictionary class]] == YES) {
                        [builder setObject:((NSDictionary *)paramValue) forKey:paramKey];
                        continue;
                    }
                }
            }
        }];
        
        SNRCustomEvent *event = [[SNRCustomEvent alloc] initWithLabel:label action:action andParams:params];
        
        return event;
    }
    
    return nil;
}

#pragma mark - Helpers

- (BOOL)isDoubleNumber:(NSNumber *)number {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)number);
    
    return (numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type || numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType);
}

- (BOOL)isBoolNumber:(NSNumber *)number {
    CFNumberType numberType = CFNumberGetType((CFNumberRef)number);
    
    return (numberType == kCFNumberCharType);
}

@end

NS_ASSUME_NONNULL_END




