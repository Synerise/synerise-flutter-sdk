import '../../model/tracker/unit_price.dart';
import 'cart_event.dart';

/// The class represents an event of adding a product to a cart with relevant information.
class ProductAddedToCartEvent extends CartEvent {
  ProductAddedToCartEvent(String label, String sku, UnitPrice finalPrice, int quantity, Map<String, Object>? parameters)
      : super(label, 'product.addToCart', sku, finalPrice, quantity, parameters);
}
