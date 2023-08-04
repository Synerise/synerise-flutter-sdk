/// `TokenOrigin`represents the possible origins of a token. It has several possible
/// values such as 'SYNERISE', 'FACEBOOK', 'GOOGLE', etc.
enum TokenOrigin {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  apple('APPLE'),
  simpleAuth('SIMPLE_AUTH'),
  anonymous('ANONYMOUS'),
  unknown('UNKNOWN');

  const TokenOrigin(this.tokenOrigin);

  final String tokenOrigin;

  /// The `fromString` method is a static method of the `TokenOrigin` enum. It takes a `String`
  /// parameter called `string` and returns a `TokenOrigin` value based on the input string.
  static TokenOrigin fromString(String string) {
    if (string == 'SYNERISE') {
      return TokenOrigin.synerise;
    } else if (string == 'FACEBOOK') {
      return TokenOrigin.facebook;
    } else if (string == 'GOOGLE') {
      return TokenOrigin.google;
    } else if (string == 'OAUTH') {
      return TokenOrigin.oauth;
    } else if (string == 'APPLE') {
      return TokenOrigin.apple;
    } else if (string == 'SIMPLE_AUTH') {
      return TokenOrigin.simpleAuth;
    } else if (string == 'ANONYMOUS') {
      return TokenOrigin.anonymous;
    } else {
      return TokenOrigin.unknown;
    }
  }
}
