/// `ClientSignOutMode` represents the mode that is used to sign out a client, and has two values:
/// `signOut` and `signOutWithSessionDestroy`.
enum ClientSignOutMode {
  signOut('SIGN_OUT'),
  signOutWithSessionDestroy('SIGN_OUT_WITH_SESSION_DESTROY');

  const ClientSignOutMode(this.clientSignOutMode);

  final String clientSignOutMode;

  /// The function `getClientSignOutModeFromString` converts a string representation of a sign out mode
  /// into the corresponding enum value.
  ///
  /// Args:
  ///   string (String): The parameter "string" is a string value that represents a client sign out
  /// mode.
  ///
  /// Returns:
  ///   The method is returning a value of type `ClientSignOutMode?`.
  static ClientSignOutMode? getClientSignOutModeFromString(String string) {
    if (string == 'SIGN_OUT') {
      return ClientSignOutMode.signOut;
    } else if (string == 'SIGN_OUT_WITH_SESSION_DESTROY') {
      return ClientSignOutMode.signOutWithSessionDestroy;
    } else {
      return null;
    }
  }

  /// The function returns the client sign out mode as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable "clientSignOutMode" as a string.
  String clientSignOutModeAsString() {
    return clientSignOutMode;
  }
}
