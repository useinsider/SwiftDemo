//
//  VisitProductDetailPageWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product detail page visit with custom parameters via the Insider SDK.
public struct VisitProductDetailPageWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Product Page (Custom)"

    /// Creates a sample product, assembles custom parameters, and reports a product detail page visit to the Insider SDK.
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
            "source": "search",
            "campaign_id": "campaign_123",
            "recommendation_id": "rec_456"
        ]
        Insider.visitProductDetailPage(with: product, customParameters: customParameters)
    }
}
