import '../base/base_module_method_channel.dart';

class InjectorMethods extends BaseMethodChannel {

  Future<void> closeInAppMessage(String campaignHash) async {
      return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/closeInAppMessage', parameters: campaignHash);
  }
  Future<void> handleOpenUrlBySDK(String url) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/handleOpenUrlBySDK', parameters: url);
  }

  Future<void> handleDeepLinkBySDK(String deepLink) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod('Injector/handleDeepLinkBySDK', parameters: deepLink);
  }

  Future<void> setInAppContext(Map<String, dynamic> context) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/setInAppContext', parameters: context);
  }

  Future<void> notifyInAppContextChange() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/notifyInAppContextChange');
  }

  Future<void> resolveInAppCustomMethod(String callId, bool success,
      Object? result, String? error) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/resolveInAppCustomMethod', parameters: {
      "callId": callId,
      "success": success,
      "result": result,
      "error": error,
    });
  }
}
