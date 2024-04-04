import '../../model/vouchers/voucher_codes_response.dart';
import '../../model/promotions/promotion.dart';
import '../../model/promotions/promotion_identifier.dart';
import '../../model/promotions/promotion_response.dart';
import '../../model/promotions/promotions_api_query.dart';
import '../../model/vouchers/assign_voucher_response.dart';
import '../base/base_module_method_channel.dart';

class PromotionsMethods extends BaseMethodChannel {
  Future<SyneriseResult<PromotionResponse>> getAllPromotions() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<PromotionResponse>('Promotions/getAllPromotions',
            isMappable: true);
  }

  Future<SyneriseResult<PromotionResponse>> getPromotions(
      PromotionsApiQuery promotionsApiQuery) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<PromotionResponse>('Promotions/getPromotions',
            parameters: promotionsApiQuery.asMap(), isMappable: true);
  }

  Future<SyneriseResult<Promotion>> getPromotionByUUID(String uuid) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<Promotion>('Promotions/getPromotionByUUID',
            parameters: uuid, isMappable: true);
  }

  Future<SyneriseResult<Promotion>> getPromotionByCode(String code) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<Promotion>('Promotions/getPromotionByCode',
            parameters: code, isMappable: true);
  }

  Future<SyneriseResult<void>> activatePromotionByUUID(String uuid) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/activatePromotionByUUID',
        parameters: uuid);
  }

  Future<SyneriseResult<void>> activatePromotionByCode(String code) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/activatePromotionByCode',
        parameters: code);
  }

  Future<SyneriseResult<void>> deactivatePromotionByUUID(String uuid) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/deactivatePromotionByUUID',
        parameters: uuid);
  }

  Future<SyneriseResult<void>> deactivatePromotionByCode(String code) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/deactivatePromotionByCode',
        parameters: code);
  }

  Future<SyneriseResult<void>> activatePromotionsBatch(
      List<PromotionIdentifier> promotionsToActivate) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/activatePromotionsBatch',
        parameters: _serializePromotionIdentifierList(promotionsToActivate));
  }

  Future<SyneriseResult<void>> deactivatePromotionsBatch(
      List<PromotionIdentifier> promotionsToDeactivate) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Promotions/deactivatePromotionsBatch',
        parameters: _serializePromotionIdentifierList(promotionsToDeactivate));
  }

  Future<SyneriseResult<AssignVoucherResponse>> getOrAssignVoucher(
      String poolUuid) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<AssignVoucherResponse>(
            'Promotions/getOrAssignVoucher',
            parameters: poolUuid,
            isMappable: true);
  }

  Future<SyneriseResult<AssignVoucherResponse>> assignVoucherCode(
      String poolUuid) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<AssignVoucherResponse>(
            'Promotions/assignVoucherCode',
            parameters: poolUuid,
            isMappable: true);
  }

  Future<SyneriseResult<VoucherCodesResponse>> getAssignedVoucherCodes() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<VoucherCodesResponse>(
            'Promotions/getAssignedVoucherCodes',
            isMappable: true);
  }
}

List<Map<dynamic, dynamic>> _serializePromotionIdentifierList(
    List<PromotionIdentifier> list) {
  List<Map<dynamic, dynamic>> formattedList = <Map<dynamic, dynamic>>[];
  for (PromotionIdentifier promotionIdentifier in list) {
    Map<dynamic, dynamic> promotionIdentifierMap = promotionIdentifier.asMap();
    formattedList.add(promotionIdentifierMap);
  }
  return formattedList;
}
