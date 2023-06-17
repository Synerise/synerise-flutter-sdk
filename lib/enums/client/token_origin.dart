/// This is defining an enumeration type called `TokenOrigin` with five possible values: `synerise`,
/// `facebook`, `google`, `oauth`, and `unknown`. Each value is associated with a string representation
/// (`'SYNERISE'`, `'FACEBOOK'`, `'GOOGLE'`, `'OAUTH'`, and `'UNKNOWN'`, respectively).
enum TokenOrigin {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  unknown('UNKNOWN');

  const TokenOrigin(this.tokenOrigin);

  final String tokenOrigin;

  /// This is a factory method that returns a TokenOrigin object based on a given string value.
  factory TokenOrigin.fromString(String string) {
    return values.byName(string.toLowerCase());
  }
}
