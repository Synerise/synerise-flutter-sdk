import '../../model/tracker/unit_price.dart';
import 'cart_event.dart';

/// The ProductRemovedFromCartEvent class represents an event where a
/// product is removed from the cart.
class ProductRemovedFromCartEvent extends CartEvent {
  ProductRemovedFromCartEvent(String label, String sku, UnitPrice finalPrice, int quantity, Map<String, Object>? parameters)
      : super(label, 'product.removeFromCart', sku, finalPrice, quantity, parameters);
}
