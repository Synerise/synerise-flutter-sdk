import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';

class TrackerMethodsView extends StatefulWidget {
  const TrackerMethodsView({super.key});

  @override
  State<TrackerMethodsView> createState() => _TrackerMethodsViewState();
}

class _TrackerMethodsViewState extends State<TrackerMethodsView> with AutomaticKeepAliveClientMixin {
  final trackerCustomEventForm = GlobalKey<FormState>();
  final labelController = TextEditingController();
  final actionController = TextEditingController();
  final customIdentifierController = TextEditingController();
  final firstKeyCustomParamController = TextEditingController();
  final firstValueCustomParamController = TextEditingController();
  final secondKeyCustomParamController = TextEditingController();
  final secondValueCustomParamController = TextEditingController();

  _tempFormBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          //getDocument
          Form(
              key: trackerCustomEventForm,
              child: Column(children: [
                const SizedBox(height: 20),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: labelController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "label"),
                      keyboardType: TextInputType.text,
                    )),
                const SizedBox(height: 20),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: actionController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "action"),
                      keyboardType: TextInputType.text,
                    )),
                const SizedBox(height: 20),
                SizedBox(
                    width: 350,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: customIdentifierController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "customIdentifier"),
                      keyboardType: TextInputType.text,
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: firstKeyCustomParamController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "first param key"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: firstValueCustomParamController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "first param value"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: secondKeyCustomParamController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "second param key"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: secondValueCustomParamController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "second param value"),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                    onPressed: () {
                      if (trackerCustomEventForm.currentState!.validate()) {
                        _trackerCall(
                            labelController.text,
                            actionController.text,
                            customIdentifierController.text,
                            firstKeyCustomParamController.text,
                            firstValueCustomParamController.text,
                            secondKeyCustomParamController.text,
                            secondValueCustomParamController.text);
                      }
                    },
                    icon: const Icon(Icons.event),
                    label: const Text('TrackerMethodsView Custom Event test')),
                const SizedBox(height: 20),
              ]))
        ]));
  }

  Future<void> _trackerCall(String label, String action, String customIdentifier, String firstKeyCustomParam, String firstValueCustomParam,
      String secondKeyCustomParam, String secondValueCustomParam) async {
    final paramMap = <String, String>{firstKeyCustomParam: firstValueCustomParam, secondKeyCustomParam: secondValueCustomParam};
    CustomEvent event = CustomEvent(label, action, paramMap);
    Synerise.tracker.send(event);
    Synerise.tracker.setCustomIdentifier(customIdentifier);
    Synerise.tracker.flush();
    Utils.displaySimpleAlert("$event succesfully sent", context);
  }

  @override
  void dispose() {
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
