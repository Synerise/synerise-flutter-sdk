import 'package:flutter/services.dart';

import '../base/base_module_method_channel.dart';
import '../base/base_module.dart';
import 'notifications_methods.dart';

typedef NotificationsListenerFunction = void Function(
    NotificationsListener listener);

class NotificationsListener {
  void Function()? onRegistrationRequired;

  NotificationsListener();
}

class NotificationsImpl extends BaseModule {
  final NotificationsMethods _methods = NotificationsMethods();
  NotificationsImpl();

  final NotificationsListener _listener = NotificationsListener();

  /// This function takes a listener function as a parameter and calls it with a private listener
  /// function.
  void listener(NotificationsListenerFunction listenerFunction) {
    listenerFunction(_listener);
  }

  /// This function handles a specific method call and invokes a listener method if it matches certain
  /// criteria.
  void handleMethod(MethodCall call) {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];

    if (listenerName == 'NotificationsListener' &&
        listenerMethodName == 'onRegistrationRequired') {
      if (_listener.onRegistrationRequired != null) {
        _listener.onRegistrationRequired!();
      }
    }
  }

  /// This function registers a device for notifications with a given registration token and mobile
  /// agreement.
  ///
  /// Args:
  ///   registrationToken (String): The registration token is a unique identifier that is generated by
  /// the device when a user installs an app that uses Firebase Cloud Messaging (FCM) for push
  /// notifications. This token is used to identify the device and send push notifications to it.
  ///   mobileAgreement (bool): mobileAgreement is a boolean parameter that indicates whether the user
  /// has agreed to receive notifications on their mobile device.
  Future<void> registerForNotifications(String registrationToken,
      {bool? mobileAgreement,
      required void Function() onSuccess,
      required void Function(SyneriseError error) onError}) async {
    SyneriseResult<void> result = await _methods.registerForNotifications(
        registrationToken, mobileAgreement);
    result.onSuccess((result) {
      onSuccess();
    }).onError((error) {
      onError(error);
    });
  }

  /// This function handles a notification and returns a boolean value indicating whether the
  /// notification was successfully handled.
  ///
  /// Args:
  ///   notification (Map): The parameter "notification" is a Map object that contains data related to a
  /// notification. It could include information such as the title and body of the notification, the
  /// sender of the notification, and any additional data that was included with the notification.
  Future<bool> handleNotification(Map notification) async {
    return await _methods.handleNotification(notification);
  }

  /// This function handles a notification click and returns a boolean value.
  ///
  /// Args:
  ///   notification (Map): The parameter "notification" is a Map object that contains the data of a
  /// notification that was received by the app.
  Future<bool> handleNotificationClick(Map notification) async {
    return await _methods.handleNotificationClick(notification);
  }

  /// The function isSyneriseNotification checks if a given notification is a Synerise notification.
  ///
  /// Args:
  ///   notification (Map): A map containing the notification data.
  Future<bool> isSyneriseNotification(Map notification) async {
    return await _methods.isSyneriseNotification(notification);
  }

  /// The function checks if a given notification is a Synerise Simple Push notification.
  ///
  /// Args:
  ///   notification (Map): A map containing the notification data.
  Future<bool> isSyneriseSimplePush(Map notification) async {
    return await _methods.isSyneriseSimplePush(notification);
  }

  /// The function isSilentCommand checks if a notification is a silent command.
  ///
  /// Args:
  ///   notification (Map): A map containing the notification data.
  Future<bool> isSilentCommand(Map notification) async {
    return await _methods.isSilentCommand(notification);
  }

  /// The function checks if a given notification is a silent SDK command.
  ///
  /// Args:
  ///   notification (Map): A map containing the notification data.
  Future<bool> isSilentSDKCommand(Map notification) async {
    return await _methods.isSilentSDKCommand(notification);
  }

  /// The function checks if a notification is encrypted.
  ///
  /// Args:
  ///   notification (Map): A map containing the notification data.
  Future<bool> isNotificationEncrypted(Map notification) async {
    return _methods.isNotificationEncrypted(notification);
  }

  /// The function decrypts a notification and returns it.
  ///
  /// Args:
  ///   notification (Map): A Map object representing a notification that needs to be decrypted.
  Future<Map> decryptNotification(Map notification) async {
    return _methods.decryptNotification(notification);
  }
}
