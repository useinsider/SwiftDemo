//
//  DisableInappMessagesAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that disables in-app messages via the Insider SDK.
public struct DisableInappMessagesAction: Action {

    /// The display title for this action.
    public let title: String = "Disable Inapp Messages"

    /// Disables the display of in-app messages.
    public func execute() {
        Insider.disableInAppMessages()
    }
}
