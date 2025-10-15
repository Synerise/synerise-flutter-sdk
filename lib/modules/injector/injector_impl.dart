// ignore_for_file: unused_local_variable

import 'package:flutter/services.dart';

import '../base/base_module_method_channel.dart';
import '../base/base_module.dart';
import '../../enums/injector/synerise_source.dart';
import '../../model/in_app/in_app_message_data.dart';
import './injector_methods.dart';

typedef InjectorListenerFunction = void Function(InjectorListener listener);

class InjectorListener {
  void Function(String url, SyneriseSource source)? onOpenUrl;
  void Function(String deepLink, SyneriseSource source)? onDeepLink;

  InjectorListener();
}

typedef InjectorInAppMessageListenerFunction = void Function(InjectorInAppMessageListener listener);

class InjectorInAppMessageListener {
  void Function(InAppMessageData data)? onPresent;
  void Function(InAppMessageData data)? onHide;
  void Function(InAppMessageData data, String url)? onOpenUrl;
  void Function(InAppMessageData data, String deepLink)? onDeepLink;
  void Function(InAppMessageData data, String name, Map<String, String> parameters)? onCustomAction;

  InjectorInAppMessageListener();
}

class InjectorImpl extends BaseModule {
  final InjectorMethods _methods = InjectorMethods();
  InjectorImpl();

  final InjectorListener _listener = InjectorListener();
  final InjectorInAppMessageListener _inAppMessageListener = InjectorInAppMessageListener();

  @override
  void beforeInitialization() async {
    super.beforeInitialization();
    listener((listener) {
      listener.onOpenUrl = (url, source) {
        handleOpenUrlBySDK(url);
      };
      listener.onDeepLink = (deepLink, source) {
        handleDeepLinkBySDK(deepLink);
      };
    });
  }

  /// This function handles method calls for listeners related to opening URLs and deep links.
  void listener(InjectorListenerFunction listenerFunction) {
    listenerFunction(_listener);
  }

  /// This function handles different listener methods for in-app messages in Dart.
  void inAppMessageListener(
      InjectorInAppMessageListenerFunction listenerFunction) {
    listenerFunction(_inAppMessageListener);
  }

  /// This function handles different types of listeners based on the method call received.
  void handleMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];

    if (listenerName == 'InjectorListener') {
      _handleListenerMethod(call);
      return;
    }

    if (listenerName == 'InjectorInAppMessageListener') {
      _handleInAppListenerMethod(call);
      return;
    }
  }

  void _handleListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];
    Map<String, dynamic> arguments = call.arguments != null
        ? Map<String, dynamic>.from(call.arguments)
        : <String, dynamic>{};

    SyneriseSource? source = arguments['source'] != null
        ? SyneriseSource.fromString(arguments['source'])
        : null;
    if (source == null) {
      return;
    }

    if (listenerMethodName == 'onOpenUrl') {
      if (_listener.onOpenUrl != null) {
        String? url = arguments['url'];
        if (url == null) {
          return;
        }

        _listener.onOpenUrl!(url, source);
      }
      return;
    }

    if (listenerMethodName == 'onDeepLink') {
      if (_listener.onDeepLink != null) {
        String? deepLink = arguments['deepLink'];
        if (deepLink == null) {
          return;
        }

        _listener.onDeepLink!(deepLink, source);
      }
      return;
    }
  }

  void _handleInAppListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];

    Map<String, dynamic>? arguments = call.arguments != null
        ? Map<String, dynamic>.from(call.arguments)
        : null;
    if (arguments == null) {
      return;
    }

    Map<String, dynamic>? inAppMessageDataArguments = arguments['data'] != null
        ? Map<String, dynamic>.from(arguments['data'])
        : null;
    if (inAppMessageDataArguments == null) {
      return;
    }

    String campaignHash = inAppMessageDataArguments['campaignHash'];
    String variantIdentifier = inAppMessageDataArguments['variantIdentifier'];
    Map<String, String> additionalParamaters = Map<String, String>.from(
        inAppMessageDataArguments['additionalParameters']);
    bool isTest = inAppMessageDataArguments['isTest'];
    InAppMessageData data = InAppMessageData(
        campaignHash, variantIdentifier, additionalParamaters, isTest);

    if (listenerMethodName == 'onPresent') {
      if (_inAppMessageListener.onPresent != null) {
        _inAppMessageListener.onPresent!(data);
      }
      return;
    }

    if (listenerMethodName == 'onHide') {
      if (_inAppMessageListener.onHide != null) {
        _inAppMessageListener.onHide!(data);
      }
      return;
    }

    if (listenerMethodName == 'onOpenUrl') {
      if (_inAppMessageListener.onOpenUrl != null) {
        String url = call.arguments['url'];
        _inAppMessageListener.onOpenUrl!(data, url);
      }
      return;
    }

    if (listenerMethodName == 'onDeepLink') {
      if (_inAppMessageListener.onDeepLink != null) {
        String deepLink = call.arguments['deepLink'];
        _inAppMessageListener.onDeepLink!(data, deepLink);
      }
      return;
    }

    if (listenerMethodName == 'onCustomAction') {
      if (_inAppMessageListener.onCustomAction != null) {
        String name = call.arguments['name'];
        Map<String, String> parameters =
            Map<String, String>.from(call.arguments['parameters']);
        _inAppMessageListener.onCustomAction!(data, name, parameters);
      }
      return;
    }
  }

  /// This function closes the current in-app message.
  /// Args:
  ///   campaignHash (String): An identifier of the in-app message campaign that is currently opened.
  void closeInAppMessage(String campaignHash) {
    _methods.closeInAppMessage(campaignHash);
  }

  void handleOpenUrlBySDK(String url) {
    _methods.handleOpenUrlBySDK(url);
  }

  void handleDeepLinkBySDK(String deepLink) {
    _methods.handleDeepLinkBySDK(deepLink);
  }
}
