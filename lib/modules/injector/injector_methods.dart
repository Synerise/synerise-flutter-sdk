import 'dart:collection';
import 'package:flutter/widgets.dart';

import '../base/base_module_method_channel.dart';

class InjectorMethods extends BaseMethodChannel {
  Future<void> setBannerShouldPresentFlag(bool flag) async {
    WidgetsFlutterBinding.ensureInitialized();
    backgroundMethodChannel.invokeMethod(
        "Injector/setBannerShouldPresentFlag", flag);
  }

  Future<void> setInAppMessageShouldPresentFlag(bool flag) async {
    WidgetsFlutterBinding.ensureInitialized();
    backgroundMethodChannel.invokeMethod(
        "Injector/setInAppMessageShouldPresentFlag", flag);
  }

  Future<void> setInAppMessageContext(
      HashMap<dynamic, dynamic>? context) async {
    WidgetsFlutterBinding.ensureInitialized();
    backgroundMethodChannel.invokeMethod(
        "Injector/setInAppMessageContext", context);
  }

  void handleOpenUrlBySDK(String url) async {
    methodChannel.invokeMethod('Injector/handleOpenUrlBySDK', url);
  }
  
  void handleDeepLinkBySDK(String deepLink) async {
    methodChannel.invokeMethod('Injector/handleDeepLinkBySDK', deepLink);
  }

  void getWalkthrough() async {
    methodChannel.invokeMethod('Injector/getWalkthrough');
  }

  void showWalkthrough() async {
    methodChannel.invokeMethod('Injector/showWalkthrough');
  }

  Future<bool> isWalkthroughLoaded() async {
    bool isWalkthroughLoaded =
        await methodChannel.invokeMethod('Injector/isWalkthroughLoaded');
    return isWalkthroughLoaded;
  }

  Future<bool> isLoadedWalkthroughUnique() async {
    bool isLoadedWalkthroughUnique =
        await methodChannel.invokeMethod('Injector/isLoadedWalkthroughUnique');
    return isLoadedWalkthroughUnique;
  }
}
