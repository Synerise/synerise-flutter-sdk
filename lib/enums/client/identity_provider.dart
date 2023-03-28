enum IdentityProvider {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  unknown('UNKNOWN');

  const IdentityProvider(this.identityPrvovider);

  final String identityPrvovider;

  String getIdentityProviderAsString() {
    return identityPrvovider;
  }

  static String getIdentityProviderFromString(String string) {
    if (string == synerise.identityPrvovider) {
      return synerise.identityPrvovider;
    } else if (string == facebook.identityPrvovider) {
      return facebook.identityPrvovider;
    } else if (string == google.identityPrvovider) {
      return google.identityPrvovider;
    } else if (string == oauth.identityPrvovider) {
      return oauth.identityPrvovider;
    } else {
      return unknown.identityPrvovider;
    }
  }
}
