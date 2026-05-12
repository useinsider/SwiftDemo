//
//  RemoveItemFromWishlistAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that removes a specific product item from the user's wishlist via the Insider SDK.
public struct RemoveItemFromWishlistAction: Action {

    /// The display title for this action.
    public let title: String = "Remove Item from Wishlist"

    /// Executes the remove-from-wishlist operation by removing the product with a predefined ID via the Insider SDK.
    public func execute() {
        Insider.itemRemovedFromWishlist(withProductID: "1")
    }
}
