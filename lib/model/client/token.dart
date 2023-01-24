import 'package:synerise_flutter_sdk/enums/client/token_origin.dart';

class Token {
  final String tokenString;
  final TokenOrigin? origin;
  final DateTime expirationDate;

  Token(
    this.tokenString,
    this.origin,
    this.expirationDate,
  );
}
