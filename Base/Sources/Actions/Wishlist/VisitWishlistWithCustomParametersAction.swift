//
//  VisitWishlistWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a wishlist visit event with sample products and custom parameters via the Insider SDK.
public struct VisitWishlistWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Wishlist (Custom)"

    /// Executes the visit wishlist operation by creating a sample product and reporting the visit with custom parameters via the Insider SDK.
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
            "wishlist_total_items": 5,
            "wishlist_total_value": 500.0
        ]
        Insider.visitWishlist(withProducts: [product], customParameters: customParameters)
    }
}
