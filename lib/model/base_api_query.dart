enum ApiQuerySortingOrder {
  ascending('asc'),
  descending('desc');

  const ApiQuerySortingOrder(this.apiQuerySortingOrder);

  final String apiQuerySortingOrder;

  String apiQuerySortingOrderAsString() {
    return apiQuerySortingOrder;
  }
}

class ApiQuerySorting {
  String property;
  ApiQuerySortingOrder order;

  ApiQuerySorting({
    required this.property,
    required this.order,
  });

  Map asMap() => {
        'property': property,
        'order': order.apiQuerySortingOrderAsString()
      };
}

class BaseApiQuery {
  int limit = 100;
  int page = 1;

  List<ApiQuerySorting> sorting = [];

  bool includeMeta = false;

  BaseApiQuery({required this.limit, required this.page, required this.sorting, required this.includeMeta});
}
