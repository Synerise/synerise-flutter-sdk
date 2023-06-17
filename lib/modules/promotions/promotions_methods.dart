import '../../model/vouchers/voucher_codes_response.dart';
import '../../model/promotions/promotion.dart';
import '../../model/promotions/promotion_identifier.dart';
import '../../model/promotions/promotion_response.dart';
import '../../model/promotions/promotions_api_query.dart';
import '../../model/vouchers/assign_voucher_response.dart';
import '../base/base_module_method_channel.dart';

class PromotionsMethods extends BaseMethodChannel {
  Future<PromotionResponse> getAllPromotions() async {
    var promotionResponse = await methodChannel.invokeMethod("Promotions/getAllPromotions");
    PromotionResponse promotionResponseMap = PromotionResponse.fromMap(promotionResponse);
    return promotionResponseMap;
  }

  Future<PromotionResponse> getPromotions(PromotionsApiQuery promotionsApiQuery) async {
    var promotionResponse = await methodChannel.invokeMethod("Promotions/getPromotions", promotionsApiQuery.asMap());
    PromotionResponse promotionResponseMap = PromotionResponse.fromMap(promotionResponse);
    return promotionResponseMap;
  }

  Future<Promotion> getPromotionByUUID(String uuid) async {
    var promotion = await methodChannel.invokeMethod("Promotions/getPromotionByUUID", uuid);
    Promotion promotionMap = Promotion.fromMap(promotion);
    return promotionMap;
  }

  Future<Promotion> getPromotionByCode(String code) async {
    var promotion = await methodChannel.invokeMethod("Promotions/getPromotionByCode", code);
    Promotion promotionMap = Promotion.fromMap(promotion);
    return promotionMap;
  }

  Future<void> activatePromotionByUUID(String uuid) async {
    await methodChannel.invokeMethod("Promotions/activatePromotionByUUID", uuid);
  }

  Future<void> activatePromotionByCode(String code) async {
    await methodChannel.invokeMethod("Promotions/activatePromotionByCode", code);
  }

  Future<void> deactivatePromotionByUUID(String uuid) async {
    await methodChannel.invokeMethod("Promotions/deactivatePromotionByUUID", uuid);
  }

  Future<void> deactivatePromotionByCode(String code) async {
    await methodChannel.invokeMethod("Promotions/deactivatePromotionByCode", code);
  }

  Future<void> activatePromotionsBatch(List<PromotionIdentifier> promotionsToActivate) async {
    await methodChannel.invokeMethod("Promotions/activatePromotionsBatch", _serializePromotionIdentifierList(promotionsToActivate));
  }

  Future<void> deactivatePromotionsBatch(List<PromotionIdentifier> promotionsToDeactivate) async {
    await methodChannel.invokeMethod("Promotions/deactivatePromotionsBatch", _serializePromotionIdentifierList(promotionsToDeactivate));
  }

  Future<AssignVoucherResponse> getOrAssignVoucher(String poolUuid) async {
    var assignVoucherResponse = await methodChannel.invokeMethod("Promotions/getOrAssignVoucher", poolUuid);
    AssignVoucherResponse assignVoucherResponseMap = AssignVoucherResponse.fromMap(assignVoucherResponse);
    return assignVoucherResponseMap;
  }

  Future<AssignVoucherResponse> assignVoucherCode(String poolUuid) async {
    var assignVoucherResponse = await methodChannel.invokeMethod("Promotions/assignVoucherCode", poolUuid);
    AssignVoucherResponse assignVoucherResponseMap = AssignVoucherResponse.fromMap(assignVoucherResponse);
    return assignVoucherResponseMap;
  }

  Future<VoucherCodesResponse> getAssignedVoucherCodes() async {
    var voucherCodesResponse = await methodChannel.invokeMethod("Promotions/getAssignedVoucherCodes");
    VoucherCodesResponse voucherCodesResponseMap = VoucherCodesResponse.fromMap(voucherCodesResponse);
    return voucherCodesResponseMap;
  }
}

List<Map<dynamic, dynamic>> _serializePromotionIdentifierList(List<PromotionIdentifier> list) {
  List<Map<dynamic, dynamic>> formattedList = <Map<dynamic, dynamic>>[];
  for (PromotionIdentifier promotionIdentifier in list) {
    Map<dynamic, dynamic> promotionIdentifierMap = promotionIdentifier.asMap();
    formattedList.add(promotionIdentifierMap);
  }
  return formattedList;
}
