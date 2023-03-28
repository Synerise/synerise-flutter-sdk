

import '../../enums/client/identity_provider.dart';
import '../../model/client/client_account_information.dart';
import '../../model/client/client_account_register_context.dart';
import '../../model/client/client_account_update_context.dart';
import '../../model/client/client_auth_context.dart';
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

  Future<void> signIn(String email, String password) async {
    await methodChannel.invokeMethod('Client/signIn', {"email": email, "password": password});
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

  Future<bool> isSignedIn() async {
    bool isSignedIn = await methodChannel.invokeMethod('Client/isSignedIn');
    return isSignedIn;
  }

  Future<void> signOut() async {
    await methodChannel.invokeMethod("Client/signOut");
  }

  Future<void> destroySession() async {
    await methodChannel.invokeMethod('Client/destroySession');
  }

  Future<Token> retrieveToken() async {
    var tokenMap = await methodChannel.invokeMethod('Client/retrieveToken');
    Token token = Token.fromMap(tokenMap);
    return token;
  }

  Future<bool> refreshToken() async {
    bool result = await methodChannel.invokeMethod("Client/refreshToken");
    return result;
  }

  Future<String> getUUID() async {
    String uuid = await methodChannel.invokeMethod('Client/getUUID');
    return uuid;
  }

  Future<void> regenerateUUID() async {
    await methodChannel.invokeMethod("Client/regenerateUUID");
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

  Future<void> deleteAccount(String clientAuthFactor, IdentityProvider identityProvider, String? authId) async {
    await methodChannel.invokeMethod('Client/deleteAccount',
        {"clientAuthFactor": clientAuthFactor, "identityProvider": identityProvider.getIdentityProviderAsString(), "authId": authId});
  }
}
