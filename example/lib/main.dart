import 'package:flutter/material.dart';
import 'dart:async';

import 'package:synerise_flutter_sdk/synerise.dart';
import 'package:synerise_flutter_sdk_example/views/client/client_methods_view.dart';
import 'package:synerise_flutter_sdk_example/views/content/content_methods_view.dart';
import 'package:synerise_flutter_sdk_example/views/tracker/tracker_methods_view.dart';


class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {

  @override
  void initState() {
    initializeSynerise();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeSynerise() async {
    Synerise.settings.sdk.enabled = true;

    Synerise.initializer()
        .withClientApiKey("YOUR_CLIENT_API_KEY")
        .withBaseUrl("https://YOUR_BASE_URI.com")
        .withDebugModeEnabled(true)
        .init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Synerise Flutter SDK Test'),
            ),
            body: Center(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
              ElevatedButton(
                child: const Text('Client Method Test'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClientView()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Content Method Test'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContentView()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Tracker Method Test'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrackerView()),
                  );
                },
              )
            ])))));
  }
}

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Module Method Test'),
      ),
      body: const Center(
        child: ClientMethodsView(),
      ),
    );
  }
}


class ContentView extends StatelessWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Module Method Test'),
      ),
      body: const ContentMethodsView(),
    );
  }
}

class TrackerView extends StatelessWidget {
  const TrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker Module Method Test'),
      ),
      body: const TrackerMethodsView(),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synerise Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitialView(),
    );
  }
}
