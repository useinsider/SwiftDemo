//
//  SetSurnameAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's surname attribute in the Insider SDK.
public struct SetSurnameAction: Action {

    /// The display title for this action.
    public let title: String = "Surname"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The surname string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set surname operation by updating the user's surname via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setSurname()(input)
    }
}
