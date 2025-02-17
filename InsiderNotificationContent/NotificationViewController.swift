//
//  NotificationViewController.swift
//  InsiderNotificationContent
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import InsiderMobileAdvancedNotification

class NotificationViewController: UIViewController, UNNotificationContentExtension, iCarouselDelegate, iCarouselDataSource {

    let APP_GROUP = "group.com.insider.SwiftDemo"

    @IBOutlet var carousel: iCarousel!

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        return InsiderPushNotification.getSlide(index, reusing: view, superView: self.view)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return InsiderPushNotification.getNumberOfSlide()
    }

    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return InsiderPushNotification.getItemWidth()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
    }
    
    func didReceive(_ notification: UNNotification) {
        InsiderPushNotification.interactivePushLoad(APP_GROUP, superView: self.view, notification: notification)

        carousel.type = .rotary
        carousel.reloadData()

        InsiderPushNotification.interactivePushDidReceive()
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
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

    deinit {
        carousel.delegate = nil
        carousel.dataSource = nil
    }
}
