import 'dart:async';
import 'package:flutter/material.dart';
import '../../classes/utils.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class SimpleAuthentication extends StatefulWidget {
  const SimpleAuthentication({super.key});

  @override
  State<SimpleAuthentication> createState() => _SimpleAuthenticationState();
}

class _SimpleAuthenticationState extends State<SimpleAuthentication> with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final customIDController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final authIDController = TextEditingController();

  final simpleAuthenticationForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: simpleAuthenticationForm,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "email"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: customIDController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "customID"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "First Name"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Last Name"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some value';
                  }
                  return null;
                },
                controller: authIDController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "authID"),
                keyboardType: TextInputType.text,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    if (simpleAuthenticationForm.currentState!.validate()) {
                      _simpleAuthenticationCall(emailController.text, customIDController.text, firstNameController.text,
                          lastNameController.text, authIDController.text);
                    }
                  },
                  icon: const Icon(Icons.person_pin),
                  label: const Text('Simple Authentication')),
              ElevatedButton.icon(
                  onPressed: () => _isSignedInViaSimpleAuthenticationCall(),
                  icon: const Icon(Icons.person_pin_outlined),
                  label: const Text('Is Signed In Via Simple Authentication')),
            ],
          ),
        )));
  }

  Future<void> _simpleAuthenticationCall(String email, String customID, String firstName, String lastName, String authID) async {
    ClientSimpleAuthenticationData data =
        ClientSimpleAuthenticationData(firstName: firstName, lastName: lastName, email: email, customId: customID);
    await Synerise.client.simpleAuthentication(data, authID).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("simple authenticate complete", context);
  }

  Future<void> _isSignedInViaSimpleAuthenticationCall() async {
    bool result = await Synerise.client.isSignedInViaSimpleAuthentication().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (result == true) {
      if (!mounted) return;
      Utils.displaySimpleAlert("simple authentication true", context);
    } else {
      if (!mounted) return;
      Utils.displaySimpleAlert("simple authentication false", context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    customIDController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    authIDController.dispose();
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
