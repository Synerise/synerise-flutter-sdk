import '../../model/client/client_conditional_auth_result.dart';
import '../../model/promotions/promotion_response.dart';
import '../client/client_account_information.dart';
import '../client/token.dart';
import '../content/document.dart';
import '../content/recommendation_response.dart';
import '../content/screen_view.dart';
import '../promotions/promotion.dart';
import '../vouchers/assign_voucher_response.dart';
import '../vouchers/voucher_codes_response.dart';

enum GenericTypeKey {
  mapStringDynamic,
  mapStringObject,
  listMapStringDynamic,
}

class Mappings {
  static final mappings = <Type, Function>{
    //Client Module
    ClientConditionalAuthResult: (Map map) =>
        ClientConditionalAuthResult.fromMap(map),
    ClientAccountInformation: (Map map) =>
        ClientAccountInformation.fromMap(map),
    Token: (Map map) => Token.fromMap(map),

    //Content Module
    Document: (Map map) => Document.fromMap(map),
    RecommendationResponse: (Map map) => RecommendationResponse.fromMap(map),
    ScreenView: (Map map) => ScreenView.fromMap(map),

    //Promotions Module
    PromotionResponse: (Map map) => PromotionResponse.fromMap(map),
    Promotion: (Map map) => Promotion.fromMap(map),
    VoucherCodesResponse: (Map map) => VoucherCodesResponse.fromMap(map),
    AssignVoucherResponse: (Map map) => AssignVoucherResponse.fromMap(map),
  };

  static T? makeMapping<T>(Map map) {
    Function? mappingFunction = mappings[T];
    if (mappingFunction != null) {
      return mappingFunction(map);
    } else {
      return null;
    }
  }

  static dynamic makeGenericMapping(
      GenericTypeKey genericTypeKey, dynamic value) {
    switch (genericTypeKey) {
      case GenericTypeKey.mapStringDynamic:
        if (value is Map) {
          return Map<String, dynamic>.from(value);
        }
        break;
      case GenericTypeKey.mapStringObject:
        if (value is Map) {
          return Map<String, Object>.from(value);
        }
        break;
      case GenericTypeKey.listMapStringDynamic:
        if (value is List) {
          List<Map<String, Object>> list = [];
          for (var rawMap in value) {
            if (rawMap is Map) {
              Map<String, Object> map = Map<String, Object>.from(rawMap);
              list.add(map);
            }
          }
          return list;
        }
        break;
    }

    return value;
  }
}
