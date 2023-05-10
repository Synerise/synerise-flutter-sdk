import 'package:synerise_flutter_sdk/model/base_api_query.dart';

import '../../enums/promotions/promotion_status.dart';
import '../../enums/promotions/promotion_type.dart';

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

  PromotionsApiQuery.fromMap(Map map)
      : this(
            statuses: map['statuses'],
            types: map['types'],
            sorting: map['sorting'],
            limit: map['limit'],
            page: map['page'],
            includeMeta: map['includeMeta']);

  Map asMap() => {
        'statuses': _serializeStatusesList(statuses),
        'types': _serializeTypesList(types),
        'sorting': _serializeSortingList(sorting),
        'limit': limit,
        'page': page,
        'includeMeta': includeMeta,
      };
}

List<String> _serializeStatusesList(List<PromotionStatus> list) {
  List<String> formattedList = <String>[];
  for (PromotionStatus promotionStatus in list) {
    String promotionStatusString = promotionStatus.promotionStatusAsString();
    formattedList.add(promotionStatusString);
  }
  return formattedList;
}

List<String> _serializeTypesList(List<PromotionType> list) {
  List<String> formattedList = <String>[];
  for (PromotionType promotionType in list) {
    String promotionTypeString = promotionType.promotionTypeAsString();
    formattedList.add(promotionTypeString);
  }
  return formattedList;
}

List<Map<dynamic, dynamic>> _serializeSortingList(List<ApiQuerySorting> list) {
  List<Map<dynamic, dynamic>> formattedList = <Map<dynamic, dynamic>>[];
  for (ApiQuerySorting apiQuerySorting in list) {
    Map<dynamic, dynamic> apiQuerySortingMap = apiQuerySorting.asMap();
    formattedList.add(apiQuerySortingMap);
  }
  return formattedList;
}
