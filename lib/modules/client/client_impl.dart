import '../../model/client/client_simple_authentication_data.dart';
import '../../model/client/client_conditional_auth_context.dart';
import '../../enums/client/client_sign_out_mode.dart';
import '../../enums/client/identity_provider.dart';
import '../../model/client/client_account_information.dart';
import '../../model/client/client_account_register_context.dart';
import '../../model/client/client_account_update_context.dart';
import '../../model/client/client_auth_context.dart';
import '../../model/client/client_conditional_auth_result.dart';
import '../../model/client/token.dart';
import '../base/base_module.dart';
import 'client_methods.dart';

class ClientImpl extends BaseModule {
  final ClientMethods _methods = ClientMethods();
  ClientImpl();

  /// This function registers a client account asynchronously using the provided context.
  ///
  /// Args:
  ///   clientAccountRegisterContext (ClientAccountRegisterContext): It is an object of type
  /// ClientAccountRegisterContext that contains the necessary information to register a client account.
  Future<void> registerAccount(
      ClientAccountRegisterContext clientAccountRegisterContext) async {
    return _methods.registerAccount(clientAccountRegisterContext);
  }

  /// This function confirms a user's account using a token.
  ///
  /// Args:
  ///   token (String): The "token" parameter is a string that represents a unique identifier for a user
  /// account confirmation.
  Future<void> confirmAccount(String token) async {
    return _methods.confirmAccount(token);
  }

  /// This function activates a user account using their email address.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// whose account needs to be activated.
  Future<void> activateAccount(String email) async {
    return _methods.activateAccount(email);
  }

  /// The function `confirmAccountActivationByPin` takes an email and a pin code as parameters and confirms
  /// the acctivation of an account by a pinCode.
  ///
  /// Args:
  ///   email (String): A string representing the email address of the user.
  ///   pinCode (String): The pinCode parameter is a string that represents the PIN code sent to email of
  ///   the user that account needs to be activated.
  Future<void> confirmAccountActivationByPin(
      String email, String pinCode) async {
    return _methods.confirmAccountActivationByPin(email, pinCode);
  }

  /// The function `requestAccountActivationByPin` sends a request to activate an account using a PIN
  /// code.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// who wants to request account activation.
  Future<void> requestAccountActivationByPin(String email) async {
    return _methods.requestAccountActivationByPin(email);
  }

  /// This function takes an email and password as parameters and signs in the
  /// user using those credentials.
  ///
  /// Args:
  ///   email (String): A string representing the email address of the user trying to sign in.
  ///   password (String): The password parameter is a string that represents the user's password.
  Future<void> signIn(String email, String password) async {
    return _methods.signIn(email, password);
  }

  /// `signInConditionally` returns a 'ClientConditionalAuthResult' that represents the result of a conditional
  /// sign-in operation.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the user's email address.
  ///   password (String): The password parameter is a string that represents the user's password.
  ///
  /// Returns:
  ///   The method `signInConditionally` is returning a `ClientConditionalAuthResult`.
  Future<ClientConditionalAuthResult> signInConditionally(
      String email, String password) async {
    return _methods.signInConditionally(email, password);
  }

  /// This function authenticates a client using an identity provider, clientAuthContext and a token string.
  ///
  /// Args:
  ///   clientAuthContext (ClientAuthContext): An object that contains information about the client's
  /// authentication context.
  ///   identityProvider (IdentityProvider): The `identityProvider` parameter is an object that
  /// represents the identity provider used for authentication.
  ///   tokenString (String): The `tokenString` parameter is a string that represents an authentication
  /// token.
  Future<bool> authenticate(ClientAuthContext clientAuthContext,
      IdentityProvider identityProvider, String tokenString) async {
    return _methods.authenticate(
        clientAuthContext, identityProvider, tokenString);
  }

  /// The function `authenticateConditionally` authenticates a user conditionally based on the provided
  /// identity provider, token string, client authentication context, and authentication ID.
  ///
  /// Args:
  ///   identityProvider (IdentityProvider): The identity provider is an object that represents the
  /// service or system responsible for authenticating users. It could be a third-party service like
  /// Google or Facebook, or it could be an internal authentication system.
  ///   tokenString (String): The tokenString parameter is a string that represents the authentication
  /// token provided by the identity provider.
  ///   clientAuthContext (ClientCondtitionalAuthContext): The `clientAuthContext` parameter is an
  /// optional parameter of type `ClientConditionalAuthContext`. It represents additional context
  /// information that can be used during the conditional authentication process.
  ///   authID (String): The `authID` parameter is an optional string that represents the authentication
  /// ID. It is used to uniquely identify the authentication process.
  ///
  /// Returns:
  ///   The method is returning a `Future` object that resolves to a `ClientConditionalAuthResult`
  /// object.
  Future<ClientConditionalAuthResult> authenticateConditionally(
      IdentityProvider identityProvider, String tokenString,
      [ClientCondtitionalAuthContext? clientAuthContext,
      String? authID]) async {
    return _methods.authenticateConditionally(
        identityProvider, tokenString, clientAuthContext, authID);
  }

  /// This method signs in a customer with Simple Authentication.
  ///
  /// Args:
  ///   clientSimpleAuthenticationData (ClientSimpleAuthenticationData): It is an object that
  /// contains the necessary data for client authentication.
  ///   authID (String): The authID parameter is a string that represents the authentication ID. It is
  /// used as a unique identifier for the authentication process.
  Future<void> simpleAuthentication(
      ClientSimpleAuthenticationData clientSimpleAuthenticationData,
      String authID) async {
    return _methods.simpleAuthentication(
        clientSimpleAuthenticationData, authID);
  }

  /// This function returns a boolean value indicating whether the user is signed in or not.
  Future<bool> isSignedIn() async {
    return _methods.isSignedIn();
  }

  /// The function `isSignedInViaSimpleAuthentication` checks whether the user is signed in via simple authentication.
  ///
  /// Returns:
  ///   The method is returning a `Future<bool>` object.
  Future<bool> isSignedInViaSimpleAuthentication() async {
    return _methods.isSignedInViaSimpleAuthentication();
  }

  /// This function signs the user out of the current session.
  Future<void> signOut() async {
    return _methods.signOut();
  }

  /// The function signOutWithMode signs out the client with the specified mode and from all devices if
  /// specified.
  ///
  /// Args:
  ///   mode (ClientSignOutMode): The mode parameter is of type ClientSignOutMode, which is an enum that
  /// represents the sign out mode.
  ///   fromAllDevices (bool): A boolean value indicating whether the sign out should be applied to all
  /// devices or just the current device.
  Future<void> signOutWithMode(
      ClientSignOutMode mode, bool fromAllDevices) async {
    return _methods.signOutWithMode(mode, fromAllDevices);
  }

  /// This function refreshes user token.
  Future<bool> refreshToken() async {
    return _methods.refreshToken();
  }

  /// This function retrieves a token.
  Future<Token> retrieveToken() async {
    return _methods.retrieveToken();
  }

  /// This function returns a user's UUID string.
  Future<String> getUUID() async {
    return _methods.getUUID();
  }

  /// This function regenerates a UUID.
  Future<bool> regenerateUUID() async {
    return _methods.regenerateUUID();
  }

  /// The function regenerates a UUID using a client identifier.
  ///
  /// Args:
  ///   clientIdentifier (String): The clientIdentifier parameter is a string that represents the
  /// identifier of the client. It is used as input to regenerate a UUID associated with the client.
  Future<bool> regenerateUUIDWithClientIdentifier(
      String clientIdentifier) async {
    return _methods.regenerateUUIDWithClientIdentifier(clientIdentifier);
  }

  /// This function destroys a session asynchronously.
  Future<void> destroySession() async {
    return _methods.destroySession();
  }

  /// This function returns a Future object containing the client account information.
  Future<ClientAccountInformation> getAccount() async {
    return _methods.getAccount();
  }

  /// This function updates a client account using the provided context.
  ///
  /// Args:
  ///   clientAccountUpdateContext (ClientAccountUpdateContext): It is an object of type
  /// ClientAccountUpdateContext that contains the information needed to update a client's account. This
  /// object may include fields such as the client's name, email, phone number, address, and any other
  /// relevant information that needs to be updated.
  Future<void> updateAccount(
      ClientAccountUpdateContext clientAccountUpdateContext) async {
    return _methods.updateAccount(clientAccountUpdateContext);
  }

  /// This function requests a password reset for a given email address.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// who wants to reset their password.
  Future<void> requestPasswordReset(String email) async {
    return _methods.requestPasswordReset(email);
  }

  /// This function confirms a password reset using a token and a new password.
  ///
  /// Args:
  ///   token (String): The token is a unique string that is generated  when a user requests to reset their
  /// password. This token is used to verify the user's identity when they reset their password.
  ///   password (String): The password parameter is a string that represents the new password that the
  /// user wants to set for their account after resetting their password.
  Future<void> confirmPasswordReset(String token, String password) async {
    return _methods.confirmPasswordReset(token, password);
  }

  /// This function changes the user's password by calling a private method with the old and new
  /// passwords as parameters.
  ///
  /// Args:
  ///   oldPassword (String): The old password is a string parameter that represents the user's current
  /// password. It is used to verify the user's identity before allowing them to change their password.
  ///   password (String): The new password that the user wants to set.
  Future<void> changePassword(String oldPassword, String password) async {
    return _methods.changePassword(oldPassword, password);
  }

  /// The function `requestEmailChange` sends a request to change the user's email address.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the new email address that the
  /// user wants to change to.
  ///   password (String): The password parameter is a string that represents the user's current
  /// password.
  ///   externalToken (String): The externalToken parameter is an optional string that represents an
  /// external token used for authentication.
  ///   authID (String): The authID parameter is an optional parameter that represents the
  /// authentication ID of the user.
  Future<void> requestEmailChange(String email, String password,
      [String? externalToken, String? authID]) async {
    return _methods.requestEmailChange(email, password, externalToken, authID);
  }

  /// The function `confirmEmailChange` in Dart confirms the change of email with a token and updates the
  /// newsletter agreement.
  ///
  /// Args:
  ///   token (String): A string representing the token used to confirm the email change. This token is
  /// generated and sent to the user's email address when they request to change their email.
  ///   newsletterAgreement (bool): A boolean value indicating whether the user has agreed to receive
  /// newsletters or not.
  Future<void> confirmEmailChange(
      String token, bool newsletterAgreement) async {
    return _methods.confirmEmailChange(token, newsletterAgreement);
  }

  /// The function `requestPhoneUpdate` sends a request to update the phone number.
  ///
  /// Args:
  ///   phone (String): A string representing the new phone number that needs to be updated.
  Future<void> requestPhoneUpdate(String phone) async {
    return _methods.requestPhoneUpdate(phone);
  }

  /// The function `confirmPhoneUpdate` takes in a phone number, confirmation code, and SMS agreement,
  /// and calls a private method to confirm the phone update.
  ///
  /// Args:
  ///   phone (String): A string representing the new phone number that the user wants to update to.
  ///   confirmationCode (String): The confirmation code is a string that is used to verify the phone
  /// number update.
  ///   smsAgreement (bool): A boolean value indicating whether the user has agreed to receive SMS
  /// notifications or not.
  Future<void> confirmPhoneUpdate(
      String phone, String confirmationCode, bool smsAgreement) async {
    return _methods.confirmPhoneUpdate(phone, confirmationCode, smsAgreement);
  }

  /// This function deletes an account using client authentication factor, identity provider, and
  /// optional authentication ID.
  ///
  /// Args:
  ///   clientAuthFactor (String): It is a string parameter that represents the authentication factor of
  /// the client.
  ///   identityProvider (IdentityProvider): The `identityProvider` parameter is an object of type
  /// `IdentityProvider` which represents the identity provider used for authentication.
  ///   authId (String): The authId parameter is an optional string that represents the unique
  /// identifier of the authenticated user whose account is to be deleted.
  Future<void> deleteAccount(String clientAuthFactor,
      IdentityProvider identityProvider, String? authId) async {
    return _methods.deleteAccount(clientAuthFactor, identityProvider, authId);
  }
}
