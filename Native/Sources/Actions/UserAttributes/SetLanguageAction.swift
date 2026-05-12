//
//  SetLanguageAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's language attribute in the Insider SDK.
public struct SetLanguageAction: Action {

    /// The display title for this action.
    public let title: String = "Language"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The language identifier string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set language operation by updating the user's language via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setLanguage()(input)
    }
}
