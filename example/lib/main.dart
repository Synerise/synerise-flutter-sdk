import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';
import 'package:synerise_flutter_sdk_example/views/client/client_methods_view.dart';
import 'package:synerise_flutter_sdk_example/views/content/content_methods_view.dart';
import 'package:synerise_flutter_sdk_example/views/tracker/tracker_methods_view.dart';
import 'dart:developer' as developer;
import 'views/promotions/promotions_methods_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String? firebaseToken;

/// initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
    Synerise.settings.injector.automatic = true;
    Synerise.initializer().withClientApiKey("YOUR_PROFILE_API_KEY").withBaseUrl("https://api.snrapi.com").withDebugModeEnabled(true).init();

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

      listener.onPresent = (data) {
        Utils.displaySimpleAlert(data.campaignHash, context);
      };

      listener.onHide = (data) {
        Utils.displaySimpleAlert(data.campaignHash, context);
      };

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

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
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
    ) {
      Synerise.notifications.handleNotification(message.toMap());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Synerise.notifications.handleNotificationClick(message.toMap());
    });

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'synerise-4-300',
      'test-channel-noti',
      importance: Importance.max,
    );

    AndroidNotificationChannel channel2 = const AndroidNotificationChannel(
      'synerise-3-300',
      'test-default-channel-noti',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel2);

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
                    MaterialPageRoute(builder: (context) => const ContentView()),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Tracker Method Test'),
                onPressed: () {
                  final paramMap = <String, String>{"firstKeyCustomParam": "TEST"};
                  CustomEvent event = CustomEvent("label", "flutter", paramMap);
                  Synerise.tracker.send(event);
                },
              ),
              ElevatedButton(
                child: const Text('Promotions Method Test'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PromotionsView()),
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
      .withClientApiKey("YOUR_PROFILE_API_KEY")
      .withBaseUrl("https://api.snrapi.com")
      .withDebugModeEnabled(true)
      .init();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // ignore: unused_local_variable
  bool isPushSynerise = await Synerise.notifications.handleNotification(message.toMap());
  developer.log('flutter', name: 'onMessage background');
}
