import '../custom_event.dart';

/// The class defines constant strings for the parameters of a product viewed event.
abstract class ProductViewedEventParameters {
  static const String productId = 'productId';
  static const String name = 'name';
  static const String category = 'category';
  static const String url = 'url';

  ProductViewedEventParameters._();
}

/// The ProductViewedEvent class represents an event where a product has been viewed, with specific
/// parameters such as the product ID and name.
class ProductViewedEvent extends CustomEvent {
  ProductViewedEvent(
    String label,
    String productId,
    String name,
    Map<String, Object>? parameters,
  ) : super(label, 'product.view', parameters) {
    this.parameters[ProductViewedEventParameters.productId] = productId;
    this.parameters[ProductViewedEventParameters.name] = name;
  }

  /// This function sets the category parameter for a ProductViewedEvent in Dart.=
  void setCategory(String category) {
    parameters[ProductViewedEventParameters.category] = category;
  }

  /// This function sets the URL parameter for a ProductViewedEvent.
  void setUrl(String url) {
    parameters[ProductViewedEventParameters.url] = url;
  }
}
