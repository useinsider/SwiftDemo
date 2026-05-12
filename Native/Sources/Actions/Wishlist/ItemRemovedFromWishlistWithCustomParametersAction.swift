//
//  ItemRemovedFromWishlistWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that removes a product item from the user's wishlist with custom parameters via the Insider SDK.
public struct ItemRemovedFromWishlistWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Remove from Wishlist (Custom)"

    /// Executes the remove-from-wishlist operation by passing the product ID and custom parameters to the Insider SDK.
    public func execute() {
        let customParameters: [String: Any] = [
            "reason": "purchased",
            "wishlist_size_after": 4
        ]
        Insider.itemRemovedFromWishlist(withProductID: "demo_product_123", customParameters: customParameters)
    }
}
