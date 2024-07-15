
class ScreenViewApiQuery {
  String feedSlug;
  String? productId;

  ScreenViewApiQuery({
    required this.feedSlug,
    this.productId
  });

  /// `Map asMap()` is a method that returns a `Map` object containing the properties of the
  /// `ScreenViewApiQuery` class as key-value pairs.
  Map asMap() => {
    'feedSlug': feedSlug,
    'productId': productId,
  };
}