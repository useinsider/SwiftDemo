//
//  SetAgeAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's age attribute in the Insider SDK.
public struct SetAgeAction: Action {

    /// The display title for this action.
    public let title: String = "Age"

    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The age value as a string to be parsed into an integer.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set age operation by parsing the input as an integer and updating the user's age via the Insider SDK.
    public func execute() {
        if let inputAsInteger = Int(input) {
            Insider.getCurrentUser().setAge()(inputAsInteger)
        }
    }
}
