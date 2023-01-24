import 'package:synerise_flutter_sdk/model/client/register_account.dart';
import 'package:synerise_flutter_sdk/model/client/token.dart';
import 'package:synerise_flutter_sdk/modules/client/client_methods.dart';

import '../../enums/client/identity_provider.dart';
import '../../model/client/client_auth_context.dart';

abstract class ClientPlatform {
  static final ClientMethods _instance = ClientMethods();
  static ClientMethods get instance => _instance;

  Future<void> signIn(String email, String password) {
    throw UnimplementedError();
  }

  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) {
    throw UnimplementedError();
  }

  void signOut() {
    throw UnimplementedError();
  }

  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  Future<Token> retrieveToken() {
    throw UnimplementedError();
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) {
    throw UnimplementedError();
  }
}
