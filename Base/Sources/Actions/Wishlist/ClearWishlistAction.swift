//
//  ClearWishlistAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that clears all items from the user's wishlist via the Insider SDK.
public struct ClearWishlistAction: Action {

    /// The display title for this action.
    public let title: String = "Clear Wishlist"

    /// Executes the clear wishlist operation via the Insider SDK.
    public func execute() {
        Insider.wishlistCleared()
    }
}
