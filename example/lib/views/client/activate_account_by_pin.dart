import 'dart:async';
import 'package:flutter/material.dart';
import '../../classes/utils.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class ActivateAccountByPin extends StatefulWidget {
  const ActivateAccountByPin({super.key});

  @override
  State<ActivateAccountByPin> createState() => _ActivateAccountByPinState();
}

class _ActivateAccountByPinState extends State<ActivateAccountByPin> with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final pinCodeController = TextEditingController();

  final updateForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        key: updateForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Email"),
                        keyboardType: TextInputType.text,
                      ))),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: pinCodeController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "PinCode"),
                      ))),
              ElevatedButton.icon(
                  onPressed: () => _requestAccountActivationByPinCall(emailController.text),
                  icon: const Icon(Icons.pin),
                  label: const Text('Request account activation by pin')),
              ElevatedButton.icon(
                  onPressed: () => _confirmAccountActivationByPin(emailController.text, pinCodeController.text),
                  icon: const Icon(Icons.check),
                  label: const Text('Confirm account activation by pin')),
            ],
          ),
        ));
  }

  Future<void> _confirmAccountActivationByPin(email, pinCode) async {
    await Synerise.client.confirmAccountActivationByPin(email, pinCode).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("account activated succcesfully", context);
  }

  Future<void> _requestAccountActivationByPinCall(email) async {
    await Synerise.client.requestAccountActivationByPin(email).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert("account activation by pin request sent", context);
  }

  @override
  void dispose() {
    emailController.dispose();
    pinCodeController.dispose();
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
