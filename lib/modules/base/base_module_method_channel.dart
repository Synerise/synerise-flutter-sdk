import 'package:flutter/services.dart';
import './base_module_platform_interface.dart';

/// An implementation of [SynerisePlatform] that uses method channels.
class BaseMethodChannel extends BasePlatform {
  /// The method channel used to interact with the native platform.

  final methodChannel = const MethodChannel('synerise_flutter_sdk');
}
