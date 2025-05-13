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
            OverflowBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () =>
                        _signInCall(emailController.text, passController.text),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Sign in')),
                ElevatedButton.icon(
                    onPressed: () => _signInConditionallyCall(
                        emailController.text, passController.text),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    label: const Text('Sign in conditionally')),
                ElevatedButton.icon(
                    onPressed: () => _signOutCall(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out')),
                ElevatedButton.icon(
                    onPressed: () => _signOutWithModeCall(),
                    icon: const Icon(Icons.arrow_back_ios),
                    label: const Text('Sign out with mode')),
                ElevatedButton.icon(
                    onPressed: () => {
                          _isSignedInCall().whenComplete(() {
                                if (_isSignedInBool)
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text('Signed In!'),
                                      action: SnackBarAction(
                                        label: 'signedIn',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                    ));
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text('Not signed In!'),
                                      action: SnackBarAction(
                                        label: 'notSignedIn',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                    ));
                                  };
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
                    onPressed: () => _getAccountCall(),
                    icon: const Icon(Icons.generating_tokens_sharp),
                    label: const Text('Get Account')),
                ElevatedButton.icon(
                    onPressed: () => _authenticateCall(),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('Authenticate Client Test')),
                ElevatedButton.icon(
                    onPressed: () => _authenticateConditionallyCall(),
                    icon: const Icon(Icons.person_search_sharp),
                    label:
                        const Text('Authenticate Conditionally Client Test')),
                ElevatedButton.icon(
                    onPressed: () => _getUUIDCall(),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('GetUuid Test')),
                ElevatedButton.icon(
                    onPressed: () => _regenerateUUIDCall(),
                    icon: const Icon(Icons.person_search_outlined),
                    label: const Text('RegenerateUuid Client Test')),
                ElevatedButton.icon(
                    onPressed: () =>
                        _requestPasswordResetCall(emailController.text),
                    icon: const Icon(Icons.password_outlined),
                    label: const Text('RequestPasswordReset Test')),
                ElevatedButton.icon(
                    onPressed: () => _destroySessionCall(),
                    icon: const Icon(Icons.cancel),
                    label: const Text('DestroySessionCall Test')),
                ElevatedButton.icon(
                    onPressed: () => _activateAccountCall(emailController.text),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Activate Account')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInCall(email, password) async {
    await Synerise.client.signIn(email, password, onSuccess: () {
      Utils.displaySimpleAlert("signed in", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _signOutCall() async {
    Synerise.client
        .signOut()
        .whenComplete(() => Utils.displaySimpleAlert("signed out", context));
  }

  Future<void> _authenticateCall() async {
    String tokenString = "";
    ClientAgreements? agreements =
        ClientAgreements(push: false, rfid: false, wifi: false);
    Map<String, Object>? attributes;
    ClientAuthContext clientAuthContext = ClientAuthContext(
        authId: 'AUTH_ID', agreements: agreements, attributes: attributes);
    IdentityProvider identityProvider = IdentityProvider.oauth;

    await Synerise.client.retrieveToken(onSuccess: (Token token) {
      tokenString = token.tokenString;
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });

    await Synerise.client
        .authenticate(clientAuthContext, identityProvider, tokenString,
            onSuccess: (bool result) {
      Utils.displaySimpleAlert("authenticate $result", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _isSignedInCall() async {
    _isSignedInBool = await Synerise.client.isSignedIn();
  }

  Future<void> _retrieveTokenCall() async {
    await Synerise.client.retrieveToken(onSuccess: (Token token) {
      String tokenString = token.tokenString;
      DateTime expirationDate = token.expirationDate;
      TokenOrigin? origin = token.origin;
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
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black)),
                  child: Text(tokenString, textScaleFactor: 0.5)),
              const Text(
                'TokenExpirationDate',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black)),
                  child: Text(expirationDate.toString(), textScaleFactor: 0.5)),
              const Text(
                'TokenOrigin',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black)),
                  child: Text(origin.tokenOrigin, textScaleFactor: 0.5)),
            ])),
          );
        },
      );
    }, onError: ((error) {
      Utils.displaySimpleAlert(error.message, context);
    }));
  }

  Future<void> _refreshTokenCall() async {
    await Synerise.client.refreshToken(onSuccess: () {
      Utils.displaySimpleAlert("Token refresh success", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _getAccountCall() async {
    await Synerise.client.getAccount(
        onSuccess: (ClientAccountInformation result) {
      String email = result.email;
      String uuid = result.uuid;
      int clientId = result.clientId;
      DateTime? lastActivity = result.lastActivityDate;
      Utils.displaySimpleAlert(
          "email: $email uuid: $uuid clientId: $clientId lastActivity: $lastActivity",
          context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _getUUIDCall() async {
    await Synerise.client
        .getUUID()
        .then((result) => {Utils.displaySimpleAlert("uuid: $result", context)});
  }

  Future<void> _regenerateUUIDCall() async {
    await Synerise.client
        .regenerateUUID()
        .then((result) => {Utils.displaySimpleAlert("uuid: $result", context)});
  }

  Future<void> _requestPasswordResetCall(email) async {
    await Synerise.client.requestPasswordReset(email, onSuccess: () {
      Utils.displaySimpleAlert("$email pasword request success", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _destroySessionCall() async {
    await Synerise.client.destroySession(onSuccess: () {
      Utils.displaySimpleAlert("session destroyed", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _activateAccountCall(email) async {
    await Synerise.client.requestAccountActivation(email, onSuccess: () {
      Utils.displaySimpleAlert("account activated", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _authenticateConditionallyCall() async {
    String tokenString = "tokenString";
    await Synerise.client.retrieveToken(onSuccess: (Token token) {
      token = token;
      tokenString = token.tokenString;
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
    IdentityProvider identityProvider = IdentityProvider.oauth;

    await Synerise.client
        .authenticateConditionally(identityProvider, tokenString,
            onSuccess: (ClientConditionalAuthResult result) {
      Utils.displaySimpleAlert(result.asMap().toString(), context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _signInConditionallyCall(email, password) async {
    await Synerise.client.signInConditionally(email, password,
        onSuccess: (ClientConditionalAuthResult result) {
      Utils.displaySimpleAlert(result.asMap().toString(), context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  Future<void> _signOutWithModeCall() async {
    ClientSignOutMode mode = ClientSignOutMode.signOutWithSessionDestroy;
    bool fromAllDevices = true;
    await Synerise.client.signOutWithMode(mode, fromAllDevices, onSuccess: () {
      Utils.displaySimpleAlert("signed out with mode", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
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
