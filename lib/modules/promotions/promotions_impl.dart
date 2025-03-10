import '../base/base_module_method_channel.dart';
import '../base/base_module.dart';
import '../../model/promotions/promotion.dart';
import '../../model/promotions/promotion_identifier.dart';
import '../../model/promotions/promotion_response.dart';
import '../../model/promotions/promotions_api_query.dart';
import '../../model/vouchers/assign_voucher_response.dart';
import '../../model/vouchers/voucher_codes_response.dart';
import './promotions_methods.dart';

class PromotionsImpl extends BaseModule {
  final PromotionsMethods _methods = PromotionsMethods();
  PromotionsImpl();

  /// This method retrieves all available promotions that are defined for a customer.
  Future<void> getAllPromotions(
      {required void Function(PromotionResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<PromotionResponse> result =
        await _methods.getAllPromotions();

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This method retrieves promotions that match the parameters defined in an API query.
  ///
  /// Args:
  ///   promotionsApiQuery (PromotionsApiQuery): It is an object of type PromotionsApiQuery which
  /// contains the query parameters for the promotions API.
  Future<void> getPromotions(PromotionsApiQuery promotionsApiQuery,
      {required void Function(PromotionResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<PromotionResponse> result =
        await _methods.getPromotions(promotionsApiQuery);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function retrieves a Promotion object by its UUID.
  ///
  /// Args:
  ///   uuid (String): The "uuid" parameter is a string that represents a unique identifier for a
  /// promotion.
  Future<void> getPromotionByUUID(String uuid,
      {required void Function(Promotion) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Promotion> result = await _methods.getPromotionByUUID(uuid);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function returns a promotion object by its code.
  ///
  /// Args:
  ///   code (String): The parameter "code" is a string that represents the code of a promotion.
  Future<void> getPromotionByCode(String code,
      {required void Function(Promotion) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Promotion> result = await _methods.getPromotionByCode(code);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function activates a promotion by its UUID.
  ///
  /// Args:
  ///   uuid (String): The "uuid" parameter is a String that represents a unique identifier for a
  /// promotion.
  Future<void> activatePromotionByUUID(String uuid,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.activatePromotionByUUID(uuid);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function activates a promotion by a given code.
  ///
  /// Args:
  ///   code (String): The parameter "code" is a String that represents the promotion code that needs to
  /// be activated.
  Future<void> activatePromotionByCode(String code,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.activatePromotionByCode(code);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function deactivates a promotion by its UUID.
  ///
  /// Args:
  ///   uuid (String): The "uuid" parameter is a String that represents the unique identifier of a
  /// promotion that needs to be deactivated.
  Future<void> deactivatePromotionByUUID(String uuid,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.deactivatePromotionByUUID(uuid);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function deactivates a promotion by its code.
  ///
  /// Args:
  ///   code (String): The "code" parameter is a string that represents the code of the promotion that
  /// needs to be deactivated.
  Future<void> deactivatePromotionByCode(String code,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.deactivatePromotionByCode(code);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This method activates promotions with a code or with UUID in a batch.
  ///
  /// Args:
  ///   promotionsToActivate (List<PromotionIdentifier>): A list of PromotionIdentifier object
  /// representing the promotions that need to be activated.
  Future<void> activatePromotionsBatch(
      List<PromotionIdentifier> promotionsToActivate,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.activatePromotionsBatch(promotionsToActivate);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This method deactivates promotions with a code or with UUID in a batch.
  ///
  /// Args:
  ///   promotionsToDeactivate (List<PromotionIdentifier>): promotionsToDeactivate is a List of
  /// PromotionIdentifier objects that contains the promotions that need to be deactivated. The method
  /// deactivatePromotionsBatch() takes this list as a parameter and deactivates all the promotions in
  /// the list.
  Future<void> deactivatePromotionsBatch(
      List<PromotionIdentifier> promotionsToDeactivate,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.deactivatePromotionsBatch(promotionsToDeactivate);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This method retrieves an assigned voucher code or assigns a voucher from a pool identified
  /// by UUID to the customer.
  ///
  /// Once a voucher is assigned using this method, the same voucher is returned for the customer
  /// every time the method is called.
  ///
  /// Args:
  ///   poolUuid (String): The `poolUuid` parameter is a unique identifier for a voucher pool. It is
  /// used to retrieve or assign a voucher from/to the specified pool.
  Future<void> getOrAssignVoucher(String poolUuid,
      {required void Function(AssignVoucherResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<AssignVoucherResponse> result =
        await _methods.getOrAssignVoucher(poolUuid);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This method assigns a voucher from a pool identified by UUID to the customer. Every request
  /// returns a different code until the pool is empty.
  ///
  /// Args:
  ///   poolUuid (String): The parameter `poolUuid` is a unique identifier for a voucher pool. It is
  /// used to assign a voucher code from the specified pool to a user.
  Future<void> assignVoucherCode(String poolUuid,
      {required void Function(AssignVoucherResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<AssignVoucherResponse> result =
        await _methods.assignVoucherCode(poolUuid);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This method retrieves voucher codes for a customer.
  Future<void> getAssignedVoucherCodes(
      {required void Function(VoucherCodesResponse) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<VoucherCodesResponse> result =
        await _methods.getAssignedVoucherCodes();

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }
}
