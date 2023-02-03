import 'package:synerise_flutter_sdk/enums/client/identity_provider.dart';
import 'package:synerise_flutter_sdk/model/client/client_auth_context.dart';
import 'package:synerise_flutter_sdk/model/client/register_account.dart';
import 'package:synerise_flutter_sdk/model/client/token.dart';

import '../base/base_module.dart';
import 'client_methods.dart';

class ClientImpl extends BaseModule {
  final ClientMethods _methods = ClientMethods();
  ClientImpl();

  Future<void> signIn(String email, String password) {
    return _methods.signIn(email, password);
  }

  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) {
    return _methods.registerAccount(clientAccountRegisterContext);
  }

  Future<void> signOut() {
    return _methods.signOut();
  }

  Future<bool> isSignedIn() {
    return _methods.isSignedIn();
  }

  Future<Token> retrieveToken() {
    return _methods.retrieveToken();
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) {
    return _methods.authenticate(clientAuthContext, identityProvider, tokenString);
  }
}
