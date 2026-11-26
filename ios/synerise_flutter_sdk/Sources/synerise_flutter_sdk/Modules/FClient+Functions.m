//
//  FClient+Functions.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FClient+Functions.h"

static NSString * const SNRClientConditionalAuthStatusSuccessString = @"SUCCESS";
static NSString * const SNRClientConditionalAuthStatusUnauthorizedString = @"UNAUTHORIZED";
static NSString * const SNRClientConditionalAuthStatusActivationRequiredString = @"ACTIVATION_REQUIRED";
static NSString * const SNRClientConditionalAuthStatusRegistrationRequiredString = @"REGISTRATION_REQUIRED";
static NSString * const SNRClientConditionalAuthStatusApprovalRequiredString = @"APPROVAL_REQUIRED";
static NSString * const SNRClientConditionalAuthStatusTermsAcceptanceRequiredString = @"TERMS_ACCEPTANCE_REQUIRED";
static NSString * const SNRClientConditionalAuthStatusMFARequiredString = @"MFA_REQUIRED";
static NSString * const SNRClientConditionalAuthStatusUnknownString = @"UKNOWN";

static NSString * const SNRClientSexNotSpecifiedString = @"NOT_SPECIFIED";
static NSString * const SNRClientSexMaleString = @"MALE";
static NSString * const SNRClientSexFemaleString = @"FEMALE";
static NSString * const SNRClientSexOtherString = @"OTHER";

static NSString * const SNRTokenOriginUnknownString = @"UNKNOWN";
static NSString * const SNRTokenOriginIncognitoString = @"INCOGNITO";
static NSString * const SNRTokenOriginAnonymousString = @"ANONYMOUS";
static NSString * const SNRTokenOriginSyneriseString = @"SYNERISE";
static NSString * const SNRTokenOriginSimpleAuthString = @"SIMPLE_AUTH";
static NSString * const SNRTokenOriginFacebookString = @"FACEBOOK";
static NSString * const SNRTokenOriginOAuthString = @"OAUTH";
static NSString * const SNRTokenOriginAppleString = @"APPLE";
static NSString * const SNRTokenOriginGoogleString = @"GOOGLE";

NSString * SNR_ClientConditionalAuthStatusToString(SNRClientConditionalAuthStatus status) {
    switch (status) {
        case SNRClientConditionalAuthStatusSuccess: return SNRClientConditionalAuthStatusSuccessString;
        case SNRClientConditionalAuthStatusUnauthorized: return SNRClientConditionalAuthStatusUnauthorizedString;
        case SNRClientConditionalAuthStatusActivationRequired: return SNRClientConditionalAuthStatusActivationRequiredString;
        case SNRClientConditionalAuthStatusRegistrationRequired: return SNRClientConditionalAuthStatusRegistrationRequiredString;
        case SNRClientConditionalAuthStatusApprovalRequired: return SNRClientConditionalAuthStatusApprovalRequiredString;
        case SNRClientConditionalAuthStatusTermsAcceptanceRequired: return SNRClientConditionalAuthStatusTermsAcceptanceRequiredString;
        case SNRClientConditionalAuthStatusMFARequired: return SNRClientConditionalAuthStatusMFARequiredString;
        default: return SNRClientConditionalAuthStatusUnknownString;
    }
}

SNRClientConditionalAuthStatus SNR_StringToClientConditionalAuthStatus(NSString * _Nullable string) {
    if ([string isEqualToString:SNRClientConditionalAuthStatusSuccessString]) {
        return SNRClientConditionalAuthStatusSuccess;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusUnauthorizedString]) {
        return SNRClientConditionalAuthStatusUnauthorized;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusActivationRequiredString]) {
        return SNRClientConditionalAuthStatusActivationRequired;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusRegistrationRequiredString]) {
        return SNRClientConditionalAuthStatusRegistrationRequired;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusApprovalRequiredString]) {
        return SNRClientConditionalAuthStatusApprovalRequired;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusTermsAcceptanceRequiredString]) {
        return SNRClientConditionalAuthStatusTermsAcceptanceRequired;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusApprovalRequiredString]) {
        return SNRClientConditionalAuthStatusApprovalRequired;
    }
    
    if ([string isEqualToString:SNRClientConditionalAuthStatusTermsAcceptanceRequiredString]) {
        return SNRClientConditionalAuthStatusTermsAcceptanceRequired;
    }
    
    return SNRClientConditionalAuthStatusUnknown;
}

NSString * _Nonnull SNR_ClientSexToString(SNRClientSex clientSex) {
    switch (clientSex) {
        case SNRClientSexMale: return SNRClientSexMaleString;
        case SNRClientSexFemale: return SNRClientSexFemaleString;
        case SNRClientSexOther: return SNRClientSexOtherString;
        default: return SNRClientSexNotSpecifiedString;
    }
}

SNRClientSex SNR_StringToClientSex(NSString * _Nullable string) {
    if ([string isEqualToString:SNRClientSexMaleString]) {
        return SNRClientSexMale;
    }
    
    if ([string isEqualToString:SNRClientSexFemaleString]) {
        return SNRClientSexFemale;
    }
    
    if ([string isEqualToString:SNRClientSexOtherString]) {
        return SNRClientSexOther;
    }
    
    return SNRClientSexNotSpecified;
}

NSString * SNR_TokenOriginToString(SNRTokenOrigin type) {
    switch (type) {
        case SNRTokenOriginAnonymous: return SNRTokenOriginAnonymousString;
        case SNRTokenOriginIncognito: return SNRTokenOriginIncognitoString;
        case SNRTokenOriginSynerise: return SNRTokenOriginSyneriseString;
        case SNRTokenOriginSimpleAuth: return SNRTokenOriginSimpleAuthString;
        case SNRTokenOriginOAuth: return SNRTokenOriginOAuthString;
        case SNRTokenOriginFacebook: return SNRTokenOriginFacebookString;
        case SNRTokenOriginApple: return SNRTokenOriginAppleString;
        case SNRTokenOriginGoogle: return SNRTokenOriginGoogleString;
        default: return SNRTokenOriginUnknownString;
    }
}

SNRTokenOrigin SNR_StringToTokenOrigin(NSString * _Nullable string) {
    if ([string isEqualToString:SNRTokenOriginAnonymousString]) {
        return SNRTokenOriginAnonymous;
    }

  if ([string isEqualToString:SNRTokenOriginIncognitoString]) {
      return SNRTokenOriginIncognito;
  }

    if ([string isEqualToString:SNRTokenOriginSyneriseString]) {
        return SNRTokenOriginSynerise;
    }
    
    if ([string isEqualToString:SNRTokenOriginSimpleAuthString]) {
        return SNRTokenOriginSimpleAuth;
    }
    
    if ([string isEqualToString:SNRTokenOriginOAuthString]) {
        return SNRTokenOriginOAuth;
    }
    
    if ([string isEqualToString:SNRTokenOriginFacebookString]) {
        return SNRTokenOriginFacebook;
    }
    
    if ([string isEqualToString:SNRTokenOriginAppleString]) {
        return SNRTokenOriginApple;
    }
    
    if ([string isEqualToString:SNRTokenOriginGoogleString]) {
        return SNRTokenOriginGoogle;
    }
    
    return SNRTokenOriginUnknown;
}


