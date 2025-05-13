
class ScreenViewApiQuery {
  String feedSlug;
  String? productId;
  Map<String, Object>? params;

  ScreenViewApiQuery({
    required this.feedSlug,
    this.productId,
    this.params
  });

  /// `Map asMap()` is a method that returns a `Map` object containing the properties of the
  /// `ScreenViewApiQuery` class as key-value pairs.
  Map asMap() => {
    'feedSlug': feedSlug,
    'productId': productId,
    'params': params
  };
}