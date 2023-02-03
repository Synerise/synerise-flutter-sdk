import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:synerise_flutter_sdk/main/dependencies.dart';
import 'package:synerise_flutter_sdk/main/synerise_initializer.dart';
import 'package:synerise_flutter_sdk/modules/settings/settings_impl.dart';
import 'package:synerise_flutter_sdk/modules/client/client_impl.dart';
import 'package:synerise_flutter_sdk/modules/tracker/tracker_impl.dart';
import 'package:synerise_flutter_sdk/modules/content/content_impl.dart';

class Synerise {
  // constructor method
  Synerise();

  //modules communication
  static SettingsImpl settings = SettingsImpl();
  static ClientImpl client = ClientImpl();
  static TrackerImpl tracker = TrackerImpl();
  static ContentImpl content = ContentImpl();

  static const methodChannel = Dependencies.methodChannel;

  static SyneriseInitializer initializer() {
    final initializer = SyneriseInitializer();
    initializer.setCompletionHandler((initialized) {
      if (initialized == true) {
        Synerise.settings.afterInitialization();
      } else {
        Synerise.settings.beforeInitialization();
      }
    });
    return initializer;
  }

  static String handlePlatformException(PlatformException error) {
    String? eMsg = error.message;
    String? eDetails = error.details;
    String eCode = error.code;
    if (eDetails != null && eMsg != null) {
      String errorMessage = "$eCode : $eMsg : $eDetails";
      return errorMessage;
    } else {
      String errorMessage = eCode;
      return errorMessage;
    }
  }

  static Future<void> displaySimpleAlert(String text, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(text, textAlign: TextAlign.center),
        );
      },
    );
  }
}
