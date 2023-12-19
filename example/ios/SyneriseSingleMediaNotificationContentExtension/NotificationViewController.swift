//
//  NotificationViewController.swift
//  SyneriseSingleMediaNotificationContentExtension
//
//  Created by Krzysztof Kurzawa on 29/06/2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SyneriseSDK

class NotificationViewController: SingleMediaContentExtensionViewController, UNNotificationContentExtension {
    
    func didReceive(_ notification: UNNotification) {
        Synerise.settings.sdk.appGroupIdentifier = "group.com.synerise.sdk.sample-flutter"
        Synerise.settings.sdk.keychainGroupIdentifier = "34N2Z22TKH.FlutterKeychainGroup"
        
        setSyneriseNotification(notification)
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        setSyneriseNotificationResponse(response, completionHandler: completion)
    }
}
