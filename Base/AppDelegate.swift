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

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        Insider.registerCallback(with: #selector(insiderCallback(_:)), sender: self)
        Insider.initWithLaunchOptions(nil, partnerName: "orkunbites", appGroup: "group.com.useinsider.mobile-ios")

        Insider.setActiveForegroundPushView()

#if DEBUG
UserDefaults.standard.set("1", forKey: "InsiderDebugCheck")
#endif

        return true
    }

    @objc public func insiderCallback(_ dict: [String: Any]) {
        print("insiderCallback: \(dict)")
        if
            let typeAsInt = dict["type"] as? Int,
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
