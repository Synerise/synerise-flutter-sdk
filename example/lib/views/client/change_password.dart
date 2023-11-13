import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with AutomaticKeepAliveClientMixin {
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  final updateForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        //autovalidate: true,
        key: updateForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                controller: oldPasswordController,
                decoration: const InputDecoration(labelText: "Old Password"),
                obscureText: true,
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
                      onPressed: () => _changePasswordCall(
                          oldPasswordController.text, passwordController.text),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Change Password')),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _changePasswordCall(oldPassword, password) async {
    await Synerise.client
        .changePassword(oldPassword, password)
        .catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("password change call failed: $error"),
          );
        },
      );
      throw Exception('Failed to call native update method: $error');
    }).then(showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Text("password changed  succesfully"),
        );
      },
    ) as FutureOr Function(void value));
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
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
