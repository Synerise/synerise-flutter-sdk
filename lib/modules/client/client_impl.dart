// ignore_for_file: unnecessary_null_comparison

import '../../model/client/client_simple_authentication_data.dart';
import '../../model/client/client_conditional_auth_context.dart';
import '../../enums/client/client_sign_out_mode.dart';
import '../../enums/client/identity_provider.dart';
import '../../model/client/client_account_information.dart';
import '../../model/client/client_account_register_context.dart';
import '../../model/client/client_account_update_basic_information_context.dart';
import '../../model/client/client_account_update_context.dart';
import '../../model/client/client_auth_context.dart';
import '../../model/client/client_conditional_auth_result.dart';
import '../../model/client/token.dart';
import '../base/base_module_method_channel.dart';
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
      ClientAccountRegisterContext clientAccountRegisterContext,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.registerAccount(clientAccountRegisterContext);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function confirms a user's account using a token.
  ///
  /// Args:
  ///   token (String): The "token" parameter is a string that represents a unique identifier for a user
  /// account confirmation.
  Future<void> confirmAccount(String token,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.confirmAccount(token);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function activates a user account using their email address.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// whose account needs to be activated.
  Future<void> activateAccount(String email,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.activateAccount(email);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// The function `confirmAccountActivationByPin` takes an email and a pin code as parameters and confirms
  /// the acctivation of an account by a pinCode.
  ///
  /// Args:
  ///   email (String): A string representing the email address of the user.
  ///   pinCode (String): The pinCode parameter is a string that represents the PIN code sent to email of
  ///   the user that account needs to be activated.
  Future<void> confirmAccountActivationByPin(String email, String pinCode,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.confirmAccountActivationByPin(email, pinCode);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// The function `requestAccountActivationByPin` sends a request to activate an account using a PIN
  /// code.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// who wants to request account activation.
  Future<void> requestAccountActivationByPin(String email,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.requestAccountActivationByPin(email);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function takes an email and password as parameters and signs in the
  /// user using those credentials.
  ///
  /// Args:
  ///   email (String): A string representing the email address of the user trying to sign in.
  ///   password (String): The password parameter is a string that represents the user's password.
  Future<void> signIn(String email, String password,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.signIn(email, password);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
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
  Future<void> signInConditionally(String email, String password,
      {required void Function(ClientConditionalAuthResult) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<ClientConditionalAuthResult> result =
        await _methods.signInConditionally(email, password);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
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
  Future<void> authenticate(ClientAuthContext clientAuthContext,
      IdentityProvider identityProvider, String tokenString,
      {required void Function(bool) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<bool> result = await _methods.authenticate(
        clientAuthContext, identityProvider, tokenString);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
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
  Future<void> authenticateConditionally(
      IdentityProvider identityProvider, String tokenString,
      {required void Function(ClientConditionalAuthResult) onSuccess,
      required void Function(SyneriseError error) onError,
      ClientCondtitionalAuthContext? clientAuthContext,
      String? authID}) async {
    SyneriseResult<ClientConditionalAuthResult> result =
        await _methods.authenticateConditionally(
            identityProvider, tokenString, clientAuthContext, authID);

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
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
      String authID,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.simpleAuthentication(
        clientSimpleAuthenticationData, authID);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
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
    return await _methods.signOut();
  }

  /// The function signOutWithMode signs out the client with the specified mode and from all devices if
  /// specified.
  ///
  /// Args:
  ///   mode (ClientSignOutMode): The mode parameter is of type ClientSignOutMode, which is an enum that
  /// represents the sign out mode.
  ///   fromAllDevices (bool): A boolean value indicating whether the sign out should be applied to all
  /// devices or just the current device.
  Future<void> signOutWithMode(ClientSignOutMode mode, bool fromAllDevices,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.signOutWithMode(mode, fromAllDevices);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function refreshes user token.
  Future<void> refreshToken(
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.refreshToken();

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function retrieves a token.
  Future<void> retrieveToken(
      {required void Function(Token) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<Token> result = await _methods.retrieveToken();

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function returns a user's UUID string.
  Future<String> getUUID() async {
    return await _methods.getUUID();
  }

  /// This function regenerates a UUID.
  Future<bool> regenerateUUID() async {
    return await _methods.regenerateUUID();
  }

  /// The function regenerates a UUID using a client identifier.
  ///
  /// Args:
  ///   clientIdentifier (String): The clientIdentifier parameter is a string that represents the
  /// identifier of the client. It is used as input to regenerate a UUID associated with the client.
  Future<bool> regenerateUUIDWithClientIdentifier(
      String clientIdentifier) async {
    return await _methods.regenerateUUIDWithClientIdentifier(clientIdentifier);
  }

  /// This function destroys a session asynchronously.
  Future<void> destroySession(
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.destroySession();

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function returns a Future object containing the client account information.
  Future<void> getAccount(
      {required void Function(ClientAccountInformation) onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<ClientAccountInformation> result =
        await _methods.getAccount();

    result.onSuccess((result) {
      onSuccess(result);
    }).onError((error) {
      onError(error);
    });
  }

  /// This function updates an anonymous client account using the provided object.
  ///
  /// Args:
  ///   clientAccountUpdateBasicInformatioContext (ClientAccountUpdateBasicInformationContext): It is an object of type
  /// ClientAccountUpdateBasicInformationContext that contains the information needed to update a client's account. This
  /// object may include fields such as the client's name, phone number, address, and any other
  /// relevant information that needs to be updated.
  Future<void> updateAccountBasicInformation(
      ClientAccountUpdateBasicInformationContext clientAccountUpdateBasicInformationContext,
      {required void Function() onSuccess,
        required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
    await _methods.updateAccountBasicInformation(clientAccountUpdateBasicInformationContext);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function updates a client account using the provided context.
  ///
  /// Args:
  ///   clientAccountUpdateContext (ClientAccountUpdateContext): It is an object of type
  /// ClientAccountUpdateContext that contains the information needed to update a client's account. This
  /// object may include fields such as the client's name, email, phone number, address, and any other
  /// relevant information that needs to be updated.
  Future<void> updateAccount(
      ClientAccountUpdateContext clientAccountUpdateContext,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.updateAccount(clientAccountUpdateContext);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function requests a password reset for a given email address.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// who wants to reset their password.
  Future<void> requestPasswordReset(String email,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.requestPasswordReset(email);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function confirms a password reset using a token and a new password.
  ///
  /// Args:
  ///   token (String): The token is a unique string that is generated  when a user requests to reset their
  /// password. This token is used to verify the user's identity when they reset their password.
  ///   password (String): The password parameter is a string that represents the new password that the
  /// user wants to set for their account after resetting their password.
  Future<void> confirmPasswordReset(String token, String password,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.confirmPasswordReset(token, password);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function changes the user's password by calling a private method with the old and new
  /// passwords as parameters.
  ///
  /// Args:
  ///   oldPassword (String): The old password is a string parameter that represents the user's current
  /// password. It is used to verify the user's identity before allowing them to change their password.
  ///   password (String): The new password that the user wants to set.
  Future<void> changePassword(String oldPassword, String password,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.changePassword(oldPassword, password);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
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
      {String? externalToken,
      String? authID,
      required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.requestEmailChange(
        email, password, externalToken, authID);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// The function `confirmEmailChange` in Dart confirms the change of email with a token and updates the
  /// newsletter agreement.
  ///
  /// Args:
  ///   token (String): A string representing the token used to confirm the email change. This token is
  /// generated and sent to the user's email address when they request to change their email.
  ///   newsletterAgreement (bool): A boolean value indicating whether the user has agreed to receive
  /// newsletters or not.
  Future<void> confirmEmailChange(String token, bool newsletterAgreement,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result =
        await _methods.confirmEmailChange(token, newsletterAgreement);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// The function `requestPhoneUpdate` sends a request to update the phone number.
  ///
  /// Args:
  ///   phone (String): A string representing the new phone number that needs to be updated.
  Future<void> requestPhoneUpdate(String phone,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.requestPhoneUpdate(phone);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
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
      String phone, String confirmationCode, bool smsAgreement,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.confirmPhoneUpdate(
        phone, confirmationCode, smsAgreement);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
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
      IdentityProvider identityProvider, String? authId,
      {required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.deleteAccount(
        clientAuthFactor, identityProvider, authId);

    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }
}
