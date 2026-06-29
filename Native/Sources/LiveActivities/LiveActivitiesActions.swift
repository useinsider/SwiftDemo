//
//  LiveActivitiesActions.swift
//  Example
//

import ActivityKit
import Foundation
import InsiderLiveActivities
import InsiderMobile

@available(iOS 16.2, *)
public enum LiveActivitiesActions {

    // MARK: - SDK type-level

    @MainActor
    @available(iOS 17.2, *)
    public static func registerPushToStartTokens<T: InsiderLiveActivitiesAttributes>(
        forType type: Activity<T>.Type,
        label: String
    ) async {
        AppLogger.shared.log("register(forType: \(label)) called")
        do {
            try await Insider.liveActivities.register(forType: type)
            AppLogger.shared.log("register(\(label)) succeeded")
        } catch let error as InsiderLiveActivitiesError {
            let detail: String
            switch error {
            case .authorizationDenied:          detail = "Live Activities disabled in Settings"
            @unknown default:                   detail = "Unknown InsiderLiveActivitiesError"
            }
            AppLogger.shared.log("register(\(label)) failed: \(detail)", level: .error)
        } catch {
            AppLogger.shared.log("register(\(label)) failed: \(error.localizedDescription)", level: .error)
        }
    }

    @MainActor
    public static func cancel<T: InsiderLiveActivitiesAttributes>(
        forType type: Activity<T>.Type,
        label: String
    ) async {
        AppLogger.shared.log("cancel(forType: \(label)) called")
        await Insider.liveActivities.cancel(forType: type)
        AppLogger.shared.log("cancel(\(label)) completed")
    }

    @MainActor
    public static func cancelAll() async {
        AppLogger.shared.log("cancelAll() called")
        await Insider.liveActivities.cancelAll()
        AppLogger.shared.log("cancelAll() completed")
    }

    // MARK: - Activity instance-level

    @MainActor
    public static func startActivity<T: InsiderLiveActivitiesAttributes>(
        attributes: T,
        initialState: T.ContentState,
        label: String
    ) {
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: initialState, staleDate: nil),
                pushType: .token
            )
            AppLogger.shared.log("Started \(label) id=\(activity.id.prefix(8))")
        } catch {
            AppLogger.shared.log("Activity.request(\(label)) failed: \(error.localizedDescription)", level: .error)
        }
    }

    @MainActor
    public static func logUpdated<T: InsiderLiveActivitiesAttributes>(
        _ activity: Activity<T>,
        label: String
    ) {
        AppLogger.shared.log("Updated \(label) id=\(activity.id.prefix(8))")
    }

    @MainActor
    public static func logEnded<T: InsiderLiveActivitiesAttributes>(
        _ activity: Activity<T>,
        label: String
    ) {
        AppLogger.shared.log("Ended \(label) id=\(activity.id.prefix(8))")
    }
}
