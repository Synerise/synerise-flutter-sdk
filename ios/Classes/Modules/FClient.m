//
//  FClient.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FClient.h"
#import "FClient+Functions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FClient ()

@end

@implementation FClient

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"registerAccount"]) {
        [self registerAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"requestAccountActivation"]) {
        [self requestAccountActivation:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmAccountActivation"]) {
        [self confirmAccountActivation:call result:result];
    } else if ([calledMethod isEqualToString:@"requestAccountActivationByPin"]) {
        [self requestAccountActivationByPin:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmAccountActivationByPin"]) {
        [self confirmAccountActivationByPin:call result:result];
    } else if ([calledMethod isEqualToString:@"signIn"]) {
        [self signIn:call result:result];
    } else if ([calledMethod isEqualToString:@"signInConditionally"]) {
        [self signInConditionally:call result:result];
    } else if ([calledMethod isEqualToString:@"authenticate"]) {
        [self authenticate:call result:result];
    } else if ([calledMethod isEqualToString:@"authenticateConditionally"]) {
        [self authenticateConditionally:call result:result];
    } else if ([calledMethod isEqualToString:@"simpleAuthentication"]) {
        [self simpleAuthentication:call result:result];
    } else if ([calledMethod isEqualToString:@"isSignedIn"]) {
        [self isSignedIn:call result:result];
    } else if ([calledMethod isEqualToString:@"isSignedInViaSimpleAuthentication"]) {
        [self isSignedInViaSimpleAuthentication:call result:result];
    } else if ([calledMethod isEqualToString:@"signOut"]) {
        [self signOut:call result:result];
    } else if ([calledMethod isEqualToString:@"signOutWithMode"]) {
        [self signOutWithMode:call result:result];
    } else if ([calledMethod isEqualToString:@"refreshToken"]) {
        [self refreshToken:call result:result];
    } else if ([calledMethod isEqualToString:@"retrieveToken"]) {
        [self retrieveToken:call result:result];
    } else if ([calledMethod isEqualToString:@"getUUID"]) {
        [self getUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"regenerateUUID"]) {
        [self regenerateUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"regenerateUUIDWithClientIdentifier"]) {
        [self regenerateUUIDWithClientIdentifier:call result:result];
    } else if ([calledMethod isEqualToString:@"destroySession"]) {
        [self destroySession:call result:result];
    } else if ([calledMethod isEqualToString:@"getAccount"]) {
        [self getAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"updateAccountBasicInformation"]) {
        [self updateAccountBasicInformation:call result:result];
    } else if ([calledMethod isEqualToString:@"updateAccount"]) {
        [self updateAccount:call result:result];
    } else if ([calledMethod isEqualToString:@"requestPasswordReset"]) {
        [self requestPasswordReset:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmPasswordReset"]) {
        [self confirmPasswordReset:call result:result];
    } else if ([calledMethod isEqualToString:@"changePassword"]) {
        [self changePassword:call result:result];
    } else if ([calledMethod isEqualToString:@"requestEmailChange"]) {
        [self requestEmailChange:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmEmailChange"]) {
        [self confirmEmailChange:call result:result];
    } else if ([calledMethod isEqualToString:@"requestPhoneUpdate"]) {
        [self requestPhoneUpdate:call result:result];
    } else if ([calledMethod isEqualToString:@"confirmPhoneUpdate"]) {
        [self confirmPhoneUpdate:call result:result];
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
    
    [SNRClient registerAccount:clientRegisterAccountContext success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestAccountActivation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *email = [dictionary getStringForKey:@"email"];
    
    [SNRClient requestAccountActivationWithEmail:email success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmAccountActivation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *token = [dictionary getStringForKey:@"token"];
    
    [SNRClient confirmAccountActivationByToken:token success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestAccountActivationByPin:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *email = [dictionary getStringForKey:@"email"];
    
    if (email != nil) {
        [SNRClient requestAccountActivationByPinWithEmail:email success:^() {
            result([NSNumber numberWithBool:YES]);
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    } else {
        result([self makeFlutterErrorWithMessage:@"email missing"]);
    }
}

- (void)confirmAccountActivationByPin:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *email = [dictionary getStringForKey:@"email"];
    NSString *pinCode = [dictionary getStringForKey:@"pinCode"];
    
    if (email != nil || pinCode != nil) {
        [SNRClient confirmAccountActivationByPin:pinCode email:email success:^() {
            result([NSNumber numberWithBool:YES]);
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    } else {
        result([self makeFlutterErrorWithMessage:@"email / pincode missing"]);
    }
}

- (void)signIn:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *email = [dictionary getStringForKey:@"email"];
    NSString *password = [dictionary getStringForKey:@"password"];
    
    if (email == nil || password == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRClient signInWithEmail:email password:password success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)signInConditionally:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *email = [dictionary getStringForKey:@"email"];
    NSString *password = [dictionary getStringForKey:@"password"];
    
    if (email == nil || password == nil) {
        result([self makeFlutterErrorWithMessage:@"email / password missing"]);
        return;
    }
    
    [SNRClient signInConditionallyWithEmail:email password:password success:^(SNRClientConditionalAuthResult *authResult) {
        NSDictionary *authResultDictionary = [self dictionaryWithClientConditionalAuthResult:authResult];
        if (authResultDictionary != nil) {
            result(authResultDictionary);
        } else {
            result([self makeFlutterErrorWithMessage:@"signInResult is nil"]);
        }
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
    
    [SNRClient authenticateWithToken:token clientIdentityProvider:clientIdentityProvider authID:authId context:context success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)authenticateConditionally:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    id token = [dictionary getStringForKey:@"tokenString"];
    NSString *clientIdentityProviderString = [dictionary getStringForKey:@"identityProvider"];
    SNRClientIdentityProvider clientIdentityProvider = SNR_StringToClientIdentityProvider(clientIdentityProviderString);
    NSString *authID;
    SNRClientConditionalAuthenticationContext *context;
    
    if (token == nil || clientIdentityProviderString == nil) {
        result([self makeFlutterErrorWithMessage:@"token / clientIdentityProviderString missing"]);
        return;
    }
    
    if ([dictionary getStringForKey:@"authID"] != nil) {
        authID = dictionary[@"authID"];
    } else {
        authID = nil;
    }
    
    if ([dictionary getDictionaryForKey:@"clientAuthContext"] != nil) {
        NSDictionary *contextDictionary = dictionary[@"clientAuthContext"];
        context = [self modelClientConditionalAuthenticationContextWithDictionary:contextDictionary];
    } else {
        context = nil;
    }
    
    [SNRClient authenticateConditionallyWithToken:token clientIdentityProvider:clientIdentityProvider authID:authID context:context success:^(SNRClientConditionalAuthResult *authResult) {
        NSDictionary *authResultDictionary = [self dictionaryWithClientConditionalAuthResult:authResult];
        if (authResultDictionary != nil) {
            result(authResultDictionary);
        } else {
            result([self makeFlutterErrorWithMessage:@"authResult is nil"]);
        }
        
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)simpleAuthentication:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *authID = [dictionary getStringForKey:@"authID"];
    SNRClientSimpleAuthenticationData *clientSimpleAuthenticationData = [self modelClientSimpleAuthenticationDataWithDictionary:[dictionary getDictionaryForKey:@"clientSimpleAuthenticationData"]];
    
    if (clientSimpleAuthenticationData == nil) {
        result([self makeFlutterErrorWithMessage:@"clientAuthenticationData is missing"]);
        return;
    }
    
    [SNRClient simpleAuthentication:clientSimpleAuthenticationData authID:authID success:^(void) {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)isSignedIn:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRClient isSignedIn]]);
}

- (void)isSignedInViaSimpleAuthentication:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRClient isSignedInViaSimpleAuthentication]]);
}

- (void)signOut:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient signOut];
    result([NSNumber numberWithBool:YES]);
}

- (void)signOutWithMode:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *modeString = [dictionary getStringForKey:@"mode"];
    BOOL fromAllDevices;
    fromAllDevices = [dictionary getBoolForKey:@"fromAllDevices"];
    
    SNRClientSignOutMode mode = [self enumClientSignOutModeWithString:modeString];
    
    [SNRClient signOutWithMode:mode fromAllDevices:fromAllDevices success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)refreshToken:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient refreshTokenWithSuccess:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
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

- (void)getUUID:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *uuid = [SNRClient getUUID];
    result(uuid);
}

- (void)regenerateUUID:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:[SNRClient regenerateUUID]]);
}

- (void)regenerateUUIDWithClientIdentifier:(FlutterMethodCall *)call result:(FlutterResult)result  {
    NSDictionary *dictionary = call.arguments;
    NSString *clientIdentifier = [dictionary getStringForKey:@"clientIdentifier"];
    
    if (clientIdentifier != nil) {
        result([NSNumber numberWithBool:[SNRClient regenerateUUIDWithClientIdentifier:clientIdentifier]]);
    } else {
        result([self makeFlutterErrorWithMessage:@"clientIdentifier missing"]);
    }
}

- (void)destroySession:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient destroySession];
    result([NSNumber numberWithBool:YES]);
}

- (void)getAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRClient getAccountWithSuccess:^(SNRClientAccountInformation *clientAccountInformation) {
        NSDictionary *clientAccountInformationDictionary = [self dictionaryWithClientAccountInformation:clientAccountInformation];
        if (clientAccountInformationDictionary != nil) {
            result(clientAccountInformationDictionary);
        } else {
            result([self makeFlutterErrorWithMessage:@"clientAccountInformationDictionary is nil"]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)updateAccountBasicInformation:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRClientUpdateAccountBasicInformationContext *context = [self modelClientUpdateAccountBasicInformationContextWithDictionary:dictionary];
    if (context != nil) {
        [SNRClient updateAccountBasicInformation:context success:^() {
                result([NSNumber numberWithBool:YES]);
        } failure:^(NSError *error) {
            [self makeFlutterErrorWithError:error];
        }];
    } else {
        [self defaultFlutterError];
    }
}

- (void)updateAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRClientUpdateAccountContext *clientUpdateAccountContext = [self modelClientUpdateAccountContextWithDictionary:dictionary];
    if (clientUpdateAccountContext == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRClient updateAccount:clientUpdateAccountContext success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestPasswordReset:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *email = [dictionary getStringForKey:@"email"];
    SNRClientPasswordResetRequestContext *clientPasswordResetRequestContext = [[SNRClientPasswordResetRequestContext alloc] initWithEmail:email];
    
    [SNRClient requestPasswordReset:clientPasswordResetRequestContext success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmPasswordReset:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *password = [dictionary getStringForKey:@"password"];
    NSString *token = [dictionary getStringForKey:@"token"];
    
    SNRClientPasswordResetConfirmationContext *clientPasswordResetConfirmationContext = [[SNRClientPasswordResetConfirmationContext alloc] initWithPassword:password andToken:token];
    
    [SNRClient confirmResetPassword:clientPasswordResetConfirmationContext success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)changePassword:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *newPassword = [dictionary getStringForKey:@"newPassword"];
    NSString *oldPassword = [dictionary getStringForKey:@"oldPassword"];
    
    [SNRClient changePassword:newPassword oldPassword:oldPassword success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestEmailChange:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *email = [dictionary getStringForKey:@"email"];
    NSString *password = [dictionary getStringForKey:@"password"];
    NSString *externalToken;
    NSString *authID;
    
    if (email == nil || password == nil) {
        result([self makeFlutterErrorWithMessage:@"email / password missing"]);
        return;
    }
    
    if ([dictionary getStringForKey:@"externalToken"] != nil) {
        externalToken = [dictionary getStringForKey:@"externalToken"];
    } else {
        externalToken = nil;
    }
    
    if ([dictionary getStringForKey:@"authID"] != nil) {
        authID = dictionary[@"authID"];
    } else {
        authID = nil;
    }
    
    [SNRClient requestEmailChange:email password:password externalToken:externalToken authID:authID success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmEmailChange:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *token = [dictionary getStringForKey:@"token"];
    BOOL newsletterAgreement;
    newsletterAgreement = [dictionary getBoolForKey:@"newsletterAgreement"];
    if (token == nil) {
        result([self makeFlutterErrorWithMessage:@"token missing"]);
        return;
    }
    
    [SNRClient confirmEmailChange:token newsletterAgreement:newsletterAgreement success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)requestPhoneUpdate:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    NSString *phone = [dictionary getStringForKey:@"phone"];
    if (phone == nil) {
        result([self makeFlutterErrorWithMessage:@"phone missing"]);
        return;
    }
    
    [SNRClient requestPhoneUpdate:phone success:^() {
        result([NSNumber numberWithBool:YES]);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)confirmPhoneUpdate:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    NSString *phone = [dictionary getStringForKey:@"phone"];
    NSString *confirmationCode = [dictionary getStringForKey:@"confirmationCode"];
    BOOL smsAgreement;
    smsAgreement = [dictionary getBoolForKey:@"smsAgreement"];
    if (phone == nil || confirmationCode == nil) {
        result([self makeFlutterErrorWithMessage:@"phone / confirmationCode missing"]);
        return;
    }
    
    [SNRClient confirmPhoneUpdate:phone confirmationCode:confirmationCode smsAgreement:smsAgreement success:^() {
        result([NSNumber numberWithBool:YES]);
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
    
    [SNRClient deleteAccount:clientAuthFactor clientIdentityProvider:clientIdentityProvider authID:authId success:^() {
        result([NSNumber numberWithBool:YES]);
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

- (nullable SNRClientUpdateAccountBasicInformationContext *)modelClientUpdateAccountBasicInformationContextWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientUpdateAccountBasicInformationContext *model = [SNRClientUpdateAccountBasicInformationContext new];
        model.firstName = [dictionary getStringForKey:@"firstName"];
        model.lastName = [dictionary getStringForKey:@"lastName"];
        model.displayName = [dictionary getStringForKey:@"displayName"];
        model.sex = SNR_StringToClientSex([dictionary getStringForKey:@"sex"]);
        model.phone = [dictionary getStringForKey:@"phone"];
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

- (nullable SNRClientConditionalAuthenticationContext *)modelClientConditionalAuthenticationContextWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientConditionalAuthenticationContext *model = [SNRClientConditionalAuthenticationContext new];
        model.attributes = [dictionary getDictionaryForKey:@"attributes"];
        model.agreements = [self modelClientAgreementsWithDictionary:[dictionary getDictionaryForKey:@"agreements"]];
        
        return model;
    }
    
    return nil;
}

- (nullable SNRClientSimpleAuthenticationData *)modelClientSimpleAuthenticationDataWithDictionary:(nullable NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRClientSimpleAuthenticationData *model = [SNRClientSimpleAuthenticationData new];
        model.email = [[dictionary getStringForKey:@"email"] lowercaseString];
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

- (SNRClientSignOutMode)enumClientSignOutModeWithString:(nullable NSString *)string {
    if (string != nil && [string isKindOfClass:NSString.class] == YES) {
        if ([string isEqualToString:@"SIGN_OUT"] == YES) {
            return SNRClientSignOutModeSignOut;
        }
        
        if ([string isEqualToString:@"SIGN_OUT_WITH_SESSION_DESTROY"] == YES) {
            return SNRClientSignOutModeSignOutWithSessionDestroy;
        }
    }
    
    return SNRClientSignOutModeSignOut;
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
        [dictionary setString:model.rlm forKey:@"rlm"];
        [dictionary setString:model.clientId forKey:@"clientId"];
        [dictionary setString:model.customId forKey:@"customId"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithClientConditionalAuthResult:(nullable SNRClientConditionalAuthResult *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        [dictionary setString:SNR_ClientConditionalAuthStatusToString(model.status) forKey:@"status"];
        [dictionary setArray:model.conditions forKey:@"conditions"];
        
        return dictionary;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
