import 'dart:async';
import 'package:flutter/material.dart';
import '../../classes/utils.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class RegenerateUUIDWithClientIdentifier extends StatefulWidget {
  const RegenerateUUIDWithClientIdentifier({super.key});

  @override
  State<RegenerateUUIDWithClientIdentifier> createState() => _RegenerateUUIDWithClientIdentifierState();
}

class _RegenerateUUIDWithClientIdentifierState extends State<RegenerateUUIDWithClientIdentifier> with AutomaticKeepAliveClientMixin {
  final clientIdentifierController = TextEditingController();

  final regenerateUUIDWithClientIdentifierForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: regenerateUUIDWithClientIdentifierForm,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        controller: clientIdentifierController,
                        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "clientIdentifier"),
                        keyboardType: TextInputType.text,
                      ))),
              ElevatedButton.icon(
                  onPressed: () {
                    if (regenerateUUIDWithClientIdentifierForm.currentState!.validate()) {
                      _regenerateUUIDWithClientIdentifierCall(clientIdentifierController.text);
                    }
                  },
                  icon: const Icon(Icons.pin),
                  label: const Text('regenerateUUID With Client Identifier')),
            ],
          ),
        ));
  }

  Future<void> _regenerateUUIDWithClientIdentifierCall(String clientIdentifier) async {
    final bool result = await Synerise.client.regenerateUUIDWithClientIdentifier(clientIdentifier).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (result == true) {
      if (!mounted) return;
      Utils.displaySimpleAlert("regenerateUUIDWithClientIdentifier succcesful", context);
    } else {
      if (!mounted) return;
      Utils.displaySimpleAlert("regenerateUUIDWithClientIdentifier failed, result false", context);
    }
  }

  @override
  void dispose() {
    clientIdentifierController.dispose();
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
