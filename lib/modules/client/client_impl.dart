import '../../enums/client/identity_provider.dart';
import '../../model/client/client_account_information.dart';
import '../../model/client/client_account_register_context.dart';
import '../../model/client/client_account_update_context.dart';
import '../../model/client/client_auth_context.dart';
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
  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) async {
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

  /// This function takes an email and password as parameters and signs in the
  /// user using those credentials.
  ///
  /// Args:
  ///   email (String): A string representing the email address of the user trying to sign in.
  ///   password (String): The password parameter is a string that represents the user's password.
  Future<void> signIn(String email, String password) async {
    return _methods.signIn(email, password);
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
  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) async {
    return _methods.authenticate(clientAuthContext, identityProvider, tokenString);
  }

  /// This function returns a boolean value indicating whether the user is signed in or not.
  Future<bool> isSignedIn() async {
    return _methods.isSignedIn();
  }

  /// This function signs the user out of the current session.
  Future<void> signOut() async {
    return _methods.signOut();
  }

  /// This function destroys a session asynchronously.
  Future<void> destroySession() async {
    return _methods.destroySession();
  }

  /// This function retrieves a token.
  Future<Token> retrieveToken() async {
    return _methods.retrieveToken();
  }

  /// This function refreshes user token.
  Future<bool> refreshToken() async {
    return _methods.refreshToken();
  }

  /// This function returns a user's UUID string.
  Future<String> getUUID() async {
    return _methods.getUUID();
  }

  /// This function regenerates a UUID.
  Future<void> regenerateUUID() async {
    return _methods.regenerateUUID();
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
  Future<void> updateAccount(ClientAccountUpdateContext clientAccountUpdateContext) async {
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
  Future<void> deleteAccount(String clientAuthFactor, IdentityProvider identityProvider, String? authId) async {
    return _methods.deleteAccount(clientAuthFactor, identityProvider, authId);
  }
}
