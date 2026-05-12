//
//  SetPhoneNumberAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's phone number attribute in the Insider SDK.
public struct SetPhoneNumberAction: Action {

    /// The display title for this action.
    public let title: String = "Phone Number"
    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The phone number string to set.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set phone number operation by updating the user's phone number via the Insider SDK.
    public func execute() {
        Insider.getCurrentUser().setPhoneNumber()(input)
    }
}
