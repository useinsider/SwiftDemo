//
//  VisitCartPageAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a cart page visit with sample products via the Insider SDK.
public struct VisitCartPageAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Cart Page"

    /// Creates sample products and reports a cart page visit to the Insider SDK.
    public func execute() {
        let product1 = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product 1",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image1.jpg",
            price: 99.99,
            currency: "USD"
        )

        let product2 = Insider.createNewProduct(
            withID: "2",
            name: "Sample Product 2",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image2.jpg",
            price: 149.99,
            currency: "USD"
        )
        Insider.visitCartPage(withProducts: [product1!, product2!])
    }
}
