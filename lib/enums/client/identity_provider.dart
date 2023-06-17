/// This is defining an enumeration called `IdentityProvider` with five possible values: `synerise`,
/// `facebook`, `google`, `oauth`, and `unknown`. Each value is associated with a string representation.
enum IdentityProvider {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  unknown('UNKNOWN');

  const IdentityProvider(this.identityPrvovider);

  final String identityPrvovider;

  /// This function returns the identity provider as a string.
  String getIdentityProviderAsString() {
    return identityPrvovider;
  }

  /// This function returns an identity provider as a string based on a given input string.
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
