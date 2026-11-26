//
//  FPromotions+Functions.h
//  flutter-synerise-sdk
//
//  Created by Synerise
//  Copyright © 2023 Synerise. All rights reserved.
//

#import <Flutter/Flutter.h>
#import <SyneriseSDK/SyneriseSDK.h>

NSString * SNR_PromotionStatusToString(SNRPromotionStatus type);
SNRPromotionStatus SNR_StringToPromotionStatus(NSString * _Nullable string);

NSString * SNR_PromotionTypeToString(SNRPromotionType type);
SNRPromotionType SNR_StringToPromotionType(NSString * _Nullable string);

NSString * SNR_PromotionDiscountTypeToString(SNRPromotionDiscountType type);
SNRPromotionDiscountType SNR_StringToPromotionDiscountType(NSString * _Nullable string);

NSString * SNR_PromotionDiscountModeToString(SNRPromotionDiscountMode mode);
SNRPromotionDiscountMode SNR_StringToPromotionDiscountMode(NSString * _Nullable string);

NSString * SNR_PromotionItemScopeToString(SNRPromotionItemScope scope);
SNRPromotionItemScope SNR_StringToPromotionItemScope(NSString * _Nullable string);

NSString * SNR_PromotionDiscountUsageTriggerToString(SNRPromotionDiscountUsageTrigger trigger);
SNRPromotionDiscountUsageTrigger SNR_StringToPromotionDiscountUsageTrigger(NSString * _Nullable string);

NSString * SNR_PromotionImageTypeToString(SNRPromotionImageType type);
SNRPromotionImageType SNR_StringToPromotionImageType(NSString * _Nullable string);

NSString * SNR_VoucherCodeStatusToString(SNRVoucherCodeStatus type);
SNRVoucherCodeStatus SNR_StringToVoucherCodeStatus(NSString * _Nullable string);
