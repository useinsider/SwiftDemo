//
//  UserLogoutResettingIDAction.swift
//  Example
//
//  Created by Insider on 29.12.2025.
//

import InsiderMobile

/// An action that logs the current user out of the Insider SDK while resetting the Insider ID.
public struct UserLogoutResettingIDAction: Action {

    /// The display title for this action.
    public let title: String = "Logout (Reset ID)"
    private var input: String = String()

    /// Executes the logout operation and resets the Insider ID, providing the new ID via a completion handler.
    public func execute() {
        Insider.getCurrentUser().logoutResettingInsiderID(nil) { insiderId in
            if let insiderId {
                print("logoutResettingInsiderID: \(insiderId)")
            }
        }
    }
}
