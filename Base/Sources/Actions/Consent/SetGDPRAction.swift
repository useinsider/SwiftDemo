//
//  SetGDPRAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that sets the user's GDPR consent preference via the Insider SDK.
public struct SetGDPRAction: Action {

    /// The display title reflecting the current GDPR consent state.
    public let title: String

    /// Whether GDPR consent is granted.
    private let enabled: Bool

    /// Initializes the action with the desired GDPR consent state.
    /// - Parameter enabled: `true` to grant GDPR consent, `false` to revoke it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "GDPR Consent (\(enabled))"
    }

    /// Executes the action by setting the GDPR consent on the Insider SDK.
    public func execute() {
        Insider.setGDPRConsent(enabled)
    }
}
