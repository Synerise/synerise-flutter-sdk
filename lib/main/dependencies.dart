import 'package:flutter/services.dart';

/// The class Dependencies contains two static constants representing MethodChannels for the Synerise
/// Flutter SDK and its background operations.
class Dependencies {
  static const methodChannel = MethodChannel('synerise_flutter_sdk');
  static const backgroundMethodChannel = MethodChannel('synerise_flutter_sdk_background');
}
