/// This is an enumeration in Dart that defines two values: `ascending` and `descending`. Each value has
/// a corresponding `apiQuerySortingOrder` string value ('asc' for `ascending` and 'desc' for
/// `descending`).
enum ApiQuerySortingOrder {
  ascending('asc'),
  descending('desc');

  const ApiQuerySortingOrder(this.apiQuerySortingOrder);

  final String apiQuerySortingOrder;

  /// This function returns a string representing the sorting order for an API query.
  String apiQuerySortingOrderAsString() {
    return apiQuerySortingOrder;
  }
}

/// The `ApiQuerySorting` class represents a sorting query for an API with a specified property and
/// order.
class ApiQuerySorting {
  String property;
  ApiQuerySortingOrder order;

  ApiQuerySorting({
    required this.property,
    required this.order,
  });

  /// This function returns a map with the property and order values as key-value pairs.
  Map asMap() => {'property': property, 'order': order.apiQuerySortingOrderAsString()};
}

/// The class represents a base API query with properties for limit, page, sorting, and includeMeta.
class BaseApiQuery {
  int limit = 100;
  int page = 1;

  List<ApiQuerySorting> sorting = [];

  bool includeMeta = false;

  BaseApiQuery({required this.limit, required this.page, required this.sorting, required this.includeMeta});
}
