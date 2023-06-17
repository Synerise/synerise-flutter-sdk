import 'promotion.dart';

/// The code defines a Dart class for a promotion response and includes a private constructor and a
/// function to convert a list of objects to a list of promotions.
class PromotionResponse {
  final int? totalCount;
  final int? totalPages;
  final int? page;
  final int? limit;
  final int? code;
  final List<Promotion> items;

  PromotionResponse._({this.totalCount, this.totalPages, this.page, this.limit, this.code, required this.items});

  /// `PromotionResponse.fromMap(Map map)` is a factory constructor that takes in a `Map` object and
  /// returns a new instance of the `PromotionResponse` class.
  PromotionResponse.fromMap(Map map)
      : this._(
            totalCount: map['totalCount'],
            totalPages: map['totalPages'],
            page: map['page'],
            limit: map['limit'],
            code: map['code'],
            items: _convertObjectListToPromotion(map['items']));
}

/// This function converts a list of objects to a list of Promotion objects.
List<Promotion> _convertObjectListToPromotion(List<Object?> list) {
  List<Promotion> promotionList = [];
  for (var promotionMap in list) {
    promotionMap as Map<Object?, Object?>;
    Promotion promotion = Promotion.fromMap(promotionMap);
    promotionList.add(promotion);
  }
  return promotionList;
}
