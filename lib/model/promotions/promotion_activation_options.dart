import 'package:synerise_flutter_sdk/model/promotions/promotion_identifier.dart';

/// The `PromotionActivationOptions`
class PromotionActivationOptions{
  PromotionIdentifier identifier;
  int? pointsToUse;


  PromotionActivationOptions(
      {required this.identifier,
        this.pointsToUse
        });

  /// The function returns a map containing serialized lists of statuses, types, and sorting, as well as
  /// limit, page, and includeMeta values.
  Map asMap() => {
    'identifier': identifier.asMap(),
    'pointsToUse': pointsToUse,
  };
}

