//
//  ItemPurchasedAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product purchase event via the Insider SDK.
public struct ItemPurchasedAction: Action {

    /// The display title for this action.
    public let title: String = "Item Purchased"

    /// Creates a sample product and reports it as purchased with a sale ID using the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        Insider.itemPurchased(withSaleID: "SALE-12345", product: product)
    }
}
