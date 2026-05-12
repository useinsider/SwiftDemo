//
//  VisitWishlistAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a wishlist visit event with sample products via the Insider SDK.
public struct VisitWishlistAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Wishlist"

    /// Executes the visit wishlist operation by creating a sample product and reporting the visit via the Insider SDK.
    public func execute() {
        let product = Insider.createNewProduct(
            withID: "1",
            name: "Sample Product",
            taxonomy: ["Category", "Subcategory"],
            imageURL: "https://example.com/image.jpg",
            price: 99.99,
            currency: "USD"
        )
        Insider.visitWishlist(withProducts: [product!])
    }
}
