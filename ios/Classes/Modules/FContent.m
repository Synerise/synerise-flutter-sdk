//
//  FContent.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2022 Synerise. All rights reserved.
//

#import "FContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FContent ()

@end

@implementation FContent

#pragma mark - Lifecycle

+ (FContent *)sharedInstance {
    static FContent *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Lifecycle

- (FContent *)init {
    self = [super init];
    
    if (self = [super init]) {
      
    }

    return self;
}

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"getDocument"]) {
        [self getDocument:call result:result];
    } else if ([calledMethod isEqualToString:@"getDocuments"]) {
        [self getDocuments:call result:result];
    } else if ([calledMethod isEqualToString:@"getRecommendations"]) {
        [self getRecommendations:call result:result];
    } else if ([calledMethod isEqualToString:@"getScreenView"]) {
        [self getScreenView:call result:result];
    }
}

#pragma mark - Methods

- (void)getDocument:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    [SNRContent getDocument:slug success:^(NSDictionary *document) {
        if (document != nil) {
            result (document);
        } else {
            result([FlutterError errorWithCode:@"APIERROR" message:@"Api failure" details:nil]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getDocuments:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    SNRDocumentsApiQuery *documentsApiQuery = [self modelDocumentsApiQueryWithDictionary:dictionary];
    if (documentsApiQuery != nil) {
        [SNRContent getDocumentsWithApiQuery:documentsApiQuery success:^(NSArray *documents) {
            if (documents != nil) {
                result (documents);
            } else {
                result([FlutterError errorWithCode:@"APIERROR" message:@"Api failure" details:nil]);
            }
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    }
}

- (void)getRecommendations:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    SNRRecommendationOptions *recommendationOptions = [self modelRecommendationOptionsWithDictionary:dictionary];
    if (recommendationOptions != nil) {
        [SNRContent getRecommendations:recommendationOptions success:^(SNRRecommendationResponse *recommendationResponse) {
            if (recommendationResponse != nil) {
                NSDictionary *recommendationResponseDictionary = [self dictionaryWithRecommendationResponse:recommendationResponse];
                if (recommendationResponseDictionary != nil) {
                    result(recommendationResponseDictionary);
                } else {
                    result([FlutterError errorWithCode:@"APIERROR" message:@"Api failure" details:nil]);
                }
            } else {
                result([FlutterError errorWithCode:@"APIERROR" message:@"Api failure" details:nil]);
            }
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    }
}

- (void)getScreenView:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRContent getScreenViewWithSuccess:^(SNRScreenViewResponse *screenViewResponse) {
        if (screenViewResponse != nil) {
            NSDictionary *screenViewResponseDictionary = [self dictionaryWithScreenViewResponse:screenViewResponse];
            if (screenViewResponseDictionary != nil) {
                result(screenViewResponseDictionary);
            } else {
                result([FlutterError errorWithCode:@"APIERROR" message:@"Api failure" details:nil]);
            }
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

#pragma mark - SDK Mapping

- (SNRDocumentsApiQuery *)modelDocumentsApiQueryWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        SNRDocumentsApiQueryType type = SNRDocumentsApiQueryTypeBySchema;
        NSString *typeValue = [dictionary getStringForKey:@"typeValue"];
        
        if (typeValue != nil) {
            SNRDocumentsApiQuery *model = [[SNRDocumentsApiQuery alloc] initWithType:type typeValue:typeValue];
            
            model.version = [dictionary getStringForKey:@"version"];
            
            return model;
        }
    }
    
    return nil;
}

- (SNRRecommendationOptions *)modelRecommendationOptionsWithDictionary:(NSDictionary *)dictionary {
    NSString *slug = [dictionary getStringForKey:@"slug"];
    SNRRecommendationOptions *model = [[SNRRecommendationOptions alloc] initWithSlug:slug];
    
    if (dictionary != nil) {
        model.productID = [dictionary getStringForKey:@"productId"];
    }
    
    return model;
}

#pragma mark - Dart Mapping

- (nullable NSDictionary *)dictionaryWithRecommendationResponse:(SNRRecommendationResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setString:model.campaignHash forKey:@"campaignHash"];
        [dictionary setString:model.campaignID forKey:@"campaignID"];
        
        NSMutableArray *recommendationsArray = [@[] mutableCopy];
        for (SNRRecommendation *recommendationModel in model.items) {
            [recommendationsArray addObject:[self dictionaryWithRecommendation:recommendationModel]];
        }
        
        [dictionary setArray:recommendationsArray forKey:@"items"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithRecommendation:(SNRRecommendation *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.itemID forKey:@"itemID"];
        [dictionary setDictionary:model.attributes forKey:@"attributes"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithScreenViewResponse:(SNRScreenViewResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setDictionary:[self dictionaryWithScreenViewAudience:model.audience] forKey:@"audience"];
        
        [dictionary setString:model.identifier forKey:@"identifier"];
        [dictionary setString:model.hashString forKey:@"hashString"];
        [dictionary setString:model.path forKey:@"path"];
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setInteger:model.priority.integerValue forKey:@"priority"];
        [dictionary setString:model.descriptionText forKey:@"descriptionText"];
        
        [dictionary setGenericObject:model.data forKey:@"data"];
        
        [dictionary setString:model.version forKey:@"version"];
        [dictionary setString:model.parentVersion forKey:@"parentVersion"];
        
        [dictionary setDate:model.createdAt forKey:@"createdAt"];
        [dictionary setDate:model.updatedAt forKey:@"updatedAt"];
        [dictionary setDate:model.deletedAt forKey:@"deletedAt"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithScreenViewAudience:(SNRScreenViewAudience *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setArray:model.IDs forKey:@"IDs"];
        [dictionary setString:model.query forKey:@"query"];
        
        return dictionary;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
