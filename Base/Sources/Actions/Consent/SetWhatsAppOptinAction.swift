//
//  SetWhatsAppOptinAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that sets the user's WhatsApp opt-in consent preference via the Insider SDK.
public struct SetWhatsAppOptinAction: Action {

    /// The display title reflecting the current opt-in state.
    public let title: String

    /// Whether the user opts in to WhatsApp communications.
    private let optin: Bool

    /// Initializes the action with the desired WhatsApp opt-in state.
    /// - Parameter optin: `true` to opt in, `false` to opt out.
    public init(optin: Bool) {
        self.optin = optin
        self.title = "WhatsApp Optin (\(optin))"
    }

    /// Executes the action by setting the WhatsApp opt-in preference on the current user.
    public func execute() {
        Insider.getCurrentUser().setWhatsappOptin()(optin)
    }
}
