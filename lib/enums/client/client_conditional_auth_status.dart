/// `ClientConditionalAuthStatus` represents the status of conditional client process. Each enum
/// value represents a different status and is associated with a string value.
enum ClientConditionalAuthStatus {
  success('SUCCESS'),
  unauthorized('UNAUTHORIZED'),
  activationRequired('ACTIVATION_REQUIRED'),
  registrationRequired('REGISTRATION_REQUIRED'),
  approvalRequired('APPROVAL_REQUIRED'),
  termsAcceptanceRequired('TERMS_ACCEPTANCE_REQUIRED'),
  mfaRequired('MFA_REQUIRED');

  const ClientConditionalAuthStatus(this.clientConditionalAuthStatus);

  final String clientConditionalAuthStatus;

  /// The function returns the client conditional authentication status as a string.
  ///
  /// Returns:
  ///   The method is returning the value of the variable "clientConditionalAuthStatus" as a string.
  String getClientConditionalAuthStatusAsString() {
    return clientConditionalAuthStatus;
  }

  /// The function `getClientConditionalAuthStatusFromString` converts a string representation of a
  /// client conditional authentication status into the corresponding enum value.
  static ClientConditionalAuthStatus? getClientConditionalAuthStatusFromString(
      String string) {
    if (string == 'SUCCESS') {
      return ClientConditionalAuthStatus.success;
    } else if (string == 'UNAUTHORIZED') {
      return ClientConditionalAuthStatus.unauthorized;
    } else if (string == 'ACTIVATION_REQUIRED') {
      return ClientConditionalAuthStatus.activationRequired;
    } else if (string == 'REGISTRATION_REQUIRED') {
      return ClientConditionalAuthStatus.registrationRequired;
    } else if (string == 'APPROVAL_REQUIRED') {
      return ClientConditionalAuthStatus.approvalRequired;
    } else if (string == 'TERMS_ACCEPTANCE_REQUIRED') {
      return ClientConditionalAuthStatus.termsAcceptanceRequired;
    } else if (string == 'MFA_REQUIRED') {
      return ClientConditionalAuthStatus.mfaRequired;
    } else {
      return null;
    }
  }
}
