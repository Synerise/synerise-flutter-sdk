import '../base/base_module_method_channel.dart';

class NotificationsMethods extends BaseMethodChannel {
  void registerForNotifications(String registrationToken,
      [bool? mobileAgreement]) {
    methodChannel.invokeMethod('Notifications/registerForNotifications', {
      "registrationToken": registrationToken,
      "mobileAgreement": mobileAgreement
    });
  }

  Future<bool> handleNotification(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/handleNotification', {'notification': notification});
  }

  Future<bool> handleNotificationClick(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/handleNotificationClick',
        {'notification': notification});
  }

  Future<bool> isSyneriseNotification(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/isSyneriseNotification', {'notification': notification});
  }

  Future<bool> isSyneriseSimplePush(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/isSyneriseSimplePush', {'notification': notification});
  }

  Future<bool> isSyneriseBanner(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/isSyneriseBanner', {'notification': notification});
  }

  Future<bool> isSilentCommand(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/isSilentCommand', {'notification': notification});
  }

  Future<bool> isSilentSDKCommand(Map notification) async {
    return await backgroundMethodChannel.invokeMethod(
        'Notifications/isSilentSDKCommand', {'notification': notification});
  }
}
