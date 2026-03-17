//
//  SetGenderAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's gender attribute in the Insider SDK.
public struct SetGenderAction: Action {

    /// The display title for this action.
    public let title: String = "Gender"

    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The gender value as a string, expected to be parseable as an `InsiderGender` raw value.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set gender operation by parsing the input as an `InsiderGender` enum and updating the user's gender via the Insider SDK.
    public func execute() {
        if let genderAsInt = Int(input),
           let genderAsEnum = InsiderGender(rawValue: genderAsInt) {
            Insider.getCurrentUser().setGender()(genderAsEnum)
        }
    }
}
