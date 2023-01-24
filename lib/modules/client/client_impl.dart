import 'package:synerise_flutter_sdk/enums/client/identity_provider.dart';
import 'package:synerise_flutter_sdk/model/client/client_auth_context.dart';
import 'package:synerise_flutter_sdk/model/client/register_account.dart';
import 'package:synerise_flutter_sdk/model/client/token.dart';
import 'package:synerise_flutter_sdk/modules/client/client_platform_interface.dart';

import '../base/base_module.dart';

class ClientImpl extends BaseModule {
  Future<void> signIn(String email, String password) {
    return ClientPlatform.instance.signIn(email, password);
  }

  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) {
    return ClientPlatform.instance.registerAccount(clientAccountRegisterContext);
  }

  void signOut() {
    return ClientPlatform.instance.signOut();
  }

  Future<bool> isSignedIn() {
    return ClientPlatform.instance.isSignedIn();
  }

  Future<Token> retrieveToken() {
    return ClientPlatform.instance.retrieveToken();
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) {
    return ClientPlatform.instance.authenticate(clientAuthContext, identityProvider, tokenString);
  }
}
