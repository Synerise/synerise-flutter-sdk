import 'package:synerise_flutter_sdk/enums/client/identity_provider.dart';
import 'package:synerise_flutter_sdk/model/client/token.dart';
import 'package:synerise_flutter_sdk/model/client/client_auth_context.dart';
import 'package:synerise_flutter_sdk/model/client/client_account_information.dart';
import 'package:synerise_flutter_sdk/model/client/client_account_register_context.dart';
import 'package:synerise_flutter_sdk/model/client/client_account_update_context.dart';

import '../base/base_module.dart';
import 'client_methods.dart';

class ClientImpl extends BaseModule {
  final ClientMethods _methods = ClientMethods();
  ClientImpl();

  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) async {
    return _methods.registerAccount(clientAccountRegisterContext);
  }

  Future<void> confirmAccount(String token) async {
    return _methods.confirmAccount(token);
  }

  Future<void> activateAccount(String email) async {
    return _methods.activateAccount(email);
  }

  Future<void> signIn(String email, String password) async {
    return _methods.signIn(email, password);
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) async {
    return _methods.authenticate(clientAuthContext, identityProvider, tokenString);
  }

  Future<bool> isSignedIn() async {
    return _methods.isSignedIn();
  }

  Future<void> signOut() async {
    return _methods.signOut();
  }

  Future<void> destroySession() async {
    return _methods.destroySession();
  }

  Future<Token> retrieveToken() async {
    return _methods.retrieveToken();
  }

  Future<void> refreshToken() async {
    return _methods.refreshToken();
  }

  Future<String> getUUID() async {
    return _methods.getUUID();
  }

  Future<void> regenerateUUID() async {
    return _methods.regenerateUUID();
  }

  Future<ClientAccountInformation> getAccount() async {
    return _methods.getAccount();
  }

  Future<void> updateAccount(ClientAccountUpdateContext clientAccountUpdateContext) async {
    return _methods.updateAccount(clientAccountUpdateContext);
  }

  Future<void> requestPasswordReset(String email) async {
    return _methods.requestPasswordReset(email);
  }

  Future<void> confirmPasswordReset(String token, String password) async {
    return _methods.confirmPasswordReset(token, password);
  }

  Future<void> changePassword(String oldPassword, String password) async {
    return _methods.changePassword(oldPassword, password);
  }

  Future<void> deleteAccount(String clientAuthFactor, IdentityProvider identityProvider, String? authId) async {
    return _methods.deleteAccount(clientAuthFactor, identityProvider, authId);
  }
}
