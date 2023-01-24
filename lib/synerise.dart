import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:synerise_flutter_sdk/modules/client/client_impl.dart';

class SyneriseInitializer {
  MethodChannel methodChannel;

  String? clientApiKey;
  String? baseUrl;
  bool debugModeEnabled = false;
  bool crashHandlingEnabled = false;

  SyneriseInitializer(this.methodChannel);

  SyneriseInitializer withClientApiKey(String clientApiKey) {
    this.clientApiKey = clientApiKey;
    return this;
  }

  SyneriseInitializer withBaseUrl(String baseUrl) {
    this.baseUrl = baseUrl;
    return this;
  }

  SyneriseInitializer withDebugModeEnabled(bool debugModeEnabled) {
    this.debugModeEnabled = debugModeEnabled;
    return this;
  }

  SyneriseInitializer withCrashHandlingEnabled(bool crashHandlingEnabled) {
    this.crashHandlingEnabled = crashHandlingEnabled;
    return this;
  }

  Future<void> init() async {
    return await methodChannel.invokeMethod('Synerise/initialize', {
      'preinitializationSettings': {

      },
      'initializationParameters': {
        'clientApiKey': clientApiKey,
        'baseUrl': baseUrl,
        'debugModeEnabled': debugModeEnabled,
        'crashHandlingEnabled': crashHandlingEnabled
      }
    });
  }
}

class Synerise {
  // constructor method
  Synerise();

  //modules communication
  static get client => ClientImpl();

  static const methodChannel = MethodChannel('synerise_flutter_sdk');

  static SyneriseInitializer initializer() {
    return SyneriseInitializer(Synerise.methodChannel);
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

  static void displaySimpleAlert(String text, BuildContext context) {
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
