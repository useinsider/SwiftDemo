//
//  UserCustomAttributesAction.swift
//  Example
//
//  Created by Insider on 3.02.2026.
//

import UIKit

/// An action that presents the custom user attributes screen for setting arbitrary user attributes via the Insider SDK.
public struct UserCustomAttributesAction: Action {

    /// The display title for this action.
    public let title: String = "Custom User Attributes"

    /// Navigates to the custom user attributes view controller by pushing it onto the root navigation stack.
    public func execute() {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        guard let rootViewController = keyWindow?.rootViewController as? UINavigationController else { return }

        let customUserAttributesViewController = CustomUserAttributesViewController()
        rootViewController.pushViewController(customUserAttributesViewController, animated: true)
    }
}
