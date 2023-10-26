/// An enumeration called `IdentityProvider` with six possible values: `SYNERISE`,
/// `FACEBOOK`, `GOOGLE`, `OAUTH`, `APPLE`, and `UNKNOWN`.
enum IdentityProvider {
  synerise('SYNERISE'),
  facebook('FACEBOOK'),
  google('GOOGLE'),
  oauth('OAUTH'),
  apple('APPLE'),
  unknown('UNKNOWN');

  const IdentityProvider(this.identityProvider);

  final String identityProvider;

  /// This function returns the identity provider as a string.
  String getIdentityProviderAsString() {
    return identityProvider;
  }
}
