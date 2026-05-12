//
//  ItemAddedToCartWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product being added to the cart with custom parameters via the Insider SDK.
public struct ItemAddedToCartWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Add to Cart (Custom)"

    /// Creates a sample product, assembles custom parameters, and reports the item as added to cart using the Insider SDK.
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
            "quantity": 2,
            "source": "recommendation",
            "variant_id": "variant_123"
        ]
        Insider.itemAddedToCart(with: product, customParameters: customParameters)
    }
}
