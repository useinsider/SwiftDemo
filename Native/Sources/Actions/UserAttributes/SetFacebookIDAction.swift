//
//  SetFacebookIDAction.swift
//  Example
//
//  Created by Insider on 3.02.2026.
//

import InsiderMobile

/// An action that sets the current user's Facebook ID attribute in the Insider SDK.
public struct SetFacebookIDAction: Action {

    /// The display title for this action.
    public let title: String = "Facebook ID"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The Facebook ID string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set Facebook ID operation by updating the user's Facebook ID via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setFacebookID()(input)
    }
}
