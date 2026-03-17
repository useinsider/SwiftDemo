//
//  ItemRemovedFromCartWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product removal from the cart with custom parameters via the Insider SDK.
public struct ItemRemovedFromCartWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Remove from Cart (Custom)"

    /// Assembles custom parameters and reports a product removal from cart by product ID using the Insider SDK.
    public func execute() {
        let customParameters: [String: Any] = [
            "reason": "out_of_stock",
            "cart_total_after": 0.0
        ]
        Insider.itemRemovedFromCart(withProductID: "demo_product_123", customParameters: customParameters)
    }
}
