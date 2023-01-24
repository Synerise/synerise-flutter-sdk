import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import './base_module_method_channel.dart';

abstract class BasePlatform extends PlatformInterface {
  /// Constructs a SynerisePlatform.
  BasePlatform() : super(token: _token);

  static final Object _token = Object();

  static BasePlatform _instance = BaseMethodChannel();

  /// The default instance of [SynerisePlatform] to use.
  ///
  /// Defaults to [MethodChannelSynerise].
  static BasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SynerisePlatform] when
  /// they register themselves.
  static set instance(BasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
