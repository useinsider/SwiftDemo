//
//  GetContentIntWithoutCacheAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that retrieves an integer value from the Insider content optimizer without using the cache.
public struct GetContentIntWithoutCacheAction: Action {

    /// The display title for this action.
    public let title: String = "Content Int"

    /// The content variable name used to look up the integer value.
    private var input: String = String()

    /// Sets the content variable name to query.
    /// - Parameter input: The name of the content variable.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the non-cached integer content retrieval via the Insider SDK and prints the result.
    public func execute() {
        let result = Insider.getContentIntWithoutCache(
            input,
            defaultInt: 42,
            dataType: .content
        )
        print(result)
    }
}
