//
//  ItemAddedToCartAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product being added to the shopping cart via the Insider SDK.
public struct ItemAddedToCartAction: Action {

    /// The display title for this action.
    public let title: String = "Add Item to Cart"

    /// Creates a sample product and reports it as added to cart using the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        Insider.itemAddedToCart(with: product)
    }
}
