import 'package:flutter/services.dart';
import 'dependencies.dart';


class SyneriseInitializer {
  MethodChannel methodChannel = Dependencies.methodChannel;

  String? _clientApiKey;
  String? _baseUrl;
  bool _debugModeEnabled = false;
  bool _crashHandlingEnabled = false;

  Function(bool initialized)? completionHandler;

  SyneriseInitializer();

  void setCompletionHandler(Function(bool) completionHandler) {
    this.completionHandler = completionHandler;
  }

  SyneriseInitializer withClientApiKey(String clientApiKey) {
    _clientApiKey = clientApiKey;
    return this;
  }

  SyneriseInitializer withBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  SyneriseInitializer withDebugModeEnabled(bool debugModeEnabled) {
    _debugModeEnabled = debugModeEnabled;
    return this;
  }

  SyneriseInitializer withCrashHandlingEnabled(bool crashHandlingEnabled) {
    _crashHandlingEnabled = crashHandlingEnabled;
    return this;
  }

  Future<void> init() async {
    if (completionHandler != null) {
      completionHandler!(false);
    }

    final result = await methodChannel.invokeMethod('Synerise/initialize', {
      'initializationParameters': {
        'clientApiKey': _clientApiKey,
        'baseUrl': _baseUrl,
        'debugModeEnabled': _debugModeEnabled,
        'crashHandlingEnabled': _crashHandlingEnabled
      }
    });

    if (completionHandler != null) {
      completionHandler!(true);
    }

    return result;
  }
}