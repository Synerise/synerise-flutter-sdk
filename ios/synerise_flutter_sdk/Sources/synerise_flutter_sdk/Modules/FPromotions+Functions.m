//
//  FPromotions+Functions.m
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import "FPromotions+Functions.h"

NSString * const SNR_PROMOTION_STATUS_NONE = @"";
NSString * const SNR_PROMOTION_STATUS_ACTIVE = @"ACTIVE";
NSString * const SNR_PROMOTION_STATUS_ASSIGNED = @"ASSIGNED";
NSString * const SNR_PROMOTION_STATUS_REDEEMED = @"REDEEMED";

static NSString * const SNRPromotionStatusNoneString = SNR_PROMOTION_STATUS_NONE;
static NSString * const SNRPromotionStatusActiveString = SNR_PROMOTION_STATUS_ACTIVE;
static NSString * const SNRPromotionStatusAssignedString = SNR_PROMOTION_STATUS_ASSIGNED;
static NSString * const SNRPromotionStatusRedeemedString = SNR_PROMOTION_STATUS_REDEEMED;

NSString * SNR_PromotionStatusToString(SNRPromotionStatus type) {
    switch (type) {
        case SNRPromotionStatusActive: return SNRPromotionStatusActiveString;
        case SNRPromotionStatusAssigned: return SNRPromotionStatusAssignedString;
        case SNRPromotionStatusRedeemed: return SNRPromotionStatusRedeemedString;
        default: return SNRPromotionStatusNoneString;
    }
}

SNRPromotionStatus SNR_StringToPromotionStatus(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionStatusActiveString]) {
        return SNRPromotionStatusActive;
    }

    if ([string isEqualToString:SNRPromotionStatusAssignedString]) {
        return SNRPromotionStatusAssigned;
    }

    if ([string isEqualToString:SNRPromotionStatusRedeemedString]) {
        return SNRPromotionStatusRedeemed;
    }

    return SNRPromotionStatusNone;
}

NSString * const SNR_PROMOTION_TYPE_UNKNOWN = @"";
NSString * const SNR_PROMOTION_TYPE_MEMBERS_ONLY = @"MEMBERS_ONLY";
NSString * const SNR_PROMOTION_TYPE_CUSTOM = @"CUSTOM";
NSString * const SNR_PROMOTION_TYPE_GENERAL = @"GENERAL";
NSString * const SNR_PROMOTION_TYPE_HANDBILL = @"HANDBILL";

static NSString * const SNRPromotionTypeUnknownString = SNR_PROMOTION_TYPE_UNKNOWN;
static NSString * const SNRPromotionTypeMembersOnlyString = SNR_PROMOTION_TYPE_MEMBERS_ONLY;
static NSString * const SNRPromotionTypeCustomString = SNR_PROMOTION_TYPE_CUSTOM;
static NSString * const SNRPromotionTypeGeneralString = SNR_PROMOTION_TYPE_GENERAL;
static NSString * const SNRPromotionTypeHandbillString = SNR_PROMOTION_TYPE_HANDBILL;

NSString * SNR_PromotionTypeToString(SNRPromotionType type) {
    switch (type) {
        case SNRPromotionTypeMembersOnly: return SNRPromotionTypeMembersOnlyString;
        case SNRPromotionTypeCustom: return SNRPromotionTypeCustomString;
        case SNRPromotionTypeGeneral: return SNRPromotionTypeGeneralString;
        case SNRPromotionTypeHandbill: return SNRPromotionTypeHandbillString;
        default: return SNRPromotionTypeUnknownString;
    }
}

SNRPromotionType SNR_StringToPromotionType(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionTypeMembersOnlyString]) {
        return SNRPromotionTypeMembersOnly;
    }

    if ([string isEqualToString:SNRPromotionTypeCustomString]) {
        return SNRPromotionTypeCustom;
    }

    if ([string isEqualToString:SNRPromotionTypeGeneralString]) {
        return SNRPromotionTypeGeneral;
    }

    if ([string isEqualToString:SNRPromotionTypeHandbillString]) {
        return SNRPromotionTypeHandbill;
    }

    return SNRPromotionTypeUnknown;
}

static NSString * const SNRPromotionDiscountTypeNoneString = @"NONE";
static NSString * const SNRPromotionDiscountTypePercentString = @"PERCENT";
static NSString * const SNRPromotionDiscountTypeAmountString = @"AMOUNT";
static NSString * const SNRPromotionDiscountType2For1String = @"2_FOR_1";
static NSString * const SNRPromotionDiscountTypePointsString = @"POINTS";
static NSString * const SNRPromotionDiscountTypeMultibuyString = @"MULTIBUY";
static NSString * const SNRPromotionDiscountTypeExactPriceString = @"EXACT_PRICE";

NSString * SNR_PromotionDiscountTypeToString(SNRPromotionDiscountType type) {
    switch (type) {
        case SNRPromotionDiscountTypeNone: return SNRPromotionDiscountTypeNoneString;
        case SNRPromotionDiscountTypePercent: return SNRPromotionDiscountTypePercentString;
        case SNRPromotionDiscountTypeAmount: return SNRPromotionDiscountTypeAmountString;
        case SNRPromotionDiscountType2For1: return SNRPromotionDiscountType2For1String;
        case SNRPromotionDiscountTypePoints: return SNRPromotionDiscountTypePointsString;
        case SNRPromotionDiscountTypeMultibuy: return SNRPromotionDiscountTypeMultibuyString;
        case SNRPromotionDiscountTypeExactPrice: return SNRPromotionDiscountTypeExactPriceString;
        default: return SNRPromotionDiscountTypeNoneString;
    }
}

SNRPromotionDiscountType SNR_StringToPromotionDiscountType(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionDiscountTypePercentString]) {
        return SNRPromotionDiscountTypePercent;
    }

    if ([string isEqualToString:SNRPromotionDiscountTypeAmountString]) {
        return SNRPromotionDiscountTypeAmount;
    }

    if ([string isEqualToString:SNRPromotionDiscountType2For1String]) {
        return SNRPromotionDiscountType2For1;
    }

    if ([string isEqualToString:SNRPromotionDiscountTypePointsString]) {
        return SNRPromotionDiscountTypePoints;
    }

    if ([string isEqualToString:SNRPromotionDiscountTypeMultibuyString]) {
        return SNRPromotionDiscountTypeMultibuy;
    }

    if ([string isEqualToString:SNRPromotionDiscountTypeExactPriceString]) {
        return SNRPromotionDiscountTypeExactPrice;
    }

    return SNRPromotionDiscountTypeNone;
}

static NSString * const SNRPromotionDiscountModeStaticString = @"STATIC";
static NSString * const SNRPromotionDiscountModeStepString = @"STEP";

NSString * SNR_PromotionDiscountModeToString(SNRPromotionDiscountMode mode) {
    switch (mode) {
        case SNRPromotionDiscountModeStatic: return SNRPromotionDiscountModeStaticString;
        case SNRPromotionDiscountModeStep: return SNRPromotionDiscountModeStepString;
        default: return SNRPromotionDiscountModeStaticString;
    }
}

SNRPromotionDiscountMode SNR_StringToPromotionDiscountMode(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionDiscountModeStaticString]) {
        return SNRPromotionDiscountModeStatic;
    }
    
    if ([string isEqualToString:SNRPromotionDiscountModeStepString]) {
        return SNRPromotionDiscountModeStep;
    }
    
    return SNRPromotionDiscountModeStatic;
}

static NSString * const SNRPromotionItemScopeLineItemString = @"LINE_ITEM";
static NSString * const SNRPromotionItemScopeBasketString = @"BASKET";

NSString * SNR_PromotionItemScopeToString(SNRPromotionItemScope scope) {
    switch (scope) {
        case SNRPromotionItemScopeLineItem: return SNRPromotionItemScopeLineItemString;
        case SNRPromotionItemScopeBasket: return SNRPromotionItemScopeBasketString;
        default: return SNRPromotionItemScopeLineItemString;
    }
}

SNRPromotionItemScope SNR_StringToPromotionItemScope(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionItemScopeLineItemString]) {
        return SNRPromotionItemScopeLineItem;
    }
    
    if ([string isEqualToString:SNRPromotionItemScopeBasketString]) {
        return SNRPromotionItemScopeBasket;
    }
    
    return SNRPromotionItemScopeLineItem;
}

static NSString * const SNRPromotionDiscountUsageTriggerTransactionString = @"TRANSACTION";
static NSString * const SNRPromotionDiscountUsageTriggerRedeemString = @"REDEEM";

NSString * SNR_PromotionDiscountUsageTriggerToString(SNRPromotionDiscountUsageTrigger trigger) {
    switch (trigger) {
        case SNRPromotionDiscountUsageTriggerTransaction: return SNRPromotionDiscountUsageTriggerTransactionString;
        case SNRPromotionDiscountUsageTriggerRedeem: return SNRPromotionDiscountUsageTriggerRedeemString;
        default: return SNRPromotionDiscountUsageTriggerTransactionString;
    }
}

SNRPromotionDiscountUsageTrigger SNR_StringToPromotionDiscountUsageTrigger(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionDiscountUsageTriggerTransactionString]) {
        return SNRPromotionDiscountUsageTriggerTransaction;
    }

    if ([string isEqualToString:SNRPromotionDiscountUsageTriggerRedeemString]) {
        return SNRPromotionDiscountUsageTriggerRedeem;
    }

    return SNRPromotionDiscountUsageTriggerTransaction;
}

static NSString * const SNRPromotionImageTypeImageString = @"image";
static NSString * const SNRPromotionImageTypeThumbnailString = @"thumbnail";

NSString * SNR_PromotionImageTypeToString(SNRPromotionImageType type) {
    switch (type) {
        case SNRPromotionImageTypeImage: return SNRPromotionImageTypeImageString;
        case SNRPromotionImageTypeThumbnail: return SNRPromotionImageTypeThumbnailString;

        default: return SNRPromotionImageTypeImageString;
    }
}

SNRPromotionImageType SNR_StringToPromotionImageType(NSString * _Nullable string) {
    if ([string isEqualToString:SNRPromotionImageTypeImageString]) {
        return SNRPromotionImageTypeImage;
    }

    if ([string isEqualToString:SNRPromotionImageTypeThumbnailString]) {
        return SNRPromotionImageTypeThumbnail;
    }

    return SNRPromotionImageTypeImage;
}

static NSString * const SNRVoucherCodeStatusUnassignedString = @"UNASSIGNED";
static NSString * const SNRVoucherCodeStatusAssignedString = @"ASSIGNED";
static NSString * const SNRVoucherCodeStatusRedeemedString = @"REDEEMED";
static NSString * const SNRVoucherCodeStatusCanceledString = @"CANCELED";

NSString * SNR_VoucherCodeStatusToString(SNRVoucherCodeStatus type) {
    switch (type) {
        case SNRVoucherCodeStatusUnassigned: return SNRVoucherCodeStatusUnassignedString;
        case SNRVoucherCodeStatusAssigned: return SNRVoucherCodeStatusAssignedString;
        case SNRVoucherCodeStatusRedeemed: return SNRVoucherCodeStatusRedeemedString;
        case SNRVoucherCodeStatusCanceled: return SNRVoucherCodeStatusCanceledString;

        default: return SNRVoucherCodeStatusUnassignedString;
    }
}

SNRVoucherCodeStatus SNR_StringToVoucherCodeStatus(NSString * _Nullable string) {
    if ([string isEqualToString:SNRVoucherCodeStatusUnassignedString]) {
        return SNRVoucherCodeStatusUnassigned;
    }

    if ([string isEqualToString:SNRVoucherCodeStatusAssignedString]) {
        return SNRVoucherCodeStatusAssigned;
    }

    if ([string isEqualToString:SNRVoucherCodeStatusRedeemedString]) {
        return SNRVoucherCodeStatusRedeemed;
    }

    if ([string isEqualToString:SNRVoucherCodeStatusCanceledString]) {
        return SNRVoucherCodeStatusCanceled;
    }

    return SNRVoucherCodeStatusUnassigned;
}
