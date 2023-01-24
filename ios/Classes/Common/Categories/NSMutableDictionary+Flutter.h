//
//  NSMutableDictionary+Flutter.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (Flutter)

- (void)setGenericObject:(nullable NSString *)object forKey:(NSString *)key;
- (void)setString:(nullable NSString *)string forKey:(NSString *)key;
- (void)setNumber:(nullable NSNumber *)number forKey:(NSString *)key;
- (void)setArray:(nullable NSArray *)array forKey:(NSString *)key;
- (void)setDictionary:(nullable NSDictionary *)dictionary forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setBool:(BOOL)boolean forKey:(NSString *)key;
- (void)setDate:(NSDate *)date forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
