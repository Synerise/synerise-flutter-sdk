import '../../enums/client/token_origin.dart';
import '../../utils/synerise_utils.dart';

/// The Token class represents a token with a string value, origin information, and an expiration date.
class Token {
  final String tokenString;
  final TokenOrigin origin;
  final DateTime expirationDate;

  Token(
      {required this.tokenString,
      required this.origin,
      required this.expirationDate});

  /// `Token.fromMap(Map map)` is a named constructor that creates a new instance of the `Token` class
  /// from a `Map` object. It takes a `Map` object as an argument and uses its values to initialize the
  /// properties of the `Token` object.
  Token.fromMap(Map map)
      : this(
            tokenString: map['tokenString'],
            origin: TokenOrigin.fromString(map['origin']),
            expirationDate:
                SyneriseUtils.formatIntToDateTime(map['expirationDate']));
}
