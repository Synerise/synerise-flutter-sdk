import 'package:flutter/services.dart';

import './../enums/injector/messaging_service_type.dart';
import './dependencies.dart';

var syneriseInitialized = false;

class SyneriseInitializer {
  MethodChannel methodChannel = Dependencies.methodChannel;

  String? _apiKey;
  String? _baseUrl;
  String? _requestValidationSalt;
  bool _debugModeEnabled = false;
  bool _crashHandlingEnabled = false;
  String _messagingServiceType = MessagingServiceType.gms.name;

  Function(bool initialized)? completionHandler;

  SyneriseInitializer();

  /// This function sets a completion handler function that takes a boolean parameter.
  void setCompletionHandler(Function(bool) completionHandler) {
    this.completionHandler = completionHandler;
  }

  /// The function sets the API key and returns the SyneriseInitializer object.
  ///
  /// Args:
  ///   apiKey (String): The apiKey parameter is a string that represents the API key of the
  /// Synerise client. This key is used to authenticate and authorize the client's access to the
  /// Synerise platform.
  SyneriseInitializer withApiKey(String apiKey) {
    _apiKey = apiKey;
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

  /// The function sets the request validation salt for SyneriseInitializer.
  ///
  /// Args:
  ///   requestValidationSalt (String): This parameter is a string value that is used for request validation in the
  /// SyneriseInitializer class.
  SyneriseInitializer setRequestValidationSalt(String requestValidationSalt) {
    _requestValidationSalt = requestValidationSalt;
    return this;
  }

  /// The function sets the messaging service type.
  ///
  /// Args:
  ///   messagingServiceType (MessagingServiceType): This parameter is an enum containing two values: gms - google mobile services and hms - huawei mobile services.
  ///   Default value is gms.
  ///   Please use huawei mobile services only on huawei devices
  /// SyneriseInitializer class.
  SyneriseInitializer setMessagingServiceType(MessagingServiceType messagingServiceType) {
    _messagingServiceType = messagingServiceType.name;
    return this;
  }

  /// This function initializes a Synerise SDK instance with specified parameters and invokes a
  /// completion handler.
  Future<void> init() async {
    if (syneriseInitialized == true) {
      return;
    }

    if (completionHandler != null) {
      completionHandler!(false);
    }

    final result = await methodChannel.invokeMethod('Synerise/initialize', {
      'initializationParameters': {
        'apiKey': _apiKey,
        'baseUrl': _baseUrl,
        'debugModeEnabled': _debugModeEnabled,
        'crashHandlingEnabled': _crashHandlingEnabled,
        'requestValidationSalt': _requestValidationSalt,
        'messagingServiceType': _messagingServiceType
      }
    });

    if (completionHandler != null) {
      completionHandler!(true);
    }

    syneriseInitialized = true;

    return result;
  }
}
