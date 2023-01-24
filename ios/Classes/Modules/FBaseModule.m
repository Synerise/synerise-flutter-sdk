//
//  FBaseModule.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const FDefaultErrorDomain = @"com.synerise.sdk.flutter.error";
static NSInteger const FDefaultErrorCode = -1;
static NSString * const FDefaultErrorMessage = @"An unknown error has occurred";

@implementation FBaseModule

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod{
	THROW_ABSTRACT_METHOD_EXCEPTION();
}

- (FlutterError *)defaultFlutterError {
    NSInteger code = FDefaultErrorCode;
    NSString *description = FDefaultErrorMessage;
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: description
                               };
    
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%li", code] message:description details:@""];
}

- (FlutterError *)makeFlutterErrorWithError:(NSError *)error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%li", error.code] message:error.localizedDescription details:@""];
}

@end

NS_ASSUME_NONNULL_END
