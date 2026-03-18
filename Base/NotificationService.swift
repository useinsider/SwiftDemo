//
//  NotificationService.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobileAdvancedNotification
@preconcurrency import UserNotifications

/// A notification service extension that intercepts and modifies incoming push notifications
/// to support Insider rich push content such as images, carousels, and interactive elements.
///
/// This extension runs in a separate process with a limited execution time. It downloads
/// rich media attachments via the Insider SDK and attaches them to the notification content
/// before displaying it to the user.
///
/// - Important: The `appGroup` must match the App Group identifier configured in both
///   the main app target and this extension target for shared data access.
public final class NotificationService: UNNotificationServiceExtension {

    /// The completion handler provided by the system to deliver the modified notification content.
    nonisolated(unsafe) private var contentHandler: ((UNNotificationContent) -> Void)?

    /// A mutable copy of the original notification content that can be modified before delivery.
    nonisolated(unsafe) private var bestAttemptContent: UNMutableNotificationContent?

    /// The App Group identifier used for sharing data between the main app and this extension.
    private let appGroup = "group.com.useinsider.swiftdemo"

    /// Called when a push notification is received, allowing modification of its content before display.
    ///
    /// This method delegates to the Insider SDK to download and attach rich push media (images, videos, etc.)
    /// to the notification. If the attachment download succeeds, it is added to the notification content.
    ///
    /// - Parameters:
    ///   - request: The original notification request containing the payload.
    ///   - contentHandler: A completion handler to call with the modified notification content.
    public override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping @Sendable (UNNotificationContent) -> Void
    ) {
        guard
            let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        else { return }
        InsiderPushNotification.showInsiderRichPush(
            bestAttemptContent,
            appGroup: appGroup,
            nextButtonText: "Next",
            goToAppText: "Go to App",
            success: { attachment in
                if let attachment {
                    bestAttemptContent.attachments = [attachment]
                }
                contentHandler(bestAttemptContent)
            }
        )
        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent
    }

    /// Called just before the extension is terminated by the system due to time expiration.
    ///
    /// Delivers the best attempt content as-is (potentially without rich media attachments)
    /// to ensure the user still receives the notification even if the download did not complete in time.
    public override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
