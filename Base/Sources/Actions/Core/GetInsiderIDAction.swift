//
//  GetInsiderIDAction.swift
//  Example
//
//  Created by Insider on 16.11.2025.
//

import InsiderMobile

/// An action that retrieves and prints the current Insider user identifier.
public struct GetInsiderIDAction: Action {

    /// The display title for this action.
    public let title: String = "Insider ID"

    /// Fetches the Insider ID via the Insider SDK and prints it, or prints "null" if unavailable.
    public func execute() {
        if let insiderID = Insider.getID() {
            print("getInsiderID: \(insiderID)")
        } else {
            print("getInsiderID: null")
        }
    }
}
