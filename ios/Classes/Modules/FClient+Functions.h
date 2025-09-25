//
//  FClient+Functions.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <SyneriseSDK/SyneriseSDK.h>

NSString * SNR_ClientConditionalAuthStatusToString(SNRClientConditionalAuthStatus status);
SNRClientConditionalAuthStatus SNR_StringToClientConditionalAuthStatus(NSString * _Nullable string);

NSString * SNR_ClientSexToString(SNRClientSex clientSex);
SNRClientSex SNR_StringToClientSex(NSString * _Nullable string);

NSString * SNR_TokenOriginToString(SNRTokenOrigin type);
SNRTokenOrigin SNR_StringToTokenOrigin(NSString * _Nullable string);