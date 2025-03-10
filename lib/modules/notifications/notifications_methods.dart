import '../base/base_module_method_channel.dart';

class NotificationsMethods extends BaseMethodChannel {
  Future<SyneriseResult<void>> registerForNotifications(
      String registrationToken,
      [bool? mobileAgreement]) async {
    return await SyneriseInvocation(methodChannel).invokeSDKApiMethod<void>(
        'Notifications/registerForNotifications',
        parameters: {
          "registrationToken": registrationToken,
          "mobileAgreement": mobileAgreement
        });
  }

  Future<bool> handleNotification(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/handleNotification',
            parameters: {'notification': notification});
  }

  Future<bool> handleNotificationClick(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/handleNotificationClick',
            parameters: {'notification': notification});
  }

  Future<bool> isSyneriseNotification(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/isSyneriseNotification',
            parameters: {'notification': notification});
  }

  Future<bool> isSyneriseSimplePush(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/isSyneriseSimplePush',
            parameters: {'notification': notification});
  }

  Future<bool> isSilentCommand(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/isSilentCommand',
            parameters: {'notification': notification});
  }

  Future<bool> isSilentSDKCommand(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel)
        .invokeSDKMethod<bool>('Notifications/isSilentSDKCommand',
            parameters: {'notification': notification});
  }

  Future<bool> isNotificationEncrypted(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel).invokeSDKMethod(
        'Notifications/isNotificationEncrypted',
        parameters: {'notification': notification});
  }

  Future<Map> decryptNotification(Map notification) async {
    return await SyneriseInvocation(backgroundMethodChannel).invokeSDKMethod(
        'Notifications/decryptNotification',
        parameters: {'notification': notification});
  }
}
