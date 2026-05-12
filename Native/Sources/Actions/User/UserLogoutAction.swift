//
//  UserLogoutAction.swift
//  Example
//
//  Created by Insider on 16.11.2025.
//

import InsiderMobile

/// An action that logs the current user out of the Insider SDK.
public struct UserLogoutAction: Action {

    /// The display title for this action.
    public let title: String = "Logout"
    private var input: String = String()

    /// Executes the user logout operation via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().logout()
    }
}
