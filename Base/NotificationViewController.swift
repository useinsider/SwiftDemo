//
//  NotificationViewController.swift
//  Example
//
//  Created by Insider on 16.03.2026.
//

import InsiderMobileAdvancedNotification
import UIKit
import UserNotifications
import UserNotificationsUI

/// A notification content extension view controller that displays Insider interactive push
/// notifications with a carousel interface.
///
/// This controller implements `UNNotificationContentExtension` to provide a custom UI
/// for expanded push notifications. It uses an `iCarousel` component to display multiple
/// slides (images or content) that users can navigate through using action buttons.
///
/// - Important: The `appGroup` must match the App Group identifier configured in both
///   the main app target and this extension target for shared data access.
/// - Note: This controller requires an `iCarousel` outlet to be connected in the storyboard.
@MainActor public final class NotificationViewController: UIViewController, UNNotificationContentExtension, iCarouselDelegate, iCarouselDataSource {

    /// The carousel view used to display interactive push notification slides.
    ///
    /// This outlet must be connected in the storyboard. The carousel displays rich media
    /// content (images, promotional banners, etc.) provided by the Insider SDK.
    @IBOutlet public var carousel: iCarousel!

    /// The App Group identifier used for sharing data between the main app and this extension.
    private let appGroup = "group.com.useinsider.swiftdemo"

    /// Returns the view for a specific item in the carousel.
    ///
    /// Delegates to the Insider SDK to create or reuse a slide view for the given index.
    ///
    /// - Parameters:
    ///   - carousel: The carousel requesting the view.
    ///   - index: The index of the item to display.
    ///   - view: An optional previously used view that can be recycled.
    /// - Returns: A configured `UIView` representing the carousel slide at the given index.
    public func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return InsiderPushNotification.getSlide(index, reusing: view, superView: self.view)
    }

    /// Returns the total number of slides in the carousel.
    ///
    /// - Parameter carousel: The carousel requesting the item count.
    /// - Returns: The number of slides available in the current interactive push notification.
    public func numberOfItems(in carousel: iCarousel) -> Int {
        return InsiderPushNotification.getNumberOfSlide()
    }

    /// Returns the width of each item in the carousel.
    ///
    /// - Parameter carousel: The carousel requesting the item width.
    /// - Returns: The width in points for each carousel slide.
    public func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return InsiderPushNotification.getItemWidth()
    }

    /// Called after the view controller's view has been loaded into memory.
    ///
    /// Sets up the carousel by assigning its delegate and data source to this controller.
    public override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
    }

    /// Called when the notification content extension receives a notification to display.
    ///
    /// Initializes the Insider interactive push content, configures the carousel with a
    /// rotary animation style, reloads the slide data, and notifies the SDK that the
    /// interactive push has been received.
    ///
    /// - Parameter notification: The notification containing the push payload to display.
    public func didReceive(_ notification: UNNotification) {
        InsiderPushNotification.interactivePushLoad(appGroup, superView: view, notification: notification)

        carousel.type = .rotary
        carousel.reloadData()

        InsiderPushNotification.interactivePushDidReceive()
    }

    /// Called when the user interacts with a notification action button.
    ///
    /// If the user taps the "Next" button (`insider_int_push_next`), the carousel scrolls
    /// to the next slide and the notification remains visible. For any other action, the
    /// SDK logs the interaction and the notification is dismissed, forwarding the action
    /// to the main app.
    ///
    /// - Parameters:
    ///   - response: The user's response to the notification, including the action identifier.
    ///   - completion: A completion handler to call with the desired response option
    ///     (`.doNotDismiss` to keep the notification, `.dismissAndForwardAction` to dismiss it).
    public func didReceive(
        _ response: UNNotificationResponse,
        completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void
    ) {
        if response.actionIdentifier == "insider_int_push_next" {
            carousel.scrollToItem(
                at: InsiderPushNotification.didReceiveResponse(carousel.currentItemIndex),
                animated: true
            )
            completion(.doNotDismiss)
        }
        else {
            InsiderPushNotification.logPlaceholderClick(response)
            completion(.dismissAndForwardAction)
        }
    }
}
