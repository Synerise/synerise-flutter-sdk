//
//  FBaseModule.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

static NSInteger const FDefaultErrorCode = -1;
static NSString * const FDefaultErrorMessage = @"An unknown error has occurred";

@interface FBaseModule ()

@end

@implementation FBaseModule

#pragma mark - Public

- (void)syneriseInitialized {
    // nothing for yet
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod{
	THROW_ABSTRACT_METHOD_EXCEPTION();
}

- (FlutterError *)defaultFlutterError {
    NSInteger code = FDefaultErrorCode;
    NSString *description = FDefaultErrorMessage;
    
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%li", code] message:description details:nil];
}

- (FlutterError *)makeFlutterErrorWithError:(NSError *)error {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%li", error.code] message:error.localizedDescription details:nil];
}

- (FlutterError *)makeFlutterErrorWithMessage:(NSString *)message {
    NSInteger code = FDefaultErrorCode;
    NSString *description = FDefaultErrorMessage;
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"%li", code] message:description details:message];
}

@end

NS_ASSUME_NONNULL_END
