//
//  SetBirthdayAction.swift
//  Example
//
//  Created by Insider on 7.11.2025.
//

import InsiderMobile

/// An action that sets the current user's birthday attribute in the Insider SDK.
public struct SetBirthdayAction: Action {

    /// The display title for this action.
    public let title: String = "Birthday"

    private var input: String = String()

    /// Updates the input value to be used when executing the action.
    /// - Parameter input: The birthday value as a `yyyy-MM-dd` string.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the set birthday operation by parsing the input as a `yyyy-MM-dd` date and updating the user's birthday via the Insider SDK.
    public func execute() {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        if let birthday = formatter.date(from: input) {
            Insider.getCurrentUser().setBirthday()(birthday)
        }
    }
}
