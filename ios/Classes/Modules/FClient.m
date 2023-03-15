//
//  FClient.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface FClient ()

@end

@implementation FClient

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"registerAccount"]) {
        [self registerAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmAccount"]) {
        [self confirmAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"activateAccount"]) {
        [self activateAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"signIn"]) {
        [self signIn:call result:result];
    } else if ([calledMethod isEqualToString:@"authenticate"]) {
        [self authenticate:call result:result];
    } else if ([calledMethod isEqualToString:@"isSignedIn"]) {
        [self isSignedIn:call result:result];
    } else if ([calledMethod isEqualToString:@"signOut"]) {
        [self signOut:call result:result];
    } else if ([calledMethod isEqualToString:@"destroySession"]) {
        [self destroySession:call result:result];
    } else if ([calledMethod isEqualToString:@"retrieveToken"]) {
        [self retrieveToken:call result:result];
    } else if ([calledMethod isEqualToString:@"refreshToken"]) {
        [self refreshToken:call result:result];
    } else if ([calledMethod isEqualToString:@"getUUID"]) {
        [self getUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"regenerateUUID"]) {
        [self regenerateUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"getAccount"]) {
        [self getAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"updateAccount"]) {
        [self updateAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"requestPasswordReset"]) {
        [self requestPasswordReset:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmPasswordReset"]) {
        [self confirmPasswordReset:call result:result];
    } else if ([calledMethod isEqualToString:@"changePassword"]) {
        [self changePassword:call result:result];
    } else if ([calledMethod isEqualToString:@"deleteAccount"]) {
        [self deleteAccount:call result:result];
    }
}

#pragma mark - Methods

- (void)registerAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRClientRegisterAccountContext *clientRegisterAccountContext = [self modelClientRegisterAccountContextWithDictionary:dictionary];
    if (clientRegisterAccountContext == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRClient registerAccount:clientRegisterAccountContext success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *token = call.arguments;
    
    [SNRClient confirmAccount:token success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)activateAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *email = call.arguments;
    
    [SNRClient activateAccount:email success:^(BOOL isSuccess) {
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
    NSString *authId = contextDictionary[@"authId"];
    SNRClientAuthenticationContext *context = [self modelClientAuthenticationContextWithDictionary:contextDictionary];
    
    [SNRClient authenticateWithToken:token clientIdentityProvider:clientIdentityProvider authID:authId context:context success:^(BOOL isSuccess) {
        result(nil);
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

- (void)destroySession:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient destroySession];
    result(nil);
}

- (void)retrieveToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient retrieveTokenWithSuccess:^(SNRToken *token) {
        NSDictionary *tokenDictionary = [self dictionaryWithToken:token];
        if (tokenDictionary != nil) {
            result(tokenDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)refreshToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient refreshTokenWithSuccess:^() {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getUUID:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *uuid = [SNRClient getUUID];
    result(uuid);
}

- (void)regenerateUUID:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient regenerateUUID];
    result(nil);
}

- (void)getAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient getAccountWithSuccess:^(SNRClientAccountInformation *clientAccountInformation) {
        NSDictionary *clientAccountInformationDictionary = [self dictionaryWithClientAccountInformation:clientAccountInformation];
        if (clientAccountInformationDictionary != nil) {
            result(clientAccountInformationDictionary);
        } else {
            [self defaultFlutterError];
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)updateAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRClientUpdateAccountContext *clientUpdateAccountContext = [self modelClientUpdateAccountContextWithDictionary:dictionary];
    if (clientUpdateAccountContext == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRClient updateAccount:clientUpdateAccountContext success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestPasswordReset:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *email = call.arguments;
    SNRClientPasswordResetRequestContext *clientPasswordResetRequestContext = [[SNRClientPasswordResetRequestContext alloc] initWithEmail:email];
    
    [SNRClient requestPasswordReset:clientPasswordResetRequestContext success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmPasswordReset:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *password = [dictionary getStringForKey:@"password"];
    NSString *token = [dictionary getStringForKey:@"token"];
    
    SNRClientPasswordResetConfirmationContext *clientPasswordResetConfirmationContext = [[SNRClientPasswordResetConfirmationContext alloc] initWithPassword:password andToken:token];
    
    [SNRClient confirmResetPassword:clientPasswordResetConfirmationContext success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)changePassword:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *newPassword = [dictionary getStringForKey:@"newPassword"];
    NSString *oldPassword = [dictionary getStringForKey:@"oldPassword"];
    
    [SNRClient changePassword:newPassword oldPassword:oldPassword success:^(BOOL isSuccess) {
        result(nil);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)deleteAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    id clientAuthFactor = dictionary[@"clientAuthFactor"];
    NSString *clientIdentityProviderString = dictionary[@"clientIdentityProviderString"];
    SNRClientIdentityProvider clientIdentityProvider = SNR_StringToClientIdentityProvider(clientIdentityProviderString);
    NSString *authId = dictionary[@"authId"];
    
    [SNRClient deleteAccount:clientAuthFactor clientIdentityProvider:clientIdentityProvider authID:authId success:^(BOOL isSuccess) {
        result(nil);
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

- (nullable SNRClientUpdateAccountContext *)modelClientUpdateAccountContextWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientUpdateAccountContext *model = [SNRClientUpdateAccountContext new];
        model.email = [dictionary getStringForKey:@"email"];
        model.phone = [dictionary getStringForKey:@"phone"];
        model.customId = [dictionary getStringForKey:@"customId"];
        model.uuid = [dictionary getStringForKey:@"uuid"];
                                                
        model.firstName = [dictionary getStringForKey:@"firstName"];
        model.lastName = [dictionary getStringForKey:@"lastName"];
        model.displayName = [dictionary getStringForKey:@"displayName"];
        model.sex = SNR_StringToClientSex([dictionary getStringForKey:@"sex"]);
        model.birthDate = [dictionary getStringForKey:@"birthDate"];
        model.avatarUrl = [dictionary getStringForKey:@"avatarUrl"];
                                                
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

- (nullable NSDictionary *)dictionaryWithClientAccountInformation:(nullable SNRClientAccountInformation *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setInteger:model.clientId forKey:@"clientId"];
        [dictionary setString:model.email forKey:@"email"];
        [dictionary setString:model.phone forKey:@"phone"];
        [dictionary setString:model.customId forKey:@"customId"];
        [dictionary setString:model.uuid forKey:@"uuid"];
        
        [dictionary setString:model.firstName forKey:@"firstName"];
        [dictionary setString:model.lastName forKey:@"lastName"];
        [dictionary setString:model.displayName forKey:@"displayName"];
        [dictionary setString:SNR_ClientSexToString(model.sex) forKey:@"sex"];
        [dictionary setString:model.birthDate forKey:@"birthDate"];
        [dictionary setString:model.avatarUrl forKey:@"avatarUrl"];
        
        [dictionary setString:model.company forKey:@"company"];
        [dictionary setString:model.address forKey:@"address"];
        [dictionary setString:model.city forKey:@"city"];
        [dictionary setString:model.province forKey:@"province"];
        [dictionary setString:model.zipCode forKey:@"zipCode"];
        [dictionary setString:model.countryCode forKey:@"countryCode"];

        [dictionary setBool:model.anonymous forKey:@"anonymous"];
        [dictionary setDate:model.lastActivityDate forKey:@"lastActivityDate"];
        
        [dictionary setDictionary:[self dictionaryWithClientAgreements:model.agreements] forKey:@"agreements"];
        
        [dictionary setDictionary:model.attributes forKey:@"attributes"];
        [dictionary setArray:model.tags forKey:@"tags"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithClientAgreements:(nullable SNRClientAgreements *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setBool:model.email forKey:@"email"];
        [dictionary setBool:model.sms forKey:@"sms"];
        [dictionary setBool:model.push forKey:@"push"];
        [dictionary setBool:model.bluetooth forKey:@"bluetooth"];
        [dictionary setBool:model.rfid forKey:@"rfid"];
        [dictionary setBool:model.wifi forKey:@"wifi"];
        
        return dictionary;
    }
    
    return nil;
}

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
