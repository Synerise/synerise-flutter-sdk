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

  /// This function sets a completion handler function that takes a boolean parameter.
  void setCompletionHandler(Function(bool) completionHandler) {
    this.completionHandler = completionHandler;
  }

  /// The function sets the client API key and returns the SyneriseInitializer object.
  ///
  /// Args:
  ///   clientApiKey (String): The clientApiKey parameter is a string that represents the API key of the
  /// Synerise client. This key is used to authenticate and authorize the client's access to the
  /// Synerise platform.
  SyneriseInitializer withClientApiKey(String clientApiKey) {
    _clientApiKey = clientApiKey;
    return this;
  }

  /// The function sets the base URL for the SyneriseInitializer and returns the instance.
  ///
  /// Args:
  ///   baseUrl (String): The `baseUrl` parameter is a string that represents the base URL of the
  /// Synerise API. It is used to initialize the Synerise SDK with the correct API endpoint.
  SyneriseInitializer withBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  /// This function sets the debug mode for the SyneriseInitializer and returns the instance.
  ///
  /// Args:
  ///   debugModeEnabled (bool): A boolean parameter that determines whether debug mode is enabled or
  /// not. Debug mode is a feature that allows developers to debug and troubleshoot their code by providing
  /// additional information and logging.
  SyneriseInitializer withDebugModeEnabled(bool debugModeEnabled) {
    _debugModeEnabled = debugModeEnabled;
    return this;
  }

  /// This function sets the value of a boolean variable for enabling or disabling crash handling and
  /// returns an instance of the SyneriseInitializer class.
  ///
  /// Args:
  ///   crashHandlingEnabled (bool): A boolean parameter that determines whether or not crash handling
  /// is enabled in the SyneriseInitializer. If set to true, the SyneriseInitializer will handle any
  /// crashes that occur during runtime.
  SyneriseInitializer withCrashHandlingEnabled(bool crashHandlingEnabled) {
    _crashHandlingEnabled = crashHandlingEnabled;
    return this;
  }

  /// This function initializes a Synerise SDK instance with specified parameters and invokes a
  /// completion handler.
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
