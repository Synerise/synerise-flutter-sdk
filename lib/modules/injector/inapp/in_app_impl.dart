// ignore_for_file: unused_local_variable

import 'package:flutter/services.dart';

import '../../base/base_module_method_channel.dart';
import '../../../model/in_app/in_app_message_data.dart';
import '../../../model/in_app/inline_in_app_message_data.dart';
import '../../../model/in_app/in_app_custom_method_completion.dart';
import './inline_in_app_view.dart';

typedef InjectorInAppMessageListenerFunction = void Function(
    InjectorInAppMessageListener listener);

class InjectorInAppMessageListener {
  void Function(InAppMessageData data)? onPresent;
  void Function(InAppMessageData data)? onHide;
  void Function(InAppMessageData data, String url)? onOpenUrl;
  void Function(InAppMessageData data, String deepLink)? onDeepLink;
  void Function(InAppMessageData data, String name, Map<String, String> parameters)? onCustomAction;
  void Function(InAppMessageData data, String name,
      Map<String, dynamic> parameters,
      InAppCustomMethodCompletion completion)? onCustomMethod;

  InjectorInAppMessageListener();
}

typedef InjectorInlineInAppMessageListenerFunction = void Function(
    InjectorInlineInAppMessageListener listener);

class InjectorInlineInAppMessageListener {
  void Function(InlineInAppView view, InlineInAppMessageData data)?
      onInlineInAppAvailable;
  void Function(InlineInAppMessageData data, String url)? onOpenUrl;
  void Function(InlineInAppMessageData data, String deepLink)? onDeepLink;
  void Function(InlineInAppMessageData data, String name,
      Map<String, dynamic> parameters)? onCustomAction;
  void Function(InlineInAppMessageData data, String name,
      Map<String, dynamic> parameters,
      InAppCustomMethodCompletion completion)? onCustomMethod;

  InjectorInlineInAppMessageListener();
}

class InAppMethods extends BaseMethodChannel {
  Future<void> closeInAppMessage(String campaignHash) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/closeInAppMessage', parameters: campaignHash);
  }

  Future<void> setInlineInAppListenerEnabled() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/setInlineInAppListenerEnabled');
  }

  Future<void> removeInlineInAppListener() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/removeInlineInAppListener');
  }

  Future<void> resolveInAppCustomMethod(
      String callId, bool success, Object? result, String? error) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<void>(
        'Injector/resolveInAppCustomMethod',
        parameters: <String, dynamic>{
          'callId': callId,
          'success': success,
          'result': result,
          'error': error,
        });
  }

  Future<void> resolveInlineCustomMethod(String callId, bool success,
      Map<String, dynamic>? result, String? error) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<void>(
        'Injector/resolveInlineCustomMethod',
        parameters: <String, dynamic>{
          'callId': callId,
          'success': success,
          'result': result,
          'error': error,
        });
  }
}

/// Owns the in-app messaging bridge (overlay + inline). Reached through `InjectorImpl`, which keeps
/// the public API and delegates here; the native wire protocol stays under the `Injector` namespace.
class InAppImpl {
  final InAppMethods _methods = InAppMethods();

  final InjectorInAppMessageListener _inAppMessageListener = InjectorInAppMessageListener();
  final InjectorInlineInAppMessageListener _inlineInAppMessageListener =
      InjectorInlineInAppMessageListener();

  void inAppMessageListener(
      InjectorInAppMessageListenerFunction listenerFunction) {
    listenerFunction(_inAppMessageListener);
  }

  void inlineInAppMessageListener(
      InjectorInlineInAppMessageListenerFunction listenerFunction) {
    listenerFunction(_inlineInAppMessageListener);
    _methods.setInlineInAppListenerEnabled();
  }

  void removeInlineInAppListener() {
    _methods.removeInlineInAppListener();
  }

  void closeInAppMessage(String campaignHash) {
    _methods.closeInAppMessage(campaignHash);
  }

  bool handlesListener(String listenerName) {
    return listenerName == 'InjectorInAppMessageListener' ||
        listenerName == 'InjectorInlineInAppMessageListener';
  }

  void handleMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];

    if (listenerName == 'InjectorInAppMessageListener') {
      _handleInAppListenerMethod(call);
      return;
    }

    if (listenerName == 'InjectorInlineInAppMessageListener') {
      _handleInlineInAppListenerMethod(call);
      return;
    }
  }

  void _handleInAppListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
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

    if (listenerMethodName == 'onCustomMethod') {
      String callId = arguments['callId'];
      String name = arguments['name'];
      Map<String, dynamic> parameters = arguments['parameters'] != null
          ? Map<String, dynamic>.from(arguments['parameters'])
          : <String, dynamic>{};

      InAppCustomMethodCompletion completion = InAppCustomMethodCompletion(
        (result) => _methods.resolveInAppCustomMethod(callId, true, result, null),
        (errorMessage) =>
            _methods.resolveInAppCustomMethod(callId, false, null, errorMessage),
      );

      final onCustomMethod = _inAppMessageListener.onCustomMethod;
      if (onCustomMethod != null) {
        onCustomMethod(data, name, parameters, completion);
      } else {
        completion.failure(
            "An error has occurred (the listener method `onCustomMethod(data, name, parameters, completion:)` is not implemented).");
      }
      return;
    }
  }

  void _handleInlineInAppListenerMethod(MethodCall call) async {
    var methodPath = call.method.split('#');
    var listenerMethodName = methodPath[2];

    Map<String, dynamic>? arguments = call.arguments != null
        ? Map<String, dynamic>.from(call.arguments)
        : null;
    if (arguments == null) {
      return;
    }

    Map<String, dynamic>? inlineDataArguments = arguments['data'] != null
        ? Map<String, dynamic>.from(arguments['data'])
        : null;
    if (inlineDataArguments == null) {
      return;
    }

    InlineInAppMessageData data =
        InlineInAppMessageData.fromMap(inlineDataArguments);

    if (listenerMethodName == 'onInlineInAppAvailable') {
      final String? viewId = arguments['viewId'];
      final InlineInAppView view = InlineInAppView(
          placementKey: data.placementKey, adoptViewId: viewId);
      _inlineInAppMessageListener.onInlineInAppAvailable?.call(view, data);
      return;
    }

    if (listenerMethodName == 'onOpenUrl') {
      String? url = arguments['url'];
      if (url == null) {
        return;
      }
      _inlineInAppMessageListener.onOpenUrl?.call(data, url);
      return;
    }

    if (listenerMethodName == 'onDeepLink') {
      String? deepLink = arguments['deepLink'];
      if (deepLink == null) {
        return;
      }
      _inlineInAppMessageListener.onDeepLink?.call(data, deepLink);
      return;
    }

    if (listenerMethodName == 'onCustomAction') {
      String name = arguments['name'];
      Map<String, dynamic> parameters = arguments['parameters'] != null
          ? Map<String, dynamic>.from(arguments['parameters'])
          : <String, dynamic>{};
      _inlineInAppMessageListener.onCustomAction?.call(data, name, parameters);
      return;
    }

    if (listenerMethodName == 'onCustomMethod') {
      if (_inlineInAppMessageListener.onCustomMethod == null) {
        return;
      }
      String callId = arguments['callId'];
      String name = arguments['name'];
      Map<String, dynamic> parameters = arguments['parameters'] != null
          ? Map<String, dynamic>.from(arguments['parameters'])
          : <String, dynamic>{};
      InAppCustomMethodCompletion completion = InAppCustomMethodCompletion(
        (result) => _methods.resolveInlineCustomMethod(callId, true,
            result is Map ? Map<String, dynamic>.from(result) : null, null),
        (errorMessage) => _methods.resolveInlineCustomMethod(
            callId, false, null, errorMessage),
      );

      _inlineInAppMessageListener.onCustomMethod!(
          data, name, parameters, completion);
      return;
    }
  }
}
