//
//  SetMobileAppAccessAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that enables or disables mobile app access consent via the Insider SDK.
public struct SetMobileAppAccessAction: Action {

    /// The display title reflecting the current mobile app access state.
    public let title: String

    /// Whether mobile app access is enabled.
    private let enabled: Bool

    /// Initializes the action with the desired mobile app access state.
    /// - Parameter enabled: `true` to enable mobile app access, `false` to disable it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "Mobile App Access (\(enabled))"
    }

    /// Executes the action by setting the mobile app access preference on the Insider SDK.
    public func execute() {
        Insider.setMobileAppAccess(enabled)
    }
}
