//
//  SetLocaleAction.swift
//  Example
//
//  Created by Insider on 3.02.2026.
//

import InsiderMobile

/// An action that sets the current user's locale attribute in the Insider SDK.
public struct SetLocaleAction: Action {

    /// The display title for this action.
    public let title: String = "Locale"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The locale identifier string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set locale operation by updating the user's locale via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setLocale()(input)
    }
}
