//
//  UserLoginAction.swift
//  Example
//
//  Created by Insider on 16.11.2025.
//

import InsiderMobile

/// An action that logs the current user into the Insider SDK using predefined identifiers.
public struct UserLoginAction: Action {

    /// The display title for this action.
    public let title: String = "Login"
    private var input: String = String()

    /// Executes the user login operation by creating identifiers and calling the Insider SDK login method.
    public func execute() {
        let identifiers = InsiderIdentifiers()
            .addEmail()("insider-ios-example@useinsider.com")
            .addPhoneNumber()("+901234567890")
            .addUserID()("insider_ios_example_user_id")

        Insider.getCurrentUser().login(identifiers) { insiderId in
            if let insiderId {
                print("login: \(insiderId)")
            }
        }
    }
}
