//
//  AddItemToWishlistAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that adds a sample product item to the user's wishlist via the Insider SDK.
public struct AddItemToWishlistAction: Action {

    /// The display title for this action.
    public let title: String = "Add Item to Wishlist"

    /// Executes the add-to-wishlist operation by creating a sample product and adding it to the wishlist via the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        Insider.itemAddedToWishlist(with: product)
    }
}
