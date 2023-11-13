import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import '../../classes/utils.dart';

class ChangeEmailAndPhone extends StatefulWidget {
  const ChangeEmailAndPhone({super.key});

  @override
  State<ChangeEmailAndPhone> createState() => _ChangeEmailAndPhoneState();
}

class _ChangeEmailAndPhoneState extends State<ChangeEmailAndPhone>
    with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final tokenController = TextEditingController();

  final phoneController = TextEditingController();
  final confirmationCodeController = TextEditingController();

  final updateForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        key: updateForm,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Change Email Request Test")),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Email")),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 5.0),
              ElevatedButton.icon(
                  onPressed: () => _requestEmailChangeCall(
                      emailController.text, passwordController.text),
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Request Email Change')),
              const SizedBox(height: 5.0),
              TextFormField(
                  controller: tokenController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Token")),
              ElevatedButton.icon(
                  onPressed: () =>
                      _confirmEmailChangeCall(tokenController.text),
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm Email Change')),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Change Phone Request Test")),
              TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Phone")),
              ElevatedButton.icon(
                  onPressed: () =>
                      _requestPhoneUpdateCall(phoneController.text),
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Request Phone Change')),
              const SizedBox(height: 5.0),
              TextFormField(
                  controller: confirmationCodeController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirmation Code")),
              ElevatedButton.icon(
                  onPressed: () => _confirmPhoneUpdateCall(
                      phoneController.text, confirmationCodeController.text),
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm Phone Change')),
              const SizedBox(height: 10.0),
            ],
          ),
        )));
  }

  Future<void> _requestEmailChangeCall(email, password) async {
    await Synerise.client
        .requestEmailChange(email, password)
        .catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert(
        "request to change email has been sent succesfully, confirm the token to finish the process",
        context);
  }

  Future<void> _confirmEmailChangeCall(token) async {
    await Synerise.client.confirmEmailChange(token, true).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("email changed succesfully", context);
  }

  Future<void> _requestPhoneUpdateCall(phone) async {
    await Synerise.client.requestPhoneUpdate(phone).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert(
        "request to change phone has been sent succesfully, use the confirmationCode to finish the process",
        context);
  }

  Future<void> _confirmPhoneUpdateCall(phone, confirmationCode) async {
    await Synerise.client
        .confirmPhoneUpdate(phone, confirmationCode, true)
        .catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert(
          "error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("phone changed", context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    tokenController.dispose();
    confirmationCodeController.dispose();
    phoneController.dispose();
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
