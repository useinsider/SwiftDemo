//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by Zahide Sena Kurtak on 9.02.2025.
//

import UIKit
import InsiderMobile
import InsiderGeofence

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // FIXME: Please change with your app group.
    let APP_GROUP = "group.com.insider.SwiftDemo"

    // FIXME: Please change with your partner name.
    // Make sure tshat all the letters are lowercase.
    let INSIDER_PARTNER_NAME = "salesdemo"

    // FIXME: Please change your URL Types to your partner name with insider prefix in Info.plist.
    // The URL scheme of URL Type whose identifier is 'insider' in Info.plist should match with your partner name.
    // For instance, url scheme is 'insideryourpartnername' where 'yourpartnername' is your partner name.

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        Insider.setGDPRConsent(true)
        Insider.setActiveForegroundPushView()
        Insider.registerCallback(with: #selector(insiderCallbackHandler(info:)), sender: self)
        Insider.initWithLaunchOptions(launchOptions, partnerName: INSIDER_PARTNER_NAME, appGroup: APP_GROUP)
        Insider.register(withQuietPermission: false)
        InsiderGeofence.startTracking()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func printMessage(title: String, message: String) {
        print("\(title): \(message)")
    }
    
    @objc private func insiderCallbackHandler(info: [String: AnyObject]) {
        guard let typeValue = info["type"] as? Int else { return }
        guard let type = InsiderCallbackType(rawValue: typeValue) else { return }
        let callback = String(describing: info)
        switch type {
        case InsiderCallbackType.sessionStarted:
            printMessage(title: "InsiderCallbackTypeSessionStarted", message: callback)

        case InsiderCallbackType.notificationOpen:
            printMessage(title: "InsiderCallbackTypeNotificationOpen", message: callback)

        case InsiderCallbackType.tempStoreAddedToCart:
            printMessage(title: "InsiderCallbackTypeTempStoreAddedToCart", message: callback)

        case InsiderCallbackType.tempStorePurchase:
            printMessage(title: "InsiderCallbackTypeTempStorePurchase", message: callback)

        case InsiderCallbackType.tempStoreCustomAction:
            printMessage(title: "InsiderCallbackTypeTempStoreCustomAction", message: callback)

        case InsiderCallbackType.inAppSeen:
            printMessage(title: "InsiderCallbackTypeInAppSeen", message: callback)

        case InsiderCallbackType.inappButtonClick:
            printMessage(title: "InsiderCallbackTypeInappButtonClick", message: callback)

        default:
            return
        }
    }
}
