//
//  VisitHomePageAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a home page visit via the Insider SDK.
public struct VisitHomePageAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Home Page"

    /// Reports a home page visit event to the Insider SDK.
    public func execute() {
        Insider.visitHomepage()
    }
}
