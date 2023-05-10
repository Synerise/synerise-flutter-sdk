import 'package:synerise_flutter_sdk/model/promotions/promotion_image.dart';

import '../../enums/promotions/promotion_discount_mode.dart';
import '../../enums/promotions/promotion_discount_type.dart';
import '../../enums/promotions/promotion_item_scope.dart';
import '../../enums/promotions/promotion_status.dart';
import '../../enums/promotions/promotion_type.dart';
import '../../utils/synerise_utils.dart';
import 'promotion_details.dart';
import 'promotion_discount_mode_details.dart';

class Promotion {
  String uuid;
  String code;
  PromotionStatus status;
  PromotionType type;
  PromotionDetails? details;

  int? redeemLimitPerClient;
  int? redeemQuantityPerActivation;
  int currentRedeemedQuantity;
  int? currentRedeemLimit;
  int activationCounter;
  int possibleRedeems;
  PromotionDiscountType discountType;
  int discountValue;
  PromotionDiscountMode discountMode;
  PromotionDiscountModeDetails? discountModeDetails;
  int requireRedeemedPoints;

  int price;
  int priority;
  PromotionItemScope itemScope;
  int? minBasketValue;
  int? maxBasketValue;

  String? name;
  String? headline;
  String? descriptionText;
  List<PromotionImage>? images;

  DateTime? assignedAt;
  DateTime? startAt;
  DateTime? expireAt;
  DateTime? lastingAt;
  int? lastingTime;
  String? displayFrom;
  String? displayTo;
  
  Map<String, Object>? params;
  List<String>? catalogIndexItems;
  List<Object>? tags;

  Promotion._({
    required this.uuid,
    required this.code,
    required this.status,
    required this.type,
    this.details,
    this.redeemLimitPerClient,
    this.redeemQuantityPerActivation,
    required this.currentRedeemedQuantity,
    this.currentRedeemLimit,
    required this.activationCounter,
    required this.possibleRedeems,
    required this.discountType,
    required this.discountValue,
    required this.discountMode,
    this.discountModeDetails,
    required this.requireRedeemedPoints,
    required this.price,
    required this.priority,
    required this.itemScope,
    this.minBasketValue,
    this.maxBasketValue,
    this.name,
    this.headline,
    this.descriptionText,
    this.images,
    this.assignedAt,
    this.startAt,
    this.expireAt,
    this.lastingAt,
    this.lastingTime,
    this.displayFrom,
    this.displayTo,
    this.params,
    this.catalogIndexItems,
    this.tags,
  });

  Promotion.fromMap(Map map)
      : this._(
            uuid: map['uuid'],
            code: map['code'],
            status: PromotionStatus.getPromotionStatusFromString(map['status']),
            type: PromotionType.getPromotionTypeFromString(map['type']),
            details: map['details'] != null ? PromotionDetails.fromMap(map['details']) : null,
            redeemLimitPerClient: map['redeemLimitPerClient'],
            redeemQuantityPerActivation: map['redeemQuantityPerActivation'],
            currentRedeemedQuantity: map['currentRedeemedQuantity'],
            currentRedeemLimit: map['currentRedeemLimit'],
            activationCounter: map['activationCounter'],
            possibleRedeems: map['possibleRedeems'],
            discountType: PromotionDiscountType.getPromotionDiscountTypeFromString(map['discountType']),
            discountValue: map['discountValue'],
            discountMode: PromotionDiscountMode.getPromotionDiscountModeFromString(map['discountMode']),
            discountModeDetails:
                map['discountModeDetails'] != null ? PromotionDiscountModeDetails.fromMap(map['discountModeDetails']) : null,
            requireRedeemedPoints: map['requireRedeemedPoints'],
            price: map['price'],
            priority: map['priority'],
            itemScope: PromotionItemScope.getPromotionItemScopeFromString(map['itemScope']),
            minBasketValue: map['minBasketValue'],
            maxBasketValue: map['maxBasketValue'],
            name: map['name'],
            headline: map['headline'],
            descriptionText: map['descriptionText'],
            images: map['images'] != null ? _convertObjectListToPromotionImageList(map['images']) : null,
            assignedAt: map['assignedAt'] != null ? SyneriseUtils.formatIntToDateTime(map['assignedAt']) : null,
            startAt: map['startAt'] != null ? SyneriseUtils.formatIntToDateTime(map['startAt']) : null,
            expireAt: map['expireAt'] != null ? SyneriseUtils.formatIntToDateTime(map['expireAt']) : null,
            lastingAt: map['lastingAt'] != null ? SyneriseUtils.formatIntToDateTime(map['lastingAt']) : null,
            lastingTime: map['lastingTime'],
            displayFrom: map['displayFrom'],
            displayTo: map['displayTo'],
            params: map['params'] != null ? Map<String, Object>.from(map['params']) : null,
            catalogIndexItems: map['catalogIndexItems'] != null ? List<String>.from(map['catalogIndexItems']) : null,
            tags: map['tags'] != null ? List<Object>.from(map['tags']) : null);
}

List<PromotionImage> _convertObjectListToPromotionImageList(List<Object?> list) {
  List<PromotionImage> promotionImageList = [];
  for (var promotionImageMap in list) {
    promotionImageMap as Map<Object?, Object?>;
    PromotionImage promotionImage = PromotionImage.fromMap(promotionImageMap);
    promotionImageList.add(promotionImage);
  }
  return promotionImageList;
}
