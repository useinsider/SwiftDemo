//
//  NotificationService.swift
//  InsiderNotificationService
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UserNotifications
import InsiderMobileAdvancedNotification

class NotificationService: UNNotificationServiceExtension {

    // FIXME: Please change with your app group.
    let APP_GROUP = "group.com.insider.SwiftDemo"

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    var receivedRequest: UNNotificationRequest?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        self.receivedRequest = request
        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }
        // Modify the notification content here...
        let nextButtonText = ">>"
        let goToAppText = "Launch App"

        InsiderPushNotification.showInsiderRichPush(
            bestAttemptContent,
            appGroup: APP_GROUP,
            nextButtonText: nextButtonText,
            goToAppText: goToAppText,
            success: { attachment in
                if let attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        )
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            InsiderPushNotification.serviceExtensionTimeWillExpire(receivedRequest, content: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}
