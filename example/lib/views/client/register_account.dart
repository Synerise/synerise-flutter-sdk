import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final registerForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        //autovalidate: true,
        key: registerForm,
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
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10.0),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton.icon(
                      onPressed: () => _registerAccountCall(emailController.text, passwordController.text),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Register')),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _registerAccountCall(email, password) async {
    ClientAccountRegisterContext clientAccountRegisterContext = ClientAccountRegisterContext(email: email, password: password);

    await Synerise.client.registerAccount(clientAccountRegisterContext).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("register call failed: $error"),
          );
        },
      );
      throw Exception('Failed to call native register method: $error');
    }).then(showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("$email account created succesfully"),
        );
      },
    ) as FutureOr Function(void value));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
