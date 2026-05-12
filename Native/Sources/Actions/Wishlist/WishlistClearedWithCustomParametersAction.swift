//
//  WishlistClearedWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that clears all items from the user's wishlist with custom parameters via the Insider SDK.
public struct WishlistClearedWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Wishlist Cleared (Custom)"

    /// Executes the clear wishlist operation by passing custom parameters to the Insider SDK.
    public func execute() {
        let customParameters: [String: Any] = [
            "items_count_before": 10,
            "reason": "user_action"
        ]
        Insider.wishlistCleared(withCustomParameters: customParameters)
    }
}
