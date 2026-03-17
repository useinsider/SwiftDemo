//
//  CustomEventAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import UIKit

/// An action that presents a custom event configuration screen via the Insider SDK.
public struct CustomEventAction: Action {

    /// The display title for this action.
    public let title: String = "Custom Event"

    /// Navigates to the custom event view controller where users can configure and send custom events.
    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }

        let customEventViewController = CustomEventViewController()
        rootViewController.pushViewController(customEventViewController, animated: true)
    }
}
