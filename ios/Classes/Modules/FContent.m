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
    if ([calledMethod isEqualToString:@"generateDocument"]) {
        [self generateDocument:call result:result];
    } else if ([calledMethod isEqualToString:@"generateDocumentWithApiQuery"]) {
        [self generateDocumentWithApiQuery:call result:result];
    } else if ([calledMethod isEqualToString:@"getRecommendationsV2"]) {
        [self getRecommendationsV2:call result:result];
    } else if ([calledMethod isEqualToString:@"generateScreenView"]) {
        [self generateScreenView:call result:result];
    } else if ([calledMethod isEqualToString:@"generateScreenViewWithApiQuery"]) {
        [self generateScreenViewWithApiQuery:call result:result];
    } else if ([calledMethod isEqualToString:@"generateBrickworks"]) {
      [self generateBrickworks:call result:result];
  }
}

#pragma mark - Methods

- (void)generateDocument:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    
    [SNRContent generateDocument:slug success:^(SNRDocument *document) {
        NSDictionary *documentDictionary = [self dictionaryWithDocument:document];
        result (documentDictionary);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)generateDocumentWithApiQuery:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;
    
    SNRDocumentApiQuery *documentApiQuery = [self modelDocumentApiQueryWithDictionary:dictionary];
    if (documentApiQuery == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRContent generateDocumentWithApiQuery:documentApiQuery success:^(SNRDocument *document) {
        NSDictionary *documentDictionary = [self dictionaryWithDocument:document];
        if (documentDictionary != nil) {
            result(documentDictionary);
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

- (void)generateScreenView:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *slug = call.arguments;
    
    [SNRContent generateScreenView:slug success:^(SNRScreenView *screenView) {
        NSDictionary *screenViewDictionary = [self dictionaryWithScreenView:screenView];
        result (screenViewDictionary);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)generateScreenViewWithApiQuery:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    SNRScreenViewApiQuery *screenViewApiQuery = [self modelScreenViewApiQueryWithDictionary:dictionary];
    if (screenViewApiQuery == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRContent generateScreenViewWithApiQuery:screenViewApiQuery success:^(SNRScreenView *screenView) {
        NSDictionary *screenViewDictionary = [self dictionaryWithScreenView:screenView];
        if (screenViewDictionary != nil) {
            result(screenViewDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

- (void)generateBrickworks:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *dictionary = call.arguments;

    SNRBrickworksApiQuery *brickworksApiQuery = [self modelBrickworksApiQueryWithDictionary:dictionary];
    if (brickworksApiQuery == nil) {
        result([self defaultFlutterError]);
        return;
    }

    [SNRContent generateBrickworksWithApiQuery:brickworksApiQuery success:^(NSDictionary *brickworksDictionary) {
        result(brickworksDictionary);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

#pragma mark - SDK Mapping

- (SNRDocumentApiQuery *)modelDocumentApiQueryWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        NSString *slug = [dictionary getStringForKey:@"slug"];
        if (slug != nil) {
            SNRDocumentApiQuery *model = [[SNRDocumentApiQuery alloc] initWithSlug:slug];
            model.productId = [dictionary getStringForKey:@"productId"];
            model.itemsIds = [dictionary getArrayForKey:@"itemsIds"];
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
            model.params = [dictionary getDictionaryForKey:@"params"];
            
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
        model.productIDs = [dictionary getArrayForKey:@"itemsIds"];
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

- (SNRScreenViewApiQuery *)modelScreenViewApiQueryWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        NSString *feedSlug = [dictionary getStringForKey:@"feedSlug"];
        if (feedSlug != nil) {
            SNRScreenViewApiQuery *model = [[SNRScreenViewApiQuery alloc] initWithFeedSlug:feedSlug];
            model.productID = [dictionary getStringForKey:@"productId"];
            model.params = [dictionary getDictionaryForKey:@"params"];
            
            return model;
        }
    }
    
    return nil;
}

- (SNRBrickworksApiQuery *)modelBrickworksApiQueryWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        NSString *schemaSlug = [dictionary getStringForKey:@"schemaSlug"];
        if (schemaSlug != nil) {
            NSDictionary *context = [dictionary getDictionaryForKey:@"context"];
            NSDictionary *fieldContext = [dictionary getDictionaryForKey:@"fieldContext"];

            NSString *recordSlug = [dictionary getStringForKey:@"recordSlug"];
            if (recordSlug != nil) {
                SNRBrickworksApiQuery *model = [[SNRBrickworksApiQuery alloc] initWithSchemaSlug:schemaSlug recordSlug:recordSlug];
                model.context = context;
                model.fieldContext = fieldContext;

                return model;
            }

            NSString *recordId = [dictionary getStringForKey:@"recordId"];
            if (recordId != nil) {
                SNRBrickworksApiQuery *model = [[SNRBrickworksApiQuery alloc] initWithSchemaSlug:schemaSlug recordId:recordId];
                model.context = context;
                model.fieldContext = fieldContext;
                
                return model;
            }
        }
    }
    
    return nil;
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

- (nullable NSDictionary *)dictionaryWithDocument:(SNRDocument *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.uuid forKey:@"uuid"];
        [dictionary setString:model.slug forKey:@"slug"];
        [dictionary setString:model.schema forKey:@"schema"];
        [dictionary setDictionary:model.content forKey:@"content"];
        
        return dictionary;
    }
    
    return nil;
}

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
