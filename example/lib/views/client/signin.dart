import 'dart:async';


import 'package:flutter/material.dart';

import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final loginForm = GlobalKey<FormState>();
  bool _isSignedInBool = false;

  _tempFormBody() {
    return Form(
      key: loginForm,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              controller: passController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () => _signInCall(emailController.text, passController.text),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Sign in')),
                ElevatedButton.icon(onPressed: () => _signOutCall(), icon: const Icon(Icons.logout), label: const Text('Sign out')),
                ElevatedButton.icon(
                    onPressed: () => {
                          _isSignedInCall().whenComplete(() => {
                                if (_isSignedInBool)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text('Signed In!'),
                                      action: SnackBarAction(
                                        label: 'signedIn',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                    ))
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: const Text('Not signed In!'),
                                      action: SnackBarAction(
                                        label: 'notSignedIn',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                    ))
                                  }
                              })
                        },
                    icon: const Icon(Icons.login),
                    label: const Text('Is signed in test')),
                ElevatedButton.icon(
                    onPressed: () => _retrieveTokenCall(),
                    icon: const Icon(Icons.generating_tokens_outlined),
                    label: const Text('Retrieve token')),
                ElevatedButton.icon(
                    onPressed: () => _refreshTokenCall(),
                    icon: const Icon(Icons.generating_tokens_sharp),
                    label: const Text('RefreshToken Client Test')),
                ElevatedButton.icon(
                    onPressed: () => _getAccountCall(), icon: const Icon(Icons.generating_tokens_sharp), label: const Text('Get Account')),
                ElevatedButton.icon(
                    onPressed: () => _authenticateCall(),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('Authenticate Client Test')),
                ElevatedButton.icon(
                    onPressed: () => _getUUIDCall(), icon: const Icon(Icons.person_search_outlined), label: const Text('GetUuid Test')),
                ElevatedButton.icon(
                    onPressed: () => _regenerateUUIDCall(),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('RegenerateUuid Client Test')),
                ElevatedButton.icon(
                    onPressed: () => _requestPasswordResetCall(emailController.text),
                    icon: const Icon(Icons.password_outlined),
                    label: const Text('RequestPasswordReset Test')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInCall(email, password) async {
    await Synerise.client.signIn(email, password).catchError((error) {
      final String errorCode = error.code;
      final String errorMessage = error.message;
      print("Error: $errorCode - $errorMessage");
    });
  }

  Future<void> _signOutCall() async {
    await Synerise.client
        .signOut()
        .whenComplete(() => Utils.displaySimpleAlert("signed out", context))
        .catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
  }

  Future<void> _authenticateCall() async {
    ClientAgreements? agreements = ClientAgreements(push: false, rfid: false, wifi: false);
    ClientAttributes? attributes;
    ClientAuthContext clientAuthContext = ClientAuthContext(authId: 'AUTH_ID', agreements: agreements, attributes: attributes);
    Token token = await Synerise.client.retrieveToken().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    String tokenString = token.tokenString;
    IdentityProvider identityProvider = IdentityProvider.oauth;

    final bool result = await Synerise.client.authenticate(clientAuthContext, identityProvider, tokenString).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call: you need to be signed in to authenticate \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (result == true) {
      if (!mounted) return;
      Utils.displaySimpleAlert("authenticate true", context);
    }
  }

  Future<void> _isSignedInCall() async {
    _isSignedInBool = await Synerise.client.isSignedIn().catchError((error) {
          _isSignedInBool = false;
          String errorMessage = Utils.handlePlatformException(error);
          Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
          throw Exception(errorMessage);
    });
  }

  Future<void> _retrieveTokenCall() async {
    Token token = await Synerise.client.retrieveToken().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    String tokenString = token.tokenString;
    DateTime expirationDate = token.expirationDate;
    TokenOrigin? origin = token.origin;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: Column(children: [
            const Text(
              'TokenString',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(tokenString, textScaleFactor: 0.5)),
            const Text(
              'TokenExpirationDate',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(expirationDate.toString(), textScaleFactor: 0.5)),
            const Text(
              'TokenOrigin',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(origin.tokenOrigin, textScaleFactor: 0.5)),
          ])),
        );
      },
    );
  }

  Future<void> _refreshTokenCall() async {
    await Synerise.client.refreshToken().whenComplete(() => Utils.displaySimpleAlert("token refreshed", context)).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
  }

  Future<void> _getAccountCall() async {
    ClientAccountInformation info = await Synerise.client.getAccount().catchError((error) {
      String errorMessage = Utils.handleException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    var email = info.email;
    var uuid = info.uuid;
    var clientId = info.clientId;
    var lastActivity = info.lastActivityDate;
    Utils.displaySimpleAlert("email: $email uuid: $uuid clientId: $clientId lastActivity: $lastActivity", context);
  }

  Future<void> _getUUIDCall() async {
    String uuid = await Synerise.client.getUUID().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("uuid: $uuid", context);
  }

  Future<void> _regenerateUUIDCall() async {
    await Synerise.client.regenerateUUID().whenComplete(() => Utils.displaySimpleAlert("uuid regenerated", context)).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
  }

  Future<void> _requestPasswordResetCall(email) async {
    await Synerise.client.requestPasswordReset(email).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("$email pasword request succes", context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (Center(child: _tempFormBody()));
  }

  @override
  bool get wantKeepAlive => true;
}
