
import './recommendation_options.dart';

class DocumentApiQuery {
  String slug;
  String? productId;
  List<String>? itemsIds;
  List<String>? itemsExcluded;
  String? additionalFilters;
  RecommendationFiltersJoinerRule? filtersJoiner;
  String? additionalElasticFilters;
  RecommendationFiltersJoinerRule? elasticFiltersJoiner;
  List<String>? displayAttribute;
  bool? includeContextItems;

  DocumentApiQuery({
    required this.slug,
    this.productId,
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
  /// `DocumentApiQuery` class as key-value pairs.
  Map asMap() => {
    'slug': slug,
    'productId': productId,
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