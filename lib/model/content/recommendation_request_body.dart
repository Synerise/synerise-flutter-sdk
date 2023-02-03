class RecommendationRequestBody {
  final String? productId;
  final List<String>? itemsIds;
  final List<String>? itemsExcluded;
  final String? additionalFilters;
  final String? filtersJoiner;
  final String? additionalElasticFilters;
  final String? elasticFiltersJoiner;
  final List<String>? displayAttribute;
  final bool? includeContextItems;

  RecommendationRequestBody(
      {this.productId,
      this.itemsIds,
      this.itemsExcluded,
      this.additionalFilters,
      this.filtersJoiner,
      this.additionalElasticFilters,
      this.elasticFiltersJoiner,
      this.displayAttribute,
      this.includeContextItems});

  RecommendationRequestBody.fromMap(Map map)
      : this(
            productId: map['productId'],
            itemsIds: map['itemsIds'],
            itemsExcluded: map['itemsExcluded'],
            additionalFilters: map['additionalFilters'],
            filtersJoiner: map['filtersJoiner'],
            additionalElasticFilters: map['additionalElasticFilters'],
            elasticFiltersJoiner: map['elasticFiltersJoiner'],
            displayAttribute: map['displayAttribute'],
            includeContextItems: map['includeContextItems']);

  Map asMap() => {
        'productId': productId,
        'itemsIds': itemsIds,
        'itemsExcluded': itemsExcluded,
        'additionalFilters': additionalFilters,
        'filtersJoiner': filtersJoiner,
        'additionalElasticFilters': additionalElasticFilters,
        'elasticFiltersJoiner': elasticFiltersJoiner,
        'displayAttribute': displayAttribute,
        'includeContextItems': includeContextItems
      };
}
