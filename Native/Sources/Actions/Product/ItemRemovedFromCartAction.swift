//
//  ItemRemovedFromCartAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a product being removed from the shopping cart via the Insider SDK.
public struct ItemRemovedFromCartAction: Action {

    /// The display title for this action.
    public let title: String = "Remove Item from Cart"

    /// Reports a product removal from cart by product ID using the Insider SDK.
    public func execute() {
        Insider.itemRemovedFromCart(withProductID: "1")
    }
}
