import '../../main/dependencies.dart';

/// The class `BaseMethodChannel` contains instances of method channels for regular and background
/// communication in Dart.
class BaseMethodChannel {
  final methodChannel = Dependencies.methodChannel;
  final backgroundMethodChannel = Dependencies.backgroundMethodChannel;
}
