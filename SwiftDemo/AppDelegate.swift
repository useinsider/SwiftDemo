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
    // Make sure that all the letters are lowercase.
    let INSIDER_PARTNER_NAME = "partnername"

    // FIXME: Please change your URL Types to your partner name with insider prefix in Info.plist.
    // The URL scheme of URL Type whose identifier is 'insider' in Info.plist should match with your partner name.
    // For instance, url scheme is 'insideryourpartnername' where 'yourpartnername' is your partner name.

    var insiderCallbackInfo: [String: AnyObject]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        Insider.initWithLaunchOptions(launchOptions, partnerName: INSIDER_PARTNER_NAME, appGroup: APP_GROUP)
        Insider.setActiveForegroundPushView()
        Insider.register(withQuietPermission: false)
        Insider.registerCallback(with: #selector(insiderCallbackHandler(info:)), sender: self)
        InsiderGeofence.startTracking()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        window?.rootViewController?.present(alert, animated: true)
    }
    
    @objc private func insiderCallbackHandler(info: [String: AnyObject]) {
        guard let typeValue = info["type"] as? Int else { return }
        guard let type = InsiderCallbackType(rawValue: typeValue) else { return }
        let callback = String(describing: info)

        print("Insider callback received: \(callback)")
        switch type {
        case InsiderCallbackType.sessionStarted:
            showAlertAction(title: "InsiderCallbackTypeSessionStarted", message: callback)

        case InsiderCallbackType.notificationOpen:
            showAlertAction(title: "InsiderCallbackTypeNotificationOpen", message: callback)

        case InsiderCallbackType.tempStoreAddedToCart:
            showAlertAction(title: "InsiderCallbackTypeTempStoreAddedToCart", message: callback)

        case InsiderCallbackType.tempStorePurchase:
            showAlertAction(title: "InsiderCallbackTypeTempStorePurchase", message: callback)

        case InsiderCallbackType.tempStoreCustomAction:
            showAlertAction(title: "InsiderCallbackTypeTempStoreCustomAction", message: callback)

        case InsiderCallbackType.inAppSeen:
            showAlertAction(title: "InsiderCallbackTypeInAppSeen", message: callback)

        case InsiderCallbackType.inappButtonClick:
            showAlertAction(title: "InsiderCallbackTypeInappButtonClick", message: callback)

        default:
            return
        }
    }

    private var window: UIWindow? {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?
            .delegate as? SceneDelegate else { return nil }
        return sceneDelegate.window
    }
}
