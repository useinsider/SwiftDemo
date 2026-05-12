//
//  ReinitAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that reinitializes the Insider SDK with a new partner name.
public struct ReinitAction: Action {

    /// The display title for this action.
    public let title: String = "Reinit"

    /// The partner name to use when reinitializing the SDK.
    private var input: String = String()

    /// Sets the partner name for reinitialization.
    /// - Parameter input: The new partner name.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Reinitializes the Insider SDK with the configured partner name.
    public func execute() {
        Insider.reinit(withPartnerName: input)
    }
}
