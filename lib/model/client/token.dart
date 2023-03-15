import 'package:synerise_flutter_sdk/enums/client/token_origin.dart';

class Token {
  final String tokenString;
  final TokenOrigin origin;
  final DateTime expirationDate;

  Token({required this.tokenString, required this.origin, required this.expirationDate});

  Token.fromMap(Map map): this(
        tokenString: map['tokenString'],
        origin: TokenOrigin.fromString(map['origin']),
        expirationDate: DateTime.fromMillisecondsSinceEpoch(map['expirationDate'], isUtc: true)
    );
}
