import '../../events/event.dart';
import '../base/base_module_method_channel.dart';

class TrackerMethods extends BaseMethodChannel {
  Future<void> setCustomIdentifier(String customIdentifier) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<void>(
        'Tracker/setCustomIdentifier',
        parameters: {"customIdentifier": customIdentifier});
  }

  Future<void> setCustomEmail(String customEmail) async {
    return await SyneriseInvocation(methodChannel).invokeSDKMethod<void>(
        'Tracker/setCustomEmail',
        parameters: {"customEmail": customEmail});
  }

  Future<void> send(Event event) async {
    return SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Tracker/send', parameters: event.asMap());
  }

  Future<void> flush() async {
    return SyneriseInvocation(methodChannel)
        .invokeSDKMethod<void>('Tracker/flush');
  }
}
