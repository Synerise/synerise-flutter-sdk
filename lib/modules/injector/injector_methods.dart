import '../base/base_module_method_channel.dart';

class InjectorMethods extends BaseMethodChannel {
  Future<void> handleOpenUrlBySDK(String url) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Injector/handleOpenUrlBySDK', parameters: url);
  }

  Future<void> handleDeepLinkBySDK(String deepLink) async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod('Injector/handleDeepLinkBySDK', parameters: deepLink);
  }
}
