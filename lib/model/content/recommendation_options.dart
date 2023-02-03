class RecommendationOptions {
  final String? slug;
  final String? productId;

  RecommendationOptions({
    this.slug,
    this.productId,
  });

  RecommendationOptions.fromMap(Map map)
      : this(
          slug: map['slug'],
          productId: map['productId'],
        );

  Map asMap() => {
        'slug': slug,
        'productId': productId,
      };
}
