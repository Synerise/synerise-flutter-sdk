import '../base/base_module_method_channel.dart';

class NotificationsMethods extends BaseMethodChannel {
  void registerForNotifications(String registrationToken, bool mobileAgreement) {
    methodChannel.invokeMethod('Notifications/registerForNotifications', {
      "registrationToken": registrationToken,
      "mobileAgreement": mobileAgreement
    });
  }

  Future<bool> handleNotification(Map notification) async {
     return await backgroundMethodChannel.invokeMethod('Notifications/handleNotification', {
      'notification': notification
    });
  }

  Future<bool> handleNotificationClick(Map notification) async {
     return await backgroundMethodChannel.invokeMethod('Notifications/handleNotificationClick', {
      'notification': notification
    });
  }
}