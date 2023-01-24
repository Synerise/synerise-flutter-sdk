enum TokenOrigin {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  unknown('UNKNOWN');

  const TokenOrigin(this.tokenOrigin);

  final String tokenOrigin;

  factory TokenOrigin.fromString(String string) {
    return values.byName(string.toLowerCase());
  }
}
