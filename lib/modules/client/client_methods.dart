import 'dart:collection';
import 'dart:convert';

import 'package:synerise_flutter_sdk/enums/client/identity_provider.dart';
import 'package:synerise_flutter_sdk/enums/client/token_origin.dart';
import 'package:synerise_flutter_sdk/model/client/register_account.dart';
import 'package:synerise_flutter_sdk/model/client/token.dart';

import '../../model/client/client_auth_context.dart';
import '../base/base_module_method_channel.dart';

/// An implementation of [ClientMethods] that uses main method channel.
class ClientMethods extends BaseMethodChannel {
  Future<void> signIn(String email, String password) async {
    await methodChannel.invokeMethod('Client/signIn', {"email": email, "password": password});
  }

  Future<void> registerAccount(ClientAccountRegisterContext clientAccountRegisterContext) async {
    await methodChannel.invokeMethod('Client/registerAccount', clientAccountRegisterContext.asMap());
  }

  Future<void> signOut() async {
    await methodChannel.invokeMethod("Client/signOut");
  }

  Future<bool> isSignedIn() async {
    bool isSignedIn = await methodChannel.invokeMethod('Client/isSignedIn');
    return isSignedIn;
  }

  Future<Token> retrieveToken() async {
    var tokenJson = await methodChannel.invokeMethod('Client/retrieveToken');
    var tokenMap = json.decode(tokenJson);
    var tokenHashMap = HashMap<String, dynamic>.from(tokenMap);
    var tokenString = tokenHashMap['tokenString'];
    var tokenOriginString = tokenHashMap['origin'];
    TokenOrigin tokenOrigin;
    if (tokenOriginString != null) {
      tokenOrigin = TokenOrigin.fromString(tokenOriginString);
    } else {
      tokenOrigin = TokenOrigin.unknown;
    }
    var expirationDateString = tokenHashMap['expirationDate'].toString();
    DateTime expirationDate = DateTime.parse(expirationDateString);
    Token token = Token(tokenString.toString(), tokenOrigin, expirationDate);
    return token;
  }

  Future<bool> authenticate(ClientAuthContext clientAuthContext, IdentityProvider identityProvider, String tokenString) async {
    var authenticateMap = <String, dynamic>{
      'clientAuthContext': clientAuthContext.asMap(),
      'identityProvider': identityProvider.getIdentityProvider(),
      'tokenString': tokenString
    };
    bool isAuthenticated = await methodChannel.invokeMethod('Client/authenticate', authenticateMap);
    return isAuthenticated;
  }
}
