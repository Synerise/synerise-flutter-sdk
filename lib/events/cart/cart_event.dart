import '../../model/tracker/unit_price.dart';
import '../custom_event.dart';

/// The class defines constant strings for various parameters used in a cart event.
abstract class CartEventParameters {
  static const String sku = 'sku';
  static const String name = 'name';
  static const String category = 'category';
  static const String categories = 'categories';
  static const String offline = 'offline';
  static const String regularUnitPrice = 'regularUnitPrice';
  static const String finalUnitPrice = 'finalUnitPrice';
  static const String discountedUnitPrice = 'discountedUnitPrice';
  static const String url = 'url';
  static const String producer = 'producer';
  static const String quantity = 'quantity';

  CartEventParameters._();
}

/// The abstract class CartEvent defines a custom event with parameters for a shopping cart action.
abstract class CartEvent extends CustomEvent {
  CartEvent(String label, String action, String sku, UnitPrice finalPrice, int quantity, Map<String, Object>? parameters)
      : super(label, action, parameters) {
    this.parameters[CartEventParameters.sku] = sku;
    this.parameters[CartEventParameters.quantity] = quantity;
    this.parameters[CartEventParameters.finalUnitPrice] = finalPrice.asMap();
  }

  /// This function sets the name parameter in a cart object.
  void setName(String name) {
    parameters[CartEventParameters.name] = name;
  }

  /// This function sets the category parameter for a cart event.
  void setCategory(String category) {
    parameters[CartEventParameters.category] = category;
  }

  /// This function sets the categories parameter in a cart event.
  void setCategories(List<String> categories) {
    parameters[CartEventParameters.categories] = categories;
  }

  /// The function sets the offline parameter in the CartEventParameters map to a boolean value.
  void setOffline(bool offline) {
    parameters[CartEventParameters.offline] = offline;
  }

  /// This function sets the regular unit price for a cart event.
  void setRegularPrice(UnitPrice regularPrice) {
    parameters[CartEventParameters.regularUnitPrice] = regularPrice.asMap();
  }

  /// This function sets the discounted unit price for a cart event.
  void setDiscountedPrice(UnitPrice discountedPrice) {
    parameters[CartEventParameters.discountedUnitPrice] = discountedPrice.asMap();
  }

  /// This function sets a URL parameter in a cart event.
  void setUrl(String url) {
    parameters[CartEventParameters.url] = url;
  }

  /// This function sets the producer parameter in a cart event.
  void setProducer(String producer) {
    parameters[CartEventParameters.producer] = producer;
  }
}
