//
//  SetPushOptinAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that sets the user's push notification opt-in consent preference via the Insider SDK.
public struct SetPushOptinAction: Action {

    /// The display title reflecting the current opt-in state.
    public let title: String

    /// Whether the user opts in to push notifications.
    private let optin: Bool

    /// Initializes the action with the desired push notification opt-in state.
    /// - Parameter optin: `true` to opt in, `false` to opt out.
    public init(optin: Bool) {
        self.optin = optin
        self.title = "Push Optin (\(optin))"
    }

    /// Executes the action by setting the push notification opt-in preference on the current user.
    public func execute() {
        Insider.getCurrentUser().setPushOptin()(optin)
    }
}
