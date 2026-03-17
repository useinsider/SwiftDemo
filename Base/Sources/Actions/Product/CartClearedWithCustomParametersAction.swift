//
//  CartClearedWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a cart cleared event with custom parameters via the Insider SDK.
public struct CartClearedWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Cart Cleared (Custom)"

    /// Assembles custom parameters and reports a cart cleared event to the Insider SDK.
    public func execute() {
        let customParameters: [String: Any] = [
            "items_count_before": 3,
            "total_value_before": 150.0,
            "reason": "user_action"
        ]
        Insider.cartCleared(withCustomParameters: customParameters)
    }
}
