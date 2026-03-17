//
//  SetTwitterIDAction.swift
//  Example
//
//  Created by Insider on 3.02.2026.
//

import InsiderMobile

/// An action that sets the current user's Twitter ID attribute in the Insider SDK.
public struct SetTwitterIDAction: Action {

    /// The display title for this action.
    public let title: String = "Twitter ID"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The Twitter ID string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set Twitter ID operation by updating the user's Twitter ID via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setTwitterID()(input)
    }
}
