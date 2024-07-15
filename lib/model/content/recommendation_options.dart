/// The `enum RecommendationFiltersJoinerRule` is defining a set of possible values for a recommendation
/// filter joiner rule. It has three possible values: `and`, `or`, and `replace`.
enum RecommendationFiltersJoinerRule {
  and('and'),
  or('or'),
  replace('replace');

  const RecommendationFiltersJoinerRule(this.recommendationFiltersJoinerRule);

  final String recommendationFiltersJoinerRule;

  static RecommendationFiltersJoinerRule?
      getRecommendationFiltersJoinerRuleFromString(String string) {
    if (string == 'and') {
      return RecommendationFiltersJoinerRule.and;
    } else if (string == 'or') {
      return RecommendationFiltersJoinerRule.or;
    } else if (string == 'replace') {
      return RecommendationFiltersJoinerRule.replace;
    } else {
      return null;
    }
  }

  String recommendationFiltersJoinerRuleAsString() {
    return recommendationFiltersJoinerRule;
  }
}

/// The class "RecommendationOptions" contains various properties for configuring recommendations, such
/// as product IDs, filters, and display attributes.
class RecommendationOptions {
  String slug;
  String? productID;
  List<String>? itemsIds;
  List<String>? itemsExcluded;
  String? additionalFilters;
  RecommendationFiltersJoinerRule? filtersJoiner;
  String? additionalElasticFilters;
  RecommendationFiltersJoinerRule? elasticFiltersJoiner;
  List<String>? displayAttribute;
  bool? includeContextItems;

  RecommendationOptions({
    required this.slug,
    this.productID,
    this.itemsIds,
    this.itemsExcluded,
    this.additionalFilters,
    this.filtersJoiner,
    this.additionalElasticFilters,
    this.elasticFiltersJoiner,
    this.displayAttribute,
    this.includeContextItems = false,
  });

  /// `Map asMap()` is a method that returns a `Map` object containing the properties of the
  /// `RecommendationOptions` class as key-value pairs.
  Map asMap() => {
        'slug': slug,
        'productID': productID,
        'itemsIds': itemsIds,
        'itemsExcluded': itemsExcluded,
        'additionalFilters': additionalFilters,
        'filtersJoiner':
            filtersJoiner?.recommendationFiltersJoinerRuleAsString(),
        'additionalElasticFilters': additionalElasticFilters,
        'elasticFiltersJoiner':
            elasticFiltersJoiner?.recommendationFiltersJoinerRuleAsString(),
        'displayAttribute': displayAttribute,
        'includeContextItems': includeContextItems,
      };
}
