// ignore_for_file: unused_local_variable

import 'dart:collection';
import 'package:flutter/services.dart';

import '../base/base_module.dart';
import 'injector_methods.dart';
import '../../model/in_app/in_app_message_data.dart';

typedef InjectorListenerFunction = void Function(InjectorListener listener);

class InjectorListener {
  void Function(String url)? onOpenUrl;
  void Function(String deepLink)? onDeepLink;

  InjectorListener();
}

typedef InjectorBannerListenerFunction = void Function(InjectorBannerListener listener);

class InjectorBannerListener {
  void Function()? onPresent;
  void Function()? onHide;

  InjectorBannerListener();
}

typedef InjectorWalkthroughListenerFunction = void Function(InjectorWalkthroughListener listener);

class InjectorWalkthroughListener {
  void Function()? onLoad;
  void Function()? onLoadingError;
  void Function()? onPresent;
  void Function()? onHide;

  InjectorWalkthroughListener();
}

typedef InjectorInAppMessageListenerFunction = void Function(InjectorInAppMessageListener listener);

class InjectorInAppMessageListener {
  void Function(InAppMessageData data)? onPresent;
  void Function(InAppMessageData data)? onHide;
  void Function(InAppMessageData data, String url)? onOpenUrl;
  void Function(InAppMessageData data, String deepLink)? onDeepLink;
  void Function(InAppMessageData data, String name, HashMap<String, String> parameters)? onCustomAction;

  InjectorInAppMessageListener();
}

class InjectorImpl extends BaseModule {
  final InjectorMethods _methods = InjectorMethods();
  InjectorImpl();

  final InjectorListener _listener = InjectorListener();
  final InjectorBannerListener _bannerListener = InjectorBannerListener();
  final InjectorWalkthroughListener _walkthroughListener = InjectorWalkthroughListener();
  final InjectorInAppMessageListener _inAppMessageListener = InjectorInAppMessageListener();

  void listener(InjectorListenerFunction listenerFunction) {
    listenerFunction(_listener);
  }

  void bannerListener(InjectorBannerListenerFunction listenerFunction) {
    listenerFunction(_bannerListener);
  }

  void walkthroughListener(InjectorWalkthroughListenerFunction listenerFunction) {
    listenerFunction(_walkthroughListener);
  }
  
  void inAppMessageListener(InjectorInAppMessageListenerFunction listenerFunction) {
    listenerFunction(_inAppMessageListener);
  }

  void handleMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
 
    if (listenerName == 'InjectorListener') {
      _handleListenerMethod(call);
      return;
    }

    if (listenerName == 'InjectorBannerListener') {
      _handleBannerListenerMethod(call);
      return;
    }

    if (listenerName == 'InjectorWalkthroughListener') {
      _handleWalkthroughListenerMethod(call);
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
    Map<String, dynamic> arguments = call.arguments != null ? Map<String, dynamic>.from(call.arguments) : <String, dynamic>{};

    if (listenerMethodName == 'onOpenUrl') {
      if (_listener.onOpenUrl != null) {
        String? url = arguments['url'];
        if (url == null) {
          return;
        }

        _listener.onOpenUrl!(url);
      }
      return;
    }

    if (listenerMethodName == 'onDeepLink') {
      if (_listener.onDeepLink != null) {
        String? deepLink = arguments['deepLink'];
        if (deepLink == null) {
          return;
        }
        _listener.onDeepLink!(deepLink);
      }
      return;
    }
  }

  void _handleBannerListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];
    
    if (listenerMethodName == 'onPresent') {
      if (_bannerListener.onPresent != null) {
        _bannerListener.onPresent!();
      }
      return;
    }

    if (listenerMethodName == 'onHide') {
      if (_bannerListener.onHide != null) {
        _bannerListener.onHide!();
      }
      return;
    }
  }

  void _handleWalkthroughListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];

    if (listenerMethodName == 'onLoad') {
      if (_walkthroughListener.onLoad != null) {
        _walkthroughListener.onLoad!();
      }
      return;
    }

    if (listenerMethodName == 'onLoadingError') {
      if (_walkthroughListener.onLoadingError != null) {
        _walkthroughListener.onLoadingError!();
      }
      return;
    }

    if (listenerMethodName == 'onPresent') {
      if (_walkthroughListener.onPresent != null) {
        _walkthroughListener.onPresent!();
      }
      return;
    }

    if (listenerMethodName == 'onHide') {
      if (_walkthroughListener.onHide != null) {
        _walkthroughListener.onHide!();
      }
      return;
    }
  }

  void _handleInAppListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];

    Map<String, dynamic>? arguments = call.arguments != null ? Map<String, dynamic>.from(call.arguments) : null;
    if (arguments == null) {
      return;
    }

    Map<String, dynamic>? inAppMessageDataArguments = arguments['data'] != null ? Map<String, dynamic>.from(arguments['data']) : null;
    if (inAppMessageDataArguments == null) {
      return;
    }

    String campaignHash = inAppMessageDataArguments['campaignHash'];
    String variantIdentifier = inAppMessageDataArguments['variantIdentifier'];
    Map<String, String> additionalParamaters = Map<String, String>.from(inAppMessageDataArguments['additionalParameters']);
    bool isTest =  inAppMessageDataArguments['isTest'];
    InAppMessageData data = InAppMessageData(campaignHash, variantIdentifier, additionalParamaters, isTest);

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
        HashMap<String, String> parameters = call.arguments['parameters'];
        _inAppMessageListener.onCustomAction!(data, name, parameters);
      }
      return;
    }
  }

  void getWalkthrough() {
    _methods.getWalkthrough();
  }

  void showWalkthrough() {
    _methods.showWalkthrough();
  }

  Future<bool> isWalkthroughLoaded() async {
    return _methods.isWalkthroughLoaded();
  }

  Future<bool> isLoadedWalkthroughUnique() async {
    return _methods.isLoadedWalkthroughUnique();
  }
}