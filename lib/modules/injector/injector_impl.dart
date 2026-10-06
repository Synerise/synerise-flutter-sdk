// ignore_for_file: unused_local_variable

import 'dart:collection';

import 'package:flutter/services.dart';

import '../base/base_module.dart';
import '../../enums/injector/synerise_source.dart';
import './injector_methods.dart';
import './inapp/in_app_impl.dart';

export './inapp/in_app_impl.dart'
    show
        InjectorInAppMessageListener,
        InjectorInAppMessageListenerFunction,
        InjectorInlineInAppMessageListener,
        InjectorInlineInAppMessageListenerFunction;

typedef InjectorListenerFunction = void Function(InjectorListener listener);

class InjectorListener {
  void Function(String url, SyneriseSource source)? onOpenUrl;
  void Function(String deepLink, SyneriseSource source)? onDeepLink;

  InjectorListener();
}

class _SyncedInAppContext extends MapBase<String, dynamic> {
  final Map<String, dynamic> _target;
  final void Function() _onChange;

  _SyncedInAppContext(this._target, this._onChange);

  @override
  dynamic operator [](Object? key) => _target[key];

  @override
  void operator []=(String key, dynamic value) {
    _target[key] = value;
    _onChange();
  }

  @override
  void clear() {
    _target.clear();
    _onChange();
  }

  @override
  Iterable<String> get keys => _target.keys;

  @override
  dynamic remove(Object? key) {
    final value = _target.remove(key);
    _onChange();
    return value;
  }
}

class InjectorImpl extends BaseModule {
  final InjectorMethods _methods = InjectorMethods();
  final InAppImpl _inApp = InAppImpl();
  InjectorImpl();

  final InjectorListener _listener = InjectorListener();

  final Map<String, dynamic> _inAppContextTarget = {};
  late final Map<String, dynamic> inAppContext = _SyncedInAppContext(_inAppContextTarget, _pushInAppContext);

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
    _inApp.inAppMessageListener(listenerFunction);
  }

  /// This function registers callbacks for inline in-app messages and enables the native
  /// global inline in-app listener.
  void inlineInAppMessageListener(
      InjectorInlineInAppMessageListenerFunction listenerFunction) {
    _inApp.inlineInAppMessageListener(listenerFunction);
  }

  /// This function removes the native global inline in-app listener.
  void removeInlineInAppListener() {
    _inApp.removeInlineInAppListener();
  }

  /// This function handles different types of listeners based on the method call received.
  void handleMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];

    if (listenerName == 'InjectorListener') {
      _handleListenerMethod(call);
      return;
    }

    if (_inApp.handlesListener(listenerName)) {
      _inApp.handleMethod(call);
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

  /// This function notifies current in-app messages that context from the app was changed.
  void notifyInAppContextChange() {
    _methods.notifyInAppContextChange();
  }

  void _pushInAppContext() {
    _methods.setInAppContext(Map<String, dynamic>.from(_inAppContextTarget));
  }

  /// This function closes the current in-app message.
  /// Args:
  ///   campaignHash (String): An identifier of the in-app message campaign that is currently opened.
  void closeInAppMessage(String campaignHash) {
    _inApp.closeInAppMessage(campaignHash);
  }

  void handleOpenUrlBySDK(String url) {
    _methods.handleOpenUrlBySDK(url);
  }

  void handleDeepLinkBySDK(String deepLink) {
    _methods.handleDeepLinkBySDK(deepLink);
  }
}
