//
//  EnableInappMessagesAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that enables in-app messages via the Insider SDK.
public struct EnableInappMessagesAction: Action {

    /// The display title for this action.
    public let title: String = "Enable Inapp Messages"

    /// Enables the display of in-app messages.
    public func execute() {
        Insider.enableInAppMessages()
    }
}
