//
//  FClient.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface FClient ()

@end

@implementation FClient

#pragma mark - Static

+ (FClient*)sharedInstance {
    static FClient *sharedInstance = nil;
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
    if ([calledMethod isEqualToString:@"registerAccount"]) {
        [self registerAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"signIn"]) {
        [self signIn:call result:result];
    } else if ([calledMethod isEqualToString:@"authenticate"]) {
        [self authenticate:call result:result];
    } else if ([calledMethod isEqualToString:@"isSignedIn"]) {
        [self isSignedIn:call result:result];
    } else if ([calledMethod isEqualToString:@"signOut"]) {
        [self signOut:call result:result];
    } else if ([calledMethod isEqualToString:@"retrieveToken"]) {
        [self retrieveToken:call result:result];
    }
}

#pragma mark - Methods

- (void)registerAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    SNRClientRegisterAccountContext *registerAccountContext = [self modelClientRegisterAccountContextWithDictionary:dictionary];
    if (registerAccountContext == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRClient registerAccount:registerAccountContext success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)signIn:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    NSString *email = [dictionary getStringForKey:@"email"];
    NSString *password = [dictionary getStringForKey:@"password"];

    if (email == nil || password == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRClient signInWithEmail:email password:password success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)authenticate:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    id token = [dictionary getStringForKey:@"tokenString"];

    NSString *clientIdentityProviderString = [dictionary getStringForKey:@"identityProvider"];
    SNRClientIdentityProvider clientIdentityProvider = SNR_StringToClientIdentityProvider(clientIdentityProviderString);
    
    NSDictionary *contextDictionary = dictionary[@"context"];
    NSString *authID = contextDictionary[@"authID"];
    SNRClientAuthenticationContext *context = [self modelClientAuthenticationContextWithDictionary:contextDictionary];

    [SNRClient authenticateWithToken:token clientIdentityProvider:clientIdentityProvider authID:authID context:context success:^(BOOL isSuccess) {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)isSignedIn:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRClient isSignedIn]]);
}

- (void)signOut:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient signOut];
    result(nil);
}

- (void)retrieveToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient retrieveTokenWithSuccess:^(SNRToken *token) {
        NSDictionary *tokenDictionary = [self dictionaryWithToken:token];
        if (tokenDictionary != nil) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tokenDictionary options:0 error:&error];
            NSString *tokenString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

            result(tokenString);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}
    
#pragma mark - SDK Mapping

- (nullable SNRClientRegisterAccountContext *)modelClientRegisterAccountContextWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        NSString *email = [dictionary getStringForKey:@"email"];
        NSString *password = [dictionary getStringForKey:@"password"];
        
        if (email != nil && password != nil) {
            SNRClientRegisterAccountContext *model = [[SNRClientRegisterAccountContext alloc] initWithEmail:email andPassword:password];
            model.phone = [dictionary getStringForKey:@"phone"];
            model.customId = [dictionary getStringForKey:@"customId"];

            model.firstName = [dictionary getStringForKey:@"firstName"];
            model.lastName = [dictionary getStringForKey:@"lastName"];
            model.sex = SNR_StringToClientSex([dictionary getStringForKey:@"sex"]);

            model.company = [dictionary getStringForKey:@"company"];
            model.address = [dictionary getStringForKey:@"address"];
            model.city = [dictionary getStringForKey:@"city"];
            model.province = [dictionary getStringForKey:@"province"];
            model.zipCode = [dictionary getStringForKey:@"zipCode"];
            model.countryCode = [dictionary getStringForKey:@"countryCode"];
            
            model.agreements = [self modelClientAgreementsWithDictionary:[dictionary getDictionaryForKey:@"agreements"]];

            model.attributes = [dictionary getDictionaryForKey:@"attributes"];
            
            return model;
        }
    }
    
    return nil;
}

- (nullable SNRClientAuthenticationContext *)modelClientAuthenticationContextWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientAuthenticationContext *model = [SNRClientAuthenticationContext new];
        model.attributes = [dictionary getDictionaryForKey:@"attributes"];
        model.agreements = [self modelClientAgreementsWithDictionary:[dictionary getDictionaryForKey:@"agreements"]];
        
        return model;
    }
    
    return nil;
}

- (nullable SNRClientAgreements *)modelClientAgreementsWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientAgreements *model = [SNRClientAgreements new];
        
        if ([dictionary isValueNotNilForKey:@"email"] == YES) {
            model.email = [dictionary getBoolForKey:@"email"];
        }
        
        if ([dictionary isValueNotNilForKey:@"sms"] == YES) {
            model.sms = [dictionary getBoolForKey:@"sms"];
        }
        
        if ([dictionary isValueNotNilForKey:@"push"] == YES) {
            model.push = [dictionary getBoolForKey:@"push"];
        }
        
        if ([dictionary isValueNotNilForKey:@"bluetooth"] == YES) {
            model.bluetooth = [dictionary getBoolForKey:@"bluetooth"];
        }
        
        if ([dictionary isValueNotNilForKey:@"rfid"] == YES) {
            model.rfid = [dictionary getBoolForKey:@"rfid"];
        }
        
        if ([dictionary isValueNotNilForKey:@"wifi"] == YES) {
            model.wifi = [dictionary getBoolForKey:@"wifi"];
        }
        
        return model;
    }
    
    return nil;
}

#pragma mark - Dart Mapping

- (nullable NSDictionary *)dictionaryWithToken:(nullable SNRToken *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.tokenString forKey:@"tokenString"];
        [dictionary setString:SNR_TokenOriginToString(model.origin) forKey:@"origin"];
        [dictionary setDate:model.expirationDate forKey:@"expirationDate"];
    
        return dictionary;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
