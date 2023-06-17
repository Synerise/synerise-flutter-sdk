import '../custom_event.dart';

/// ProductAddedToFavoritesEvent represents an event of adding a product to favorites with a label and
/// optional parameters.
class ProductAddedToFavoritesEvent extends CustomEvent {
  ProductAddedToFavoritesEvent(
    String label,
    Map<String, Object>? parameters,
  ) : super(label, 'product.addToFavorite', parameters);
}
