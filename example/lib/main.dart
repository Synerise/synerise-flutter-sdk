import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

import 'package:synerise_flutter_sdk/synerise.dart';
import 'classes/utils.dart';
import 'views/client/client_methods_view.dart';
import 'views/content/content_methods_view.dart';
import 'views/tracker/tracker_methods_view.dart';
import 'views/promotions/promotions_methods_view.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String? firebaseToken;

class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  void initState() {
    initializeSynerise();
    initializeFirebase();
    super.initState();
  }

  Future<void> initializeSynerise() async {
    Synerise.settings.sdk.appGroupIdentifier = "group.com.synerise.sdk.flutter";
    Synerise.settings.sdk.keychainGroupIdentifier =
        "34N2Z22TKH.FlutterKeychainGroup";
    Synerise.settings.injector.automatic = true;

    Synerise.initializer()
        .withClientApiKey(await rootBundle.loadString('lib/api_key.txt'))
        .withDebugModeEnabled(true)
        .init();

    Synerise.injector.listener((listener) {
      listener.onOpenUrl = (url) {
        Utils.displaySimpleAlert(url, context);
      };
      listener.onDeepLink = (deepLink) {
        Utils.displaySimpleAlert(deepLink, context);
      };
    });

    Synerise.injector.bannerListener((listener) {
      listener.onPresent = () {};
      listener.onHide = () {};
    });

    Synerise.injector.walkthroughListener((listener) {
      listener.onLoad = () {};
      listener.onLoadingError = () {};
      listener.onPresent = () {};
      listener.onHide = () {};
    });

    Synerise.injector.inAppMessageListener((listener) {
      listener.onOpenUrl = (data, url) {};
      listener.onDeepLink = (data, deepLink) {};

      listener.onPresent = (data) {};

      listener.onHide = (data) {};

      listener.onCustomAction = (data, name, parameters) {};
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initializeFirebase() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(backgroundHandlerForFCM);

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      FirebaseMessaging.instance.getToken().then((value) {
        if (value != null) {
          Synerise.notifications.registerForNotifications(value, true);
        }
      });
    });
    await FirebaseMessaging.instance.getToken().then((value) {
      if (value != null) {
        Synerise.notifications.registerForNotifications(value, true);
        firebaseToken = value;
      }
    });
    await FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Synerise.notifications.handleNotificationClick(message.toMap());
      }
    });

    FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) async {
      Map<String, dynamic> remoteMessageMap = message.toMap();
      bool isSyneriseNotification =
          await Synerise.notifications.isSyneriseNotification(remoteMessageMap);
      if (isSyneriseNotification) {
        Synerise.notifications.handleNotification(remoteMessageMap);
      } else {
        //custom notification handling
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Synerise.notifications.handleNotificationClick(message.toMap());
    });

    Synerise.notifications.listener((listener) {
      listener.onRegistrationRequired = () {
        Synerise.notifications.registerForNotifications(firebaseToken!, true);
      };
    });
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
                    MaterialPageRoute(
                        builder: (context) => const ContentView()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Tracker Method Test'),
                onPressed: () {
                  final paramMap = <String, Object>{
                    "firstKeyCustomParam": "TEST",
                    "arraytest": [
                      {"test1": "test2"}
                    ]
                  };

                  CustomEvent event = CustomEvent("label", "flutter", paramMap);
                  Synerise.tracker.send(event);
                },
              ),
              ElevatedButton(
                child: const Text('Promotions Method Test'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PromotionsView()),
                  );
                },
              ),
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

class PromotionsView extends StatelessWidget {
  const PromotionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions Module Method Test'),
      ),
      body: const PromotionsMethodsView(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

@pragma('vm:entry-point')
Future<void> backgroundHandlerForFCM(RemoteMessage message) async {
  await Firebase.initializeApp();
  await Synerise.initializer()
      .withClientApiKey(await rootBundle.loadString('lib/api_key.txt'))
      .withDebugModeEnabled(true)
      .init();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // ignore: unused_local_variable
  Map<String, dynamic> remoteMessageMap = message.toMap();
  bool isSyneriseNotification =
      await Synerise.notifications.isSyneriseNotification(remoteMessageMap);
  if (isSyneriseNotification) {
    Synerise.notifications.handleNotification(remoteMessageMap);
  } else {
    developer.log('flutter', name: 'onMessage background');
    //custom notification handling
  }
}
