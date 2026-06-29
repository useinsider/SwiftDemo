//
//  OpenLiveActivitiesPageAction.swift
//  Example
//

import UIKit

public struct OpenLiveActivitiesPageAction: Action {

    public let title: String = "Live Activities"

    @MainActor
    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }

        if #available(iOS 16.2, *) {
            rootViewController.pushViewController(LiveActivitiesViewController(), animated: true)
        } else {
            let alert = UIAlertController(
                title: "Unavailable",
                message: "Live Activities require iOS 16.2 or later.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            rootViewController.present(alert, animated: true)
        }
    }
}
