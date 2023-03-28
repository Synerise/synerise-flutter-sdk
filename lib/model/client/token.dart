import '../../enums/client/token_origin.dart';
import '../../utils/synerise_utils.dart';

class Token {
  final String tokenString;
  final TokenOrigin origin;
  final DateTime expirationDate;

  Token({required this.tokenString, required this.origin, required this.expirationDate});

  Token.fromMap(Map map): this(
        tokenString: map['tokenString'],
        origin: TokenOrigin.fromString(map['origin']),
            expirationDate: SyneriseUtils.formatIntToDateTime(map['expirationDate'])
    );
}
