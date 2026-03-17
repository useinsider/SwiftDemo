//
//  VisitProductDetailPageAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product detail page visit via the Insider SDK.
public struct VisitProductDetailPageAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Product Detail Page"

    /// Creates a sample product and reports a product detail page visit to the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        Insider.visitProductDetailPage(with: product)
    }
}
