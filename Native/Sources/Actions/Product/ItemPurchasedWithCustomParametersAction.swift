//
//  ItemPurchasedWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product purchase event with custom parameters via the Insider SDK.
public struct ItemPurchasedWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Item Purchased (Custom)"

    /// Creates a sample product, assembles custom parameters, and reports a purchase event with a sale ID to the Insider SDK.
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
            "payment_method": "credit_card",
            "discount_applied": true,
            "shipping_method": "express"
        ]
        Insider.itemPurchased(withSaleID: "sale_123", product: product, customParameters: customParameters)
    }
}
