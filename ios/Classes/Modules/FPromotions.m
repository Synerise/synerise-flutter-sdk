//
//  FPromotions.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FPromotions.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPromotions ()

@end

@implementation FPromotions

#pragma mark - Public

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result calledMethod:(NSString *)calledMethod {
    if ([calledMethod isEqualToString:@"getAllPromotions"]) {
        [self getAllPromotions:call result:result];
    } else if ([calledMethod isEqualToString:@"getPromotions"]) {
        [self getPromotions:call result:result];
    } else if ([calledMethod isEqualToString:@"getPromotionByUUID"]) {
        [self getPromotionByUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"getPromotionByCode"]) {
        [self getPromotionByCode:call result:result];
    } else if ([calledMethod isEqualToString:@"activatePromotionByUUID"]) {
        [self activatePromotionByUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"activatePromotionByCode"]) {
        [self activatePromotionByCode:call result:result];
    } else if ([calledMethod isEqualToString:@"deactivatePromotionByUUID"]) {
        [self deactivatePromotionByUUID:call result:result];
    } else if ([calledMethod isEqualToString:@"deactivatePromotionByCode"]) {
        [self deactivatePromotionByCode:call result:result];
    } else if ([calledMethod isEqualToString:@"activatePromotionsBatch"]) {
        [self activatePromotionsBatch:call result:result];
    } else if ([calledMethod isEqualToString:@"deactivatePromotionsBatch"]) {
        [self deactivatePromotionsBatch:call result:result];
    } else if ([calledMethod isEqualToString:@"getOrAssignVoucher"]) {
        [self getOrAssignVoucher:call result:result];
    } else if ([calledMethod isEqualToString:@"assignVoucherCode"]) {
        [self assignVoucherCode:call result:result];
    } else if ([calledMethod isEqualToString:@"getAssignedVoucherCodes"]) {
        [self getAssignedVoucherCodes:call result:result];
    }
}

#pragma mark - Methods

//getAllPromotions(onSuccess: (promotionResponse: PromotionResponse) => void, onError: (error: Error) => void)

- (void)getAllPromotions:(FlutterMethodCall *)call result:(FlutterResult)result
{
    [SNRPromotions getPromotionsWithSuccess:^(SNRPromotionResponse * _Nonnull promotionResponse) {
        NSDictionary *promotionResponseDictionary = [self dictionaryWithPromotionResponse:promotionResponse];
        if (promotionResponseDictionary != nil) {
            result(promotionResponseDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];}

//getPromotions(apiQuery: PromotionsApiQuery, onSuccess: (promotionResponse: PromotionResponse) => void, onError: (error: Error) => void)

- (void)getPromotions:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSDictionary *dictionary = call.arguments;
    SNRPromotionsApiQuery *promotionsApiQuery = [self modelPromotionsApiQueryWithDictionary:dictionary];
    if (promotionsApiQuery != nil) {
        [SNRPromotions getPromotionsWithApiQuery:promotionsApiQuery success:^(SNRPromotionResponse *promotionResponse) {
            NSDictionary *promotionResponseDictionary = [self dictionaryWithPromotionResponse:promotionResponse];
            if (promotionResponseDictionary != nil) {
                result(promotionResponseDictionary);
            } else {
                result([self defaultFlutterError]);
            }
        } failure:^(NSError *error) {
            result([self makeFlutterErrorWithError:error]);
        }];
    }
}

//getPromotionByUUID(uuid: string, onSuccess: (promotion: Promotion) => void, onError: (error: Error) => void)

- (void)getPromotionByUUID:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *UUID = call.arguments;
    [SNRPromotions getPromotionByUuid:UUID success:^(SNRPromotion *promotion) {
        NSDictionary *promotionDictionary = [self dictionaryWithPromotion:promotion];
        if (promotionDictionary != nil) {
            result(promotionDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//getPromotionByCode(code: string, onSuccess: (promotion: Promotion) => void, onError: (error: Error) => void)

- (void)getPromotionByCode:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *code = call.arguments;
    [SNRPromotions getPromotionByCode:code success:^(SNRPromotion *promotion) {
        NSDictionary *promotionDictionary = [self dictionaryWithPromotion:promotion];
        if (promotionDictionary != nil) {
            result(promotionDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//activatePromotionByUUID(uuid: string, onSuccess: () => void, onError: (error: Error) => void)

- (void)activatePromotionByUUID:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *UUID = call.arguments;
    [SNRPromotions activatePromotionByUuid:UUID success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//activatePromotionByCode(code: string, onSuccess: () => void, onError: (error: Error) => void)

- (void)activatePromotionByCode:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *code = call.arguments;
    [SNRPromotions activatePromotionByCode:code success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//activatePromotionsBatch(promotionsToActivate: Array<PromotionIdentifier>, onSuccess: () => void, onError: (error: Error) => void)

- (void)activatePromotionsBatch:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSArray *array = call.arguments;
    NSArray *promotionIdentifiers = [self modelPromotionIdentifiersWithArray:array];
    [SNRPromotions activatePromotionsWithIdentifiers:promotionIdentifiers success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//deactivatePromotionByUUID(uuid: string, onSuccess: () => void, onError: (error: Error) => void)

- (void)deactivatePromotionByUUID:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *UUID = call.arguments;
    [SNRPromotions deactivatePromotionByUuid:UUID success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//deactivatePromotionByCode(code: string, onSuccess: () => void, onError: (error: Error) => void)

- (void)deactivatePromotionByCode:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *code = call.arguments;
    [SNRPromotions deactivatePromotionByCode:code success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//deactivatePromotionsBatch(promotionsToDeactivate: Array<PromotionIdentifier>, onSuccess: () => void, onError: (error: Error) => void)

- (void)deactivatePromotionsBatch:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSArray *array = call.arguments;
    NSArray *promotionIdentifiers = [self modelPromotionIdentifiersWithArray:array];
    [SNRPromotions deactivatePromotionsWithIdentifiers:promotionIdentifiers success:^(BOOL isSuccess) {
        result(@YES);
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

//getOrAssignVoucher(poolUuid: string, onSuccess: (assignVoucherRespone: AssignVoucherResponse) => void, onError: (error: Error) => void)

- (void)getOrAssignVoucher:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *poolUUID = call.arguments;
    [SNRPromotions getOrAssignVoucherWithPoolUUID:poolUUID success:^(SNRAssignVoucherResponse *assignVoucherResponse) {
        NSDictionary *assignVoucherResponseDictionary = [self dictionaryWithAssignVoucherResponse:assignVoucherResponse];
        if (assignVoucherResponseDictionary != nil) {
            result(assignVoucherResponseDictionary);
        }  else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];}


//assignVoucherCode(poolUuid: string, onSuccess: (assignVoucherRespone: AssignVoucherResponse) => void, onError: (error: Error) => void)

- (void)assignVoucherCode:(FlutterMethodCall *)call result:(FlutterResult)result
{
    NSString *poolUUID = call.arguments;
    [SNRPromotions assignVoucherCodeWithPoolUUID:poolUUID success:^(SNRAssignVoucherResponse *assignVoucherResponse) {
        NSDictionary *assignVoucherResponseDictionary = [self dictionaryWithAssignVoucherResponse:assignVoucherResponse];
        if (assignVoucherResponseDictionary != nil) {
            result(assignVoucherResponseDictionary);
        } else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];}



- (void)getAssignedVoucherCodes:(FlutterMethodCall *)call result:(FlutterResult)result
{
    [SNRPromotions getAssignedVoucherCodesWithSuccess:^(SNRVoucherCodesResponse *voucherCodesResponse) {
        NSDictionary *voucherCodesResponseDictionary = [self dictionaryWithVoucherCodesResponse:voucherCodesResponse];
        if (voucherCodesResponseDictionary != nil) {
            result(voucherCodesResponseDictionary);
        }
        else {
            result([self defaultFlutterError]);
        }
    } failure:^(NSError *error) {
        result([self makeFlutterErrorWithError:error]);
    }];
}

#pragma mark - SDK Mapping

- (SNRPromotionsApiQuery *)modelPromotionsApiQueryWithDictionary:(NSDictionary *)dictionary {
    SNRPromotionsApiQuery *model = [SNRPromotionsApiQuery new];
    
    if (dictionary != nil) {
        model.statuses = [dictionary getArrayForKey:@"statuses"];
        model.types = [dictionary getArrayForKey:@"types"];
        
        NSArray *sorting = [dictionary getArrayForKey:@"sorting"];
        if (sorting != nil && sorting.count > 0) {
            NSMutableArray *sortingNormalized = [@[] mutableCopy];
            for (NSDictionary *sortingItem in dictionary[@"sorting"]) {
                NSString *property = sortingItem[@"property"];
                NSString *order = sortingItem[@"order"];
                if (property != nil && order != nil) {
                    [sortingNormalized addObject:@{
                        property: order
                    }];
                }
            }
            
            model.sorting = sortingNormalized;
        }
        
        model.limit = [dictionary getIntegerForKey:@"limit"];
        model.page = [dictionary getIntegerForKey:@"page"];
        
        model.includeMeta = [dictionary getBoolForKey:@"includeMeta"];
    }
    
    return model;
}

- (NSArray<SNRPromotionIdentifier *> *)modelPromotionIdentifiersWithArray:(NSArray<NSDictionary *> *)array {
    NSMutableArray *promotionIdentifiers = [@[] mutableCopy];
    
    if (array != nil && array.count > 0) {
        for (NSDictionary *dictionary in array) {
            SNRPromotionIdentifier *promotionIdentifier = [self modelPromotionIdentifierWithDictionary:dictionary];
            if (promotionIdentifier != nil) {
                [promotionIdentifiers addObject:promotionIdentifier];
            }
        }
    }
    
    return promotionIdentifiers;
}

- (nullable SNRPromotionIdentifier *)modelPromotionIdentifierWithDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil) {
        NSString *key = [dictionary getStringForKey:@"key"];
        NSString *value = [dictionary getStringForKey:@"value"];
        
        if ((key != nil && [key isKindOfClass:[NSString class]] == YES) && (value != nil && [value isKindOfClass:[NSString class]] == YES)) {
            if ([key isEqualToString:@"CODE"]) {
                return [[SNRPromotionIdentifier alloc] initWithCode:value];
            }
            
            if ([key isEqualToString:@"UUID"]) {
                return [[SNRPromotionIdentifier alloc] initWithUUID:value];
            }
        }
    }
    
    return nil;
}

#pragma mark - Dart Mapping

- (nullable NSDictionary *)dictionaryWithPromotionResponse:(SNRPromotionResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        SNRPromotionResponseMetadata *metadata = model.metadata;
        if (metadata != nil) {
            [dictionary setInteger:metadata.totalCount forKey:@"totalCount"];
            [dictionary setInteger:metadata.totalPages forKey:@"totalPages"];
            [dictionary setInteger:metadata.page forKey:@"page"];
            [dictionary setInteger:metadata.limit forKey:@"limit"];
            [dictionary setInteger:metadata.code forKey:@"code"];
        }
        
        NSMutableArray *promotionsArray = [@[] mutableCopy];
        for (SNRPromotion *promotionModel in model.items) {
            [promotionsArray addObject:[self dictionaryWithPromotion:promotionModel]];
        }
        
        [dictionary setArray:promotionsArray forKey:@"items"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotion:(SNRPromotion *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.uuid forKey:@"uuid"];
        
        [dictionary setString:model.code forKey:@"code"];
        [dictionary setString:SNR_PromotionStatusToString(model.status) forKey:@"status"];
        [dictionary setString:SNR_PromotionTypeToString(model.type) forKey:@"type"];
        [dictionary setDictionary:[self dictionaryWithPromotionDetails:model.details] forKey:@"details"];
        
        [dictionary setNumber:model.redeemLimitPerClient forKey:@"redeemLimitPerClient"];
        [dictionary setNumber:model.redeemQuantityPerActivation forKey:@"redeemQuantityPerActivation"];
        [dictionary setNumber:model.currentRedeemedQuantity forKey:@"currentRedeemedQuantity"];
        [dictionary setNumber:model.currentRedeemLimit forKey:@"currentRedeemLimit"];
        [dictionary setNumber:model.activationCounter forKey:@"activationCounter"];
        [dictionary setNumber:model.possibleRedeems forKey:@"possibleRedeems"];
        [dictionary setNumber:model.requireRedeemedPoints forKey:@"requireRedeemedPoints"];
        
        [dictionary setString:SNR_PromotionDiscountTypeToString(model.discountType) forKey:@"discountType"];
        [dictionary setNumber:model.discountValue forKey:@"discountValue"];
        [dictionary setString:SNR_PromotionDiscountModeToString(model.discountMode) forKey:@"discountMode"];
        [dictionary setDictionary:[self dictionaryWithPromotionDiscountModeDetails:model.discountModeDetails] forKey:@"discountModeDetails"];
        
        [dictionary setNumber:model.priority forKey:@"priority"];
        [dictionary setNumber:model.price forKey:@"price"];
        [dictionary setString:SNR_PromotionItemScopeToString(model.itemScope) forKey:@"itemScope"];
        [dictionary setNumber:model.minBasketValue forKey:@"minBasketValue"];
        [dictionary setNumber:model.maxBasketValue forKey:@"maxBasketValue"];
        
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setString:model.headline forKey:@"headline"];
        [dictionary setString:model.descriptionText forKey:@"descriptionText"];
        
        [dictionary setDictionary:[self dictionaryWithPromotionDiscountModeDetails:model.discountModeDetails] forKey:@"discountModeDetails"];
        
        [dictionary setArray:[self arrayWithPromotionImages:model.images] forKey:@"images"];
        
        [dictionary setDate:model.startAt forKey:@"startAt"];
        [dictionary setDate:model.expireAt forKey:@"expireAt"];
        [dictionary setDate:model.lastingAt forKey:@"lastingAt"];
        [dictionary setNumber:model.lastingTime forKey:@"lastingTime"];
        [dictionary setString:model.displayFrom forKey:@"displayFrom"];
        [dictionary setString:model.displayTo forKey:@"displayTo"];
        
        [dictionary setDictionary:model.params forKey:@"params"];
        [dictionary setArray:model.catalogIndexItems forKey:@"catalogIndexItems"];
        [dictionary setArray:model.tags forKey:@"tags"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotionDetails:(SNRPromotionDetails *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setDictionary:[self dictionaryWithPromotionDiscountTypeDetails:model.discountType] forKey:@"discountType"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotionDiscountTypeDetails:(SNRPromotionDiscountTypeDetails *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.name forKey:@"name"];
        [dictionary setBool:model.outerScope forKey:@"outerScope"];
        [dictionary setInteger:model.requiredItemsCount forKey:@"requiredItemsCount"];
        [dictionary setInteger:model.discountedItemsCount forKey:@"discountedItemsCount"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotionDiscountModeDetails:(SNRPromotionDiscountModeDetails *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        NSMutableArray *promotionDiscountSteps = [@[] mutableCopy];
        for (SNRPromotionDiscountStep *promotionDiscountStep in model.discountSteps) {
            NSDictionary *promotionDiscountStepDictionary = [self dictionaryWithPromotionDiscountStep:promotionDiscountStep];
            if (promotionDiscountStepDictionary != nil) {
                [promotionDiscountSteps addObject:promotionDiscountStepDictionary];
            }
        }
        
        [dictionary setArray:promotionDiscountSteps forKey:@"discountSteps"];
        [dictionary setString:SNR_PromotionDiscountUsageTriggerToString(model.discountUsageTrigger) forKey:@"discountUsageTrigger"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSArray<NSDictionary *> *)arrayWithPromotionImages:(NSArray<SNRPromotionImage *> *)model {
        if (model != nil && model.count > 0) {
            
            NSMutableArray *imagesArray = [@[] mutableCopy];
            for (SNRPromotionImage *promotionImage in model) {
                [imagesArray addObject:[self dictionaryWithPromotionImage:promotionImage]];
            }
            NSArray* immutableImagesArray = [NSArray arrayWithArray:imagesArray];
            
            return immutableImagesArray;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotionImage:(SNRPromotionImage *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.url forKey:@"url"];
        [dictionary setString:SNR_PromotionImageTypeToString(model.type) forKey:@"type"];
        
        return dictionary;
    }

    return nil;
}

- (nullable NSDictionary *)dictionaryWithPromotionDiscountStep:(SNRPromotionDiscountStep *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setNumber:model.discountValue forKey:@"discountValue"];
        [dictionary setNumber:model.usageThreshold forKey:@"usageThreshold"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithAssignVoucherResponse:(SNRAssignVoucherResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.message forKey:@"message"];
        [dictionary setDictionary:[self dictionaryWithAssignVoucherData:model.assignVoucherData] forKey:@"data"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithVoucherCodesResponse:(SNRVoucherCodesResponse *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        NSMutableArray *voucherCodesArray = [@[] mutableCopy];
        for (SNRVoucherCodesData *voucherCodesDataModel in model.items) {
            [voucherCodesArray addObject:[self dictionaryWithVoucherCodesData:voucherCodesDataModel]];
        }
        
        [dictionary setArray:voucherCodesArray forKey:@"data"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithAssignVoucherData:(SNRAssignVoucherData *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.code forKey:@"code"];
        [dictionary setDate:model.expireIn forKey:@"expireIn"];
        [dictionary setDate:model.redeemAt forKey:@"redeemAt"];
        [dictionary setDate:model.assignedAt forKey:@"assignedAt"];
        [dictionary setDate:model.createdAt forKey:@"createdAt"];
        [dictionary setDate:model.updatedAt forKey:@"updatedAt"];
        
        return dictionary;
    }
    
    return nil;
}

- (nullable NSDictionary *)dictionaryWithVoucherCodesData:(SNRVoucherCodesData *)model {
    if (model != nil) {
        NSMutableDictionary *dictionary = [@{} mutableCopy];
        
        [dictionary setString:model.code forKey:@"code"];
        [dictionary setString:SNR_VoucherCodeStatusToString(model.status) forKey:@"status"];
        [dictionary setInteger:model.clientId forKey:@"clientId"];
        [dictionary setString:model.clientUuid forKey:@"clientUuid"];
        [dictionary setString:model.poolUuid forKey:@"poolUuid"];
        [dictionary setDate:model.expireIn forKey:@"expireIn"];
        [dictionary setDate:model.redeemAt forKey:@"redeemAt"];
        [dictionary setDate:model.assignedAt forKey:@"assignedAt"];
        [dictionary setDate:model.createdAt forKey:@"createdAt"];
        [dictionary setDate:model.updatedAt forKey:@"updatedAt"];
        
        return dictionary;
    }
    
    return nil;
}


@end

NS_ASSUME_NONNULL_END
