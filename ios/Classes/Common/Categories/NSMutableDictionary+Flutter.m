//
//  NSMutableDictionary+Flutter.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "NSMutableDictionary+Flutter.h"

@implementation NSMutableDictionary(Flutter)

#pragma mark - Public

- (void)setGenericObject:(nullable NSString *)object forKey:(NSString *)key {
    [self setObject:object properClass:NSObject.class forKey:key];
}

- (void)setString:(nullable NSString *)string forKey:(NSString *)key {
    [self setObject:string properClass:NSString.class forKey:key];
}

- (void)setNumber:(nullable NSNumber *)number forKey:(NSString *)key {
    [self setObject:number properClass:NSNumber.class forKey:key];
}

- (void)setArray:(nullable NSArray *)array forKey:(NSString *)key {
    [self setObject:array properClass:NSArray.class forKey:key];
}

- (void)setDictionary:(nullable NSDictionary *)dictionary forKey:(NSString *)key {
    [self setObject:dictionary properClass:NSDictionary.class forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInteger:value] properClass:NSNumber.class forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] properClass:NSNumber.class forKey:key];
}

- (void)setBool:(BOOL)boolean forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithBool:boolean] properClass:NSNumber.class forKey:key];
}

- (void)setDate:(NSDate *)date forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:[date timeIntervalSince1970]] properClass:NSNumber.class forKey:key];
}

#pragma mark - Private

- (void)setObject:(id)object properClass:(Class)properClass forKey:(NSString *)key {
    if (object == nil) {
        [self setObject:[NSNull null] forKey:key];
        return;
    }
    
    if ([object isKindOfClass:properClass] == NO) {
        [self setObject:[NSNull null] forKey:key];
        return;
    }
    
    [self setObject:object forKey:key];
}

@end
