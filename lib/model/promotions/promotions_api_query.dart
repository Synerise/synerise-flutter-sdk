import '../../model/base_api_query.dart';
import '../../enums/promotions/promotion_status.dart';
import '../../enums/promotions/promotion_type.dart';

/// The `PromotionsApiQuery` class is a subclass of `BaseApiQuery` that allows for filtering promotions
/// by status and type.
class PromotionsApiQuery extends BaseApiQuery {
  List<PromotionStatus> statuses = [];
  List<PromotionType> types = [];

  PromotionsApiQuery(
      {required this.statuses,
      required this.types,
      required super.sorting,
      required super.limit,
      required super.page,
      required super.includeMeta});

  /// This is a named constructor in the `PromotionsApiQuery` class that allows creating an instance of
  /// the class from a `Map` object.
  PromotionsApiQuery.fromMap(Map map)
      : this(
            statuses: map['statuses'],
            types: map['types'],
            sorting: map['sorting'],
            limit: map['limit'],
            page: map['page'],
            includeMeta: map['includeMeta']);

  /// The function returns a map containing serialized lists of statuses, types, and sorting, as well as
  /// limit, page, and includeMeta values.
  Map asMap() => {
        'statuses': _serializeStatusesList(statuses),
        'types': _serializeTypesList(types),
        'sorting': _serializeSortingList(sorting),
        'limit': limit,
        'page': page,
        'includeMeta': includeMeta,
      };
}

/// This function serializes a list of PromotionStatus objects into a list of their corresponding string
/// representations.
List<String> _serializeStatusesList(List<PromotionStatus> list) {
  List<String> formattedList = <String>[];
  for (PromotionStatus promotionStatus in list) {
    String promotionStatusString = promotionStatus.promotionStatusAsString();
    formattedList.add(promotionStatusString);
  }
  return formattedList;
}

/// This function serializes a list of PromotionType objects into a list of their corresponding string
/// representations.
List<String> _serializeTypesList(List<PromotionType> list) {
  List<String> formattedList = <String>[];
  for (PromotionType promotionType in list) {
    String promotionTypeString = promotionType.promotionTypeAsString();
    formattedList.add(promotionTypeString);
  }
  return formattedList;
}

/// This function serializes a list of ApiQuerySorting objects into a list of maps.
List<Map<dynamic, dynamic>> _serializeSortingList(List<ApiQuerySorting> list) {
  List<Map<dynamic, dynamic>> formattedList = <Map<dynamic, dynamic>>[];
  for (ApiQuerySorting apiQuerySorting in list) {
    Map<dynamic, dynamic> apiQuerySortingMap = apiQuerySorting.asMap();
    formattedList.add(apiQuerySortingMap);
  }
  return formattedList;
}
