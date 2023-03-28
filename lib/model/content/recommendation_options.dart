class RecommendationOptions {
  String slug;
  String? productID;

  RecommendationOptions({
    required this.slug,
    this.productID,
  });

  RecommendationOptions.fromMap(Map map)
      : this(
          slug: map['slug'],
          productID: map['productID'],
        );

  Map asMap() => {
        'slug': slug,
        'productID': productID,
      };
}
