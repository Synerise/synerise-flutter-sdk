import '../../model/promotions/promotion.dart';
import '../../model/promotions/promotion_identifier.dart';
import '../../model/promotions/promotion_response.dart';
import '../../model/promotions/promotions_api_query.dart';
import '../../model/vouchers/assign_voucher_response.dart';
import '../../model/vouchers/voucher_codes_response.dart';
import '../base/base_module.dart';
import 'promotions_methods.dart';

class PromotionsImpl extends BaseModule {
  final PromotionsMethods _methods = PromotionsMethods();
  PromotionsImpl();

  Future<PromotionResponse> getAllPromotions() async {
    return _methods.getAllPromotions();
  }

  Future<PromotionResponse> getPromotions(PromotionsApiQuery promotionsApiQuery) async {
    return _methods.getPromotions(promotionsApiQuery);
  }

  Future<Promotion> getPromotionByUUID(String uuid) async {
    return _methods.getPromotionByUUID(uuid);
  }

  Future<Promotion> getPromotionByCode(String code) async {
    return _methods.getPromotionByCode(code);
  }

  Future<void> activatePromotionByUUID(String uuid) async {
    return _methods.activatePromotionByUUID(uuid);
  }

  Future<void> activatePromotionByCode(String code) async {
    return _methods.activatePromotionByCode(code);
  }

  Future<void> deactivatePromotionByUUID(String uuid) async {
    return _methods.deactivatePromotionByUUID(uuid);
  }

  Future<void> deactivatePromotionByCode(String code) async {
    return _methods.deactivatePromotionByCode(code);
  }

  Future<void> activatePromotionsBatch(List<PromotionIdentifier> promotionsToActivate) async {
    return _methods.activatePromotionsBatch(promotionsToActivate);
  }

  Future<void> deactivatePromotionsBatch(List<PromotionIdentifier> promotionsToDeactivate) async {
    return _methods.deactivatePromotionsBatch(promotionsToDeactivate);
  }

  Future<AssignVoucherResponse> getOrAssignVoucher(String poolUuid) async {
    return _methods.getOrAssignVoucher(poolUuid);
  }

  Future<AssignVoucherResponse> assignVoucherCode(String poolUuid) async {
    return _methods.assignVoucherCode(poolUuid);
  }

  Future<VoucherCodesResponse> getAssignedVoucherCodes() async {
    return _methods.getAssignedVoucherCodes();
  }
}
