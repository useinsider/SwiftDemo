//
//  ItemAddedToWishlistWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that adds a product item to the user's wishlist with custom parameters via the Insider SDK.
public struct ItemAddedToWishlistWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Add to Wishlist (Custom)"

    /// Executes the add-to-wishlist operation by creating a sample product and passing custom parameters to the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "demo_product_123",
            name: "Demo Product",
            taxonomy: ["Electronics", "Smartphones"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        let customParameters: [String: Any] = [
            "source": "product_page",
            "recommendation_id": "rec_123",
            "wishlist_size": 5
        ]
        Insider.itemAddedToWishlist(with: product, customParameters: customParameters)
    }
}
