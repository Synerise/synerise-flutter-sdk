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

  Future<void> getWalkthrough() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod('Injector/getWalkthrough');
  }

  Future<void> showWalkthrough() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod('Injector/showWalkthrough');
  }

  Future<bool> isWalkthroughLoaded() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<bool>('Injector/isWalkthroughLoaded');
  }

  Future<bool> isLoadedWalkthroughUnique() async {
    return await SyneriseInvocation(methodChannel)
        .invokeSDKMethod<bool>('Injector/isLoadedWalkthroughUnique');
  }
}
