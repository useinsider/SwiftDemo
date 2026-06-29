//
//  AppDelegate.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

#if canImport(ActivityKit)
import ActivityKit
#endif
import InsiderLiveActivities
import InsiderMobile
import UIKit
import UserNotifications

@main
public final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    private let appGroup = "group.com.useinsider.mobile-ios"
    private let partnerName = "partnername"

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        Insider.registerCallback(with: #selector(insiderCallback(_:)), sender: self)
        Insider.initWithLaunchOptions(launchOptions, partnerName: partnerName, appGroup: appGroup)
        Insider.setActiveForegroundPushView()

        if #available(iOS 16.1, *) {
            Task {
                async let deliveryResume: Void = resume(Activity<DeliveryActivityAttributes>.self, label: "Delivery")
                async let workoutResume:  Void = resume(Activity<WorkoutActivityAttributes>.self,  label: "Workout")
                async let matchResume:    Void = resume(Activity<MatchActivityAttributes>.self,    label: "Match")
                _ = await (deliveryResume, workoutResume, matchResume)
            }
        }

        return true
    }

    @available(iOS 16.1, *)
    private func resume<T: InsiderLiveActivitiesAttributes>(
        _ type: Activity<T>.Type,
        label: String
    ) async {
        do {
            try await Insider.liveActivities.resumeActivities(forType: type)
            AppLogger.shared.log("resumeActivities(\(label)) succeeded")
        } catch let error as InsiderLiveActivitiesError {
            let detail: String
            switch error {
            case .authorizationDenied: detail = "Live Activities disabled in Settings"
            @unknown default:          detail = "Unknown InsiderLiveActivitiesError"
            }
            AppLogger.shared.log("resumeActivities(\(label)) failed: \(detail)", level: .error)
        } catch {
            AppLogger.shared.log("resumeActivities(\(label)) failed: \(error.localizedDescription)", level: .error)
        }
    }

    @objc public func insiderCallback(_ context: [String: Any]) {
        if
            let typeAsInt = context["type"] as? Int,
            let type = InsiderCallbackType(rawValue: typeAsInt) {
            switch type {
            case .notificationOpen:
                break
            case .inAppSeen:
                break
            case .inappButtonClick:
                break
            case .sessionStarted:
                break
            case .tempStoreAddedToCart:
                break
            case .tempStorePurchase:
                break
            case .tempStoreCustomAction:
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
