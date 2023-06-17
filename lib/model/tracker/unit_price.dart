/// The `UnitPrice` class represents a unit price with an amount and currency, and has a method to
/// convert it to a map.
class UnitPrice {
  int amount;
  String currency;

  UnitPrice(this.amount, this.currency);

  Map asMap() => {'amount': amount, 'currency': currency};
}
