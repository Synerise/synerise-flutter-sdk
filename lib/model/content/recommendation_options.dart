class RecommendationOptions {
  String slug;
  String? productId;

  RecommendationOptions({
    required this.slug,
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
