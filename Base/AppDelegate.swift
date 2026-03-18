//
//  AppDelegate.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderGeofence
import InsiderMobile
import InsiderWebView
import UIKit
import UserNotifications

@main
public final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    private let appGroup = "group.com.useinsider.swiftdemo"
    private let partnerName = "salesdemo"

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        Insider.registerCallback(with: #selector(insiderCallback(_:)), sender: self)
        Insider.initWithLaunchOptions(nil, partnerName: partnerName, appGroup: appGroup)
        Insider.setActiveForegroundPushView()
        return true
    }

    @objc public func insiderCallback(_ context: [String: Any]) {
        print(context)
        if
            let typeAsInt = context["type"] as? Int,
            let type = InsiderCallbackType(rawValue: typeAsInt) {
            switch type {
            case InsiderCallbackType.notificationOpen:
                break
            case .inAppSeen:
                break
            case .inappButtonClick:
                break
            case .sessionStarted:
                break
            case .tempStoreAddedToCart, .tempStorePurchase, .tempStoreCustomAction:
                break
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
}
