// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:synerise_flutter_sdk/enums/injector/messaging_service_type.dart';
import 'dart:async';

import 'package:synerise_flutter_sdk/synerise.dart';
import 'classes/utils.dart';
import 'views/client/client_methods_view.dart';
import 'views/content/content_methods_view.dart';
import 'views/promotions/promotions_methods_view.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String? firebaseToken;
String? currentInAppMessageCampaignHash;

class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  void initState() {
    initializeSynerise();
    setupNotifications();
    checkForInitialNotificationMessage();

    super.initState();
  }

  Future<void> initializeSynerise() async {
    Synerise.settings.sdk.localizable = {
      LocalizableKey.localizableStringKeyOk: "OK!",
      LocalizableKey.localizableStringKeyCancel: "CANCEL!"
    };

    Synerise.settings.sdk.appGroupIdentifier =
        "group.com.synerise.sdk.sample-flutter";
    Synerise.settings.sdk.keychainGroupIdentifier =
        "34N2Z22TKH.FlutterKeychainGroup";
    Synerise.settings.tracker.minBatchSize = 30;
    Synerise.settings.tracker.autoFlushTimeout = 20.0;
    Synerise.settings.tracker.eventsTriggeringFlush = ["flutter.test"];

    Synerise.initializer()
        .withApiKey(await rootBundle.loadString('lib/api_key.txt'))
        .withBaseUrl("https://api.snrapi.com")
        .withDebugModeEnabled(true)
        .setInitialDoNotTrack(true)
        .setMessagingServiceType(MessagingServiceType.gms)
        .init();

    Synerise.notifications.listener((listener) {
      listener.onRegistrationRequired = () {
        Synerise.notifications.registerForNotifications(
          firebaseToken!,
          mobileAgreement: true,
          onSuccess: () {},
          onError: (error) {},
        );
      };
    });

    Synerise.injector.listener((listener) {
      listener.onOpenUrl = (url, source) {
        Utils.displaySimpleAlert(url + " " + source.toString(), context);
      };
      listener.onDeepLink = (deepLink, source) {
        Utils.displaySimpleAlert(deepLink + " " + source.toString(), context);
      };
    });

    Synerise.injector.inAppMessageListener((listener) {
      listener.onOpenUrl = (data, url) {};
      listener.onDeepLink = (data, deepLink) {};

      listener.onPresent = (data) {
        currentInAppMessageCampaignHash = data.campaignHash;
      };

      listener.onHide = (data) {};

      listener.onCustomAction = (data, name, parameters) {};
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setupNotifications() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandlerForFCM);

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

    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        firebaseToken = token;
        Synerise.notifications.registerForNotifications(
          firebaseToken!,
          mobileAgreement: true,
          onSuccess: () {},
          onError: (error) {},
        );
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      FirebaseMessaging.instance.getToken().then((token) {
        if (token != null) {
          firebaseToken = token;
          Synerise.notifications.registerForNotifications(
            firebaseToken!,
            mobileAgreement: true,
            onSuccess: () {},
            onError: (error) {},
          );
        }
      });
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Map remoteMessageMap = message.toMap();
      bool isSyneriseNotification =
          await Synerise.notifications.isSyneriseNotification(remoteMessageMap);
      if (isSyneriseNotification == true) {
        Synerise.notifications.handleNotification(remoteMessageMap);
        bool isSyneriseNotificationEncrypted = await Synerise.notifications
            .isNotificationEncrypted(remoteMessageMap);
        if (isSyneriseNotificationEncrypted) {
          Map decryptedPayload = await Synerise.notifications
              .decryptNotification(remoteMessageMap);
          developer.log(decryptedPayload.toString());
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Map messageMap = message.toMap();
      bool isSyneriseNotification =
          await Synerise.notifications.isSyneriseNotification(messageMap);
      if (isSyneriseNotification == true) {
        Synerise.notifications.handleNotificationClick(messageMap);
      }
    });
  }

  Future<void> checkForInitialNotificationMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Map messageMap = message.toMap();
      bool isSyneriseNotification =
          await Synerise.notifications.isSyneriseNotification(messageMap);
      if (isSyneriseNotification == true) {
        Synerise.notifications.handleNotificationClick(messageMap);
      }
    }
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

                  CustomEvent event = CustomEvent("label", "flutter.test", paramMap);
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
              ElevatedButton(
                child: const Text('Change Do Not Track Settings'),
                onPressed: () {
                  Synerise.settings.sdk.doNotTrack = !Synerise.settings.sdk.doNotTrack;
                },
              ),
              ElevatedButton(
                child: const Text('Custom Method Test'),
                onPressed: () {
                  final config = InitializationConfig(requestValidationSalt: "qlksldii");
                  Synerise.changeApiKey("6f5b279f-b148-a663-ea89-dab880e1a7ef");
                },
              ),
              ElevatedButton(
                child: const Text('Injector.closeInAppMessage'),
                onPressed: () {
                  if (currentInAppMessageCampaignHash != null) {
                    Synerise.injector.closeInAppMessage(currentInAppMessageCampaignHash!);
                  }
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
        .withApiKey(await rootBundle.loadString('lib/api_key.txt'))
        .withBaseUrl("https://api.snrapi.com")
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
    bool isSyneriseNotificationEncrypted =
        await Synerise.notifications.isNotificationEncrypted(remoteMessageMap);
    if (isSyneriseNotificationEncrypted) {
      Map decryptedPayload =
          await Synerise.notifications.decryptNotification(remoteMessageMap);
      developer.log(decryptedPayload.toString());
    } else {
      //custom handling
    }
  } else {
    developer.log('flutter', name: 'onMessage background');
    //custom notification handling
  }
}