//
//  FContent.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FContent ()

@end

@implementation FContent

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
    } else if ([calledMethod isEqualToString:@"getRecommendationsV2"]) {
        [self getRecommendationsV2:call result:result];
    } else if ([calledMethod isEqualToString:@"generateDocument"]) {
        [self generateDocument:call result:result];
    } else if ([calledMethod isEqualToString:@"generateScreenView"]) {
        [self generateScreenView:call result:result];
    }
}

#pragma mark - Methods

- (void)getDocument:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    
    [SNRContent getDocument:slug success:^(NSDictionary *document) {
        result (document);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getDocuments:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRDocumentsApiQuery *documentsApiQuery = [self modelDocumentsApiQueryWithDictionary:dictionary];
    if (documentsApiQuery == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRContent getDocumentsWithApiQuery:documentsApiQuery success:^(NSArray *documents) {
        result (documents);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getRecommendations:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRRecommendationOptions *recommendationOptions = [self modelRecommendationOptionsWithDictionary:dictionary];
    if (recommendationOptions == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRContent getRecommendations:recommendationOptions success:^(SNRRecommendationResponse *recommendationResponse) {
        NSDictionary *recommendationResponseDictionary = [self dictionaryWithRecommendationResponse:recommendationResponse];
        if (recommendationResponseDictionary != nil) {
            result(recommendationResponseDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getScreenView:(FlutterMethodCall *)call result:(FlutterResult)result {
    [SNRContent getScreenViewWithSuccess:^(SNRScreenViewResponse *screenViewResponse) {
        NSDictionary *screenViewResponseDictionary = [self dictionaryWithScreenViewResponse:screenViewResponse];
        if (screenViewResponseDictionary != nil) {
            result(screenViewResponseDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)getRecommendationsV2:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRRecommendationOptions *recommendationOptions = [self modelRecommendationOptionsWithDictionary:dictionary];
    if (recommendationOptions == nil) {
        result([self defaultFlutterError]);
        return;
    }
    
    [SNRContent getRecommendationsV2:recommendationOptions success:^(SNRRecommendationResponse *recommendationResponse) {
        NSDictionary *recommendationResponseDictionary = [self dictionaryWithRecommendationResponse:recommendationResponse];
        if (recommendationResponseDictionary != nil) {
            result(recommendationResponseDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)generateDocument:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    
    [SNRContent generateDocument:slug success:^(SNRDocument *document) {
        NSDictionary *documentDictionary = [self dictionaryWithDocument:document];
        result (documentDictionary);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)generateScreenView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    
    [SNRContent generateScreenView:slug success:^(SNRScreenView *screenView) {
        NSDictionary *screenViewDictionary = [self dictionaryWithScreenView:screenView];
        result (screenViewDictionary);
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
        model.productID = [dictionary getStringForKey:@"productID"];
        model.productIDs = [dictionary getArrayForKey:@"productIDs"];
        model.itemsExcluded = [dictionary getArrayForKey:@"itemsExcluded"];
        model.additionalFilters = [dictionary getStringForKey:@"additionalFilters"];
        if (dictionary[@"filtersJoiner"] != nil) {
            model.filtersJoiner =  ([self modelFiltersJoiner:[dictionary getStringForKey:@"filtersJoiner"]]);
        }
        model.additionalElasticFilters = [dictionary getStringForKey:@"additionalElasticFilters"];
        if (dictionary[@"elasticFiltersJoiner"] != nil) {
            model.elasticFiltersJoiner = ([self modelFiltersJoiner:[dictionary getStringForKey:@"elasticFiltersJoiner"]]);
        }
        model.displayAttribute = [dictionary getArrayForKey:@"displayAttribute"];
        model.includeContextItems = [dictionary getBoolForKey:@"includeContextItems"];
    }
    
    return model;
}

- (SNRRecommendationFiltersJoinerRule)modelFiltersJoiner:(NSString *)string {
    if ([string isEqualToString:@"and"]) {
        return SNRRecommendationFiltersJoinerRuleAnd;
    } else if ([string isEqualToString:@"or"]) {
        return SNRRecommendationFiltersJoinerRuleOr;
    } else if ([string isEqualToString:@"replace"]) {
        return SNRRecommendationFiltersJoinerRuleReplace;
    } else {
        return -1;
    }
}

#pragma mark - Dart Mapping

- (nullable NSDictionary *)dictionaryWithRecommendationResponse:(SNRRecommendationResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setString:model.campaignHash forKey:@"campaignHash"];
        [dictionary setString:model.campaignID forKey:@"campaignID"];
        [dictionary setString:model.correlationID forKey:@"correlationID"];
        [dictionary setString:model.schema forKey:@"schema"];
        [dictionary setString:model.UUID forKey:@"uuid"];
        [dictionary setString:model.slug forKey:@"slug"];
        
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

- (nullable NSDictionary *)dictionaryWithDocument:(SNRDocument *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.identifier forKey:@"identifier"];
        [dictionary setString:model.slug forKey:@"slug"];
        [dictionary setString:model.schema forKey:@"schema"];
        [dictionary setDictionary:model.content forKey:@"content"];
        
        return dictionary;
    }
    return nil;
}

- (nullable NSDictionary *)dictionaryWithScreenView:(SNRScreenView *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        [dictionary setString:model.identifier forKey:@"identifier"];
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setString:model.hashString forKey:@"hashString"];
        [dictionary setString:model.path forKey:@"path"];
        [dictionary setInteger:model.priority forKey:@"priority"];
        [dictionary setDictionary:[self dictionaryWithScreenViewAudienceInfo:model.audience] forKey:@"audience"];
        [dictionary setGenericObject:model.data forKey:@"data"];
        [dictionary setDate:model.createdAt forKey:@"createdAt"];
        [dictionary setDate:model.updatedAt forKey:@"updatedAt"];
        
        return dictionary;
    }
    return nil;
}

- (nullable NSDictionary *)dictionaryWithScreenViewAudienceInfo:(SNRScreenViewAudienceInfo *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setArray:model.segments forKey:@"segments"];
        [dictionary setString:model.query forKey:@"query"];
        [dictionary setString:model.targetType forKey:@"targetType"];
        
        return dictionary;
    }
    
    return nil;
}

@end

NS_ASSUME_NONNULL_END
