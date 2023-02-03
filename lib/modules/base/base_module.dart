import 'package:synerise_flutter_sdk/modules/base/base_module_platform_interface.dart';

class BaseModule implements BasePlatform {
  bool isInitialized = false;

  void beforeInitialization() {}
  void afterInitialization() {
    isInitialized = true;
  }
}
