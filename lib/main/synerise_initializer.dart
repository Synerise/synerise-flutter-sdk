import 'package:flutter/services.dart';

import 'package:synerise_flutter_sdk/main/dependencies.dart';

class SyneriseInitializer {
  MethodChannel methodChannel = Dependencies.methodChannel;

  String? clientApiKey;
  String? baseUrl;
  bool debugModeEnabled = false;
  bool crashHandlingEnabled = false;

  Function(bool initialized)? completionHandler;

  SyneriseInitializer();

  void setCompletionHandler(Function(bool) completionHandler) {
    this.completionHandler = completionHandler;
  }

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
    if (completionHandler != null) {
      completionHandler!(false);
    }

    final result = await methodChannel.invokeMethod('Synerise/initialize', {
      'initializationParameters': {
        'clientApiKey': clientApiKey,
        'baseUrl': baseUrl,
        'debugModeEnabled': debugModeEnabled,
        'crashHandlingEnabled': crashHandlingEnabled
      }
    });

    if (completionHandler != null) {
      completionHandler!(true);
    }

    return result;
  }
}