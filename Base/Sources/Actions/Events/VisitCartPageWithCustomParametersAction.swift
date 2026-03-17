//
//  VisitCartPageWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a cart page visit with custom parameters via the Insider SDK.
public struct VisitCartPageWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Cart Page (Custom)"

    /// Creates a sample product, assembles custom parameters, and reports a cart page visit to the Insider SDK.
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
            "cart_total": 99.99,
            "item_count": 1,
            "discount_applied": false
        ]
        Insider.visitCartPage(withProducts: [product], customParameters: customParameters)
    }
}
