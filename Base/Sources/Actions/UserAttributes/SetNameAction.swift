//
//  SetNameAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's first name attribute in the Insider SDK.
public struct SetNameAction: Action {

    /// The display title for this action.
    public let title: String = "Name"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The first name string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set name operation by updating the user's first name via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setName()(input)
    }
}
