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

class ClientMethods extends BaseMethodChannel {
  Future<SyneriseResult<void>> registerAccount(
      ClientAccountRegisterContext clientAccountRegisterContext) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/registerAccount',
        parameters: clientAccountRegisterContext.asMap());
  }

  Future<SyneriseResult<void>> confirmAccount(String token) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/confirmAccount',
        parameters: {"token": token});
  }

  Future<SyneriseResult<void>> activateAccount(String email) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/activateAccount',
        parameters: {"email": email});
  }

  Future<SyneriseResult<void>> confirmAccountActivationByPin(
      String email, String pinCode) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/confirmAccountActivationByPin',
        parameters: {"email": email, "pinCode": pinCode});
  }

  Future<SyneriseResult<void>> requestAccountActivationByPin(
      String email) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/requestAccountActivationByPin',
        parameters: {"email": email});
  }

  Future<SyneriseResult<void>> signIn(String email, String password) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/signIn',
        parameters: {"email": email, "password": password});
  }

  Future<SyneriseResult<ClientConditionalAuthResult>> signInConditionally(
      String email, String password) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ClientConditionalAuthResult>(
            'Client/signInConditionally',
            parameters: {"email": email, "password": password},
            isMappable: true);
  }

  Future<SyneriseResult<bool>> authenticate(ClientAuthContext clientAuthContext,
      IdentityProvider identityProvider, String tokenString) async {
    var authenticateMap = <String, dynamic>{
      'clientAuthContext': clientAuthContext.asMap(),
      'identityProvider': identityProvider.getIdentityProviderAsString(),
      'tokenString': tokenString
    };

    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<bool>(
        'Client/authenticate',
        parameters: authenticateMap);
  }

  Future<SyneriseResult<ClientConditionalAuthResult>> authenticateConditionally(
      IdentityProvider identityProvider,
      String tokenString,
      ClientCondtitionalAuthContext? clientCondtitionalAuthContext,
      String? authID) async {
    var authenticateMap = <String, dynamic>{
      'identityProvider': identityProvider.getIdentityProviderAsString(),
      'tokenString': tokenString,
      'clientAuthContext': clientCondtitionalAuthContext ??
          clientCondtitionalAuthContext?.asMap(),
      'authID': authID ?? authID
    };

    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ClientConditionalAuthResult>(
            'Client/authenticateConditionally',
            parameters: authenticateMap,
            isMappable: true);
  }

  Future<SyneriseResult<void>> simpleAuthentication(
      ClientSimpleAuthenticationData clientSimpleAuthenticationData,
      String authID) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>("Client/simpleAuthentication", parameters: {
      "clientSimpleAuthenticationData": clientSimpleAuthenticationData.asMap(),
      "authID": authID
    });
  }

  Future<bool> isSignedIn() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<bool>('Client/isSignedIn');
  }

  Future<bool> isSignedInViaSimpleAuthentication() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<bool>("Client/isSignedInViaSimpleAuthentication");
  }

  Future<void> signOut() async {
    return SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>("Client/signOut");
  }

  Future<SyneriseResult<void>> signOutWithMode(
      ClientSignOutMode mode, bool fromAllDevices) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>("Client/signOutWithMode", parameters: {
      "mode": mode.clientSignOutModeAsString(),
      "fromAllDevices": fromAllDevices
    });
  }

  Future<SyneriseResult<void>> refreshToken() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>("Client/refreshToken");
  }

  Future<SyneriseResult<Token>> retrieveToken() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<Token>('Client/retrieveToken', isMappable: true);
  }

  Future<String> getUUID() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<String>('Client/getUUID');
  }

  Future<bool> regenerateUUID() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<bool>('Client/regenerateUUID');
  }

  Future<bool> regenerateUUIDWithClientIdentifier(
      String clientIdentifier) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<bool>(
        'Client/regenerateUUIDWithClientIdentifier',
        parameters: {"clientIdentifier": clientIdentifier});
  }

  Future<SyneriseResult<void>> destroySession() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>('Client/destroySession');
  }

  Future<SyneriseResult<ClientAccountInformation>> getAccount() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<ClientAccountInformation>('Client/getAccount',
            isMappable: true);
  }

  Future<SyneriseResult<void>> updateAccountBasicInformation(ClientAccountUpdateBasicInformationContext clientAccountUpdateBasicInformationContext) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/updateAccountBasicInformation',
        parameters: clientAccountUpdateBasicInformationContext.asMap());
  }
  
  Future<SyneriseResult<void>> updateAccount(
      ClientAccountUpdateContext clientAccountUpdateContext) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/updateAccount',
        parameters: clientAccountUpdateContext.asMap());
  }

  Future<SyneriseResult<void>> requestPasswordReset(String email) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/requestPasswordReset',
        parameters: {"email": email});
  }

  Future<SyneriseResult<void>> confirmPasswordReset(
      String token, String password) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/confirmPasswordReset',
        parameters: {"token": token, "password": password});
  }

  Future<SyneriseResult<void>> changePassword(
      String oldPassword, String password) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/changePassword',
        parameters: {"oldPassword": oldPassword, "password": password});
  }

  Future<SyneriseResult<void>> requestEmailChange(String email, String password,
      String? externalToken, String? authID) async {
    var requestEmailChangeMap = <String, dynamic>{
      'email': email,
      'password': password,
      'externalToken': externalToken,
      'authID': authID
    };

    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/requestEmailChange',
        parameters: requestEmailChangeMap);
  }

  Future<SyneriseResult<void>> confirmEmailChange(
      String token, bool newsletterAgreement) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>('Client/confirmEmailChange', parameters: {
      "token": token,
      "newsletterAgreement": newsletterAgreement
    });
  }

  Future<SyneriseResult<void>> requestPhoneUpdate(String phone) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Client/requestPhoneUpdate',
        parameters: {"phone": phone});
  }

  Future<SyneriseResult<void>> confirmPhoneUpdate(
      String phone, String confirmationCode, bool smsAgreement) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>('Client/confirmPhoneUpdate', parameters: {
      "phone": phone,
      "confirmationCode": confirmationCode,
      "smsAgreement": smsAgreement
    });
  }

  Future<SyneriseResult<void>> deleteAccount(String clientAuthFactor,
      IdentityProvider identityProvider, String? authId) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKApiMethod<void>('Client/deleteAccount', parameters: {
      "clientAuthFactor": clientAuthFactor,
      "identityProvider": identityProvider.getIdentityProviderAsString(),
      "authId": authId
    });
  }
}
