import 'package:flutter/services.dart';

import '../base/base_module.dart';
import 'notifications_methods.dart';

typedef NotificationsListenerFunction = void Function(NotificationsListener listener);

class NotificationsListener {
  void Function()? onRegistrationRequired;

  NotificationsListener();
}

class NotificationsImpl extends BaseModule {
  final NotificationsMethods _methods = NotificationsMethods();
  NotificationsImpl();

  final NotificationsListener _listener = NotificationsListener();

  void listener(NotificationsListenerFunction listenerFunction) {
    listenerFunction(_listener);
  }

  void handleMethod(MethodCall call) {
    var methodPath = call.method.split('#');
    var listenerName = methodPath[1];
    var listenerMethodName = methodPath[2];
      
    if (listenerName == 'NotificationsListener' && listenerMethodName == 'onRegistrationRequired') {
      if (_listener.onRegistrationRequired != null) {
        _listener.onRegistrationRequired!();
      }
    }
  }

  void registerForNotifications(String registrationToken, bool mobileAgreement) {
    _methods.registerForNotifications(registrationToken, mobileAgreement);
  }

  Future<bool> handleNotification(Map notification) async {
    return _methods.handleNotification(notification);
  }

  Future<bool> handleNotificationClick(Map notification) async {
    return _methods.handleNotificationClick(notification);
  }
}
