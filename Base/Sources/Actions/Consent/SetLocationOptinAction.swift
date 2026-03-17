//
//  SetLocationOptinAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that sets the user's location opt-in consent preference via the Insider SDK.
public struct SetLocationOptinAction: Action {

    /// The display title reflecting the current opt-in state.
    public let title: String

    /// Whether the user opts in to location tracking.
    private let optin: Bool

    /// Initializes the action with the desired location opt-in state.
    /// - Parameter optin: `true` to opt in, `false` to opt out.
    public init(optin: Bool) {
        self.optin = optin
        self.title = "Location Optin (\(optin))"
    }

    /// Executes the action by setting the location opt-in preference on the current user.
    public func execute() {
        Insider.getCurrentUser().setLocationOptin()(optin)
    }
}
