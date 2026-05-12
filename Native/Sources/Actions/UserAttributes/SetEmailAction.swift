//
//  SetEmailAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's email address attribute in the Insider SDK.
public struct SetEmailAction: Action {

    /// The display title for this action.
    public let title: String = "E-mail"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The email address string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set email operation by updating the user's email via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setEmail()(input)
    }
}
