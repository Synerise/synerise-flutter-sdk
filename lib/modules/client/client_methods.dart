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
import '../base/base_module_method_channel.dart';

class ClientMethods extends BaseMethodChannel {
  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) async {
    await methodChannel.invokeMethod('Client/registerAccount', clientAccountRegisterContext.asMap());
  }

  Future<void> confirmAccount(String token) async {
    await methodChannel.invokeMethod('Client/confirmAccount', {"token": token});
  }

  Future<void> activateAccount(String email) async {
    await methodChannel.invokeMethod('Client/activateAccount', {"email": email});
  }

  Future<void> confirmAccountActivationByPin(String email, String pinCode) async {
    await methodChannel.invokeMethod('Client/confirmAccountActivationByPin', {"email": email, "pinCode": pinCode});
  }

  Future<void> requestAccountActivationByPin(String email) async {
    await methodChannel.invokeMethod('Client/requestAccountActivationByPin', {"email": email});
  }

  Future<void> signIn(String email, String password) async {
    await methodChannel.invokeMethod('Client/signIn', {"email": email, "password": password});
  }

  Future<ClientConditionalAuthResult> signInConditionally(String email, String password) async {
    var clientConditionalAuthResultMap =
        await methodChannel.invokeMethod('Client/signInConditionally', {"email": email, "password": password});
    ClientConditionalAuthResult clientConditionalAuthResult = ClientConditionalAuthResult.fromMap(clientConditionalAuthResultMap);
    return clientConditionalAuthResult;
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) async {
    var authenticateMap = <String, dynamic>{
      'clientAuthContext': clientAuthContext.asMap(),
      'identityProvider': identityProvider.getIdentityProviderAsString(),
      'tokenString': tokenString
    };
    bool isAuthenticated = await methodChannel.invokeMethod('Client/authenticate', authenticateMap);
    return isAuthenticated;
  }

  Future<ClientConditionalAuthResult> authenticateConditionally(IdentityProvider identityProvider, String tokenString,
      ClientCondtitionalAuthContext? clientCondtitionalAuthContext, String? authID) async {
    var authenticateMap = <String, dynamic>{
      'identityProvider': identityProvider.getIdentityProviderAsString(),
      'tokenString': tokenString,
      'clientAuthContext': clientCondtitionalAuthContext ?? clientCondtitionalAuthContext?.asMap(),
      'authID': authID ?? authID
    };
    var clientConditionalAuthResultMap = await methodChannel.invokeMethod('Client/authenticateConditionally', authenticateMap);
    ClientConditionalAuthResult clientConditionalAuthResult = ClientConditionalAuthResult.fromMap(clientConditionalAuthResultMap);
    return clientConditionalAuthResult;
  }

  Future<void> simpleAuthentication(ClientSimpleAuthenticationData clientSimpleAuthenticationData, String authID) async {
    await methodChannel.invokeMethod(
        "Client/simpleAuthentication", {"clientSimpleAuthenticationData": clientSimpleAuthenticationData.asMap(), "authID": authID});
  }

  Future<bool> isSignedIn() async {
    bool isSignedIn = await methodChannel.invokeMethod('Client/isSignedIn');
    return isSignedIn;
  }

  Future<bool> isSignedInViaSimpleAuthentication() async {
    bool result = await methodChannel.invokeMethod("Client/isSignedInViaSimpleAuthentication");
    return result;
  }

  Future<void> signOut() async {
    await methodChannel.invokeMethod("Client/signOut");
  }

  Future<void> signOutWithMode(ClientSignOutMode mode, bool fromAllDevices) async {
    await methodChannel
        .invokeMethod("Client/signOutWithMode", {"mode": mode.clientSignOutModeAsString(), "fromAllDevices": fromAllDevices});
  }

  Future<bool> refreshToken() async {
    bool result = await methodChannel.invokeMethod("Client/refreshToken");
    return result;
  }

  Future<Token> retrieveToken() async {
    var tokenMap = await methodChannel.invokeMethod('Client/retrieveToken');
    Token token = Token.fromMap(tokenMap);
    return token;
  }

  Future<String> getUUID() async {
    String uuid = await methodChannel.invokeMethod('Client/getUUID');
    return uuid;
  }

  Future<bool> regenerateUUID() async {
    bool result = await methodChannel.invokeMethod("Client/regenerateUUID");
    return result;
  }

  Future<bool> regenerateUUIDWithClientIdentifier(String clientIdentifier) async {
    bool result = await methodChannel.invokeMethod("Client/regenerateUUIDWithClientIdentifier", {"clientIdentifier": clientIdentifier});
    return result;
  }

  Future<void> destroySession() async {
    await methodChannel.invokeMethod('Client/destroySession');
  }

  Future<ClientAccountInformation> getAccount() async {
    var clientAccountMap = await methodChannel.invokeMethod('Client/getAccount');
    ClientAccountInformation clientAccountInformation = ClientAccountInformation.fromMap(clientAccountMap);
    return clientAccountInformation;
  }

  Future<void> updateAccount(ClientAccountUpdateContext clientAccountUpdateContext) async {
    await methodChannel.invokeMethod('Client/updateAccount', clientAccountUpdateContext.asMap());
  }

  Future<void> requestPasswordReset(String email) async {
    await methodChannel.invokeMethod('Client/requestPasswordReset', {"email": email});
  }

  Future<void> confirmPasswordReset(String token, String password) async {
    await methodChannel.invokeMethod('Client/confirmPasswordReset', {"token": token, "password": password});
  }

  Future<void> changePassword(String oldPassword, String password) async {
    await methodChannel.invokeMethod('Client/changePassword', {"oldPassword": oldPassword, "password": password});
  }

  Future<void> requestEmailChange(String email, String password, String? externalToken, String? authID) async {
    var requestEmailChangeMap = <String, dynamic>{'email': email, 'password': password, 'externalToken': externalToken, 'authID': authID};
    await methodChannel.invokeMethod('Client/requestEmailChange', requestEmailChangeMap);
  }

  Future<void> confirmEmailChange(String token, bool newsletterAgreement) async {
    await methodChannel.invokeMethod('Client/confirmEmailChange', {"token": token, "newsletterAgreement": newsletterAgreement});
  }

  Future<void> requestPhoneUpdate(String phone) async {
    await methodChannel.invokeMethod('Client/requestPhoneUpdate', {"phone": phone});
  }

  Future<void> confirmPhoneUpdate(String phone, String confirmationCode, bool smsAgreement) async {
    await methodChannel
        .invokeMethod('Client/confirmPhoneUpdate', {"phone": phone, "confirmationCode": confirmationCode, "smsAgreement": smsAgreement});
  }

  Future<void> deleteAccount(String clientAuthFactor, IdentityProvider identityProvider, String? authId) async {
    await methodChannel.invokeMethod('Client/deleteAccount',
        {"clientAuthFactor": clientAuthFactor, "identityProvider": identityProvider.getIdentityProviderAsString(), "authId": authId});
  }
}
