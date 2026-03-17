//
//  GetContentStringWithoutCacheAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that retrieves a string value from the Insider content optimizer without using the cache.
public struct GetContentStringWithoutCacheAction: Action {

    /// The display title for this action.
    public let title: String = "Content String"

    /// The content variable name used to look up the string value.
    private var input: String = String()

    /// Sets the content variable name to query.
    /// - Parameter input: The name of the content variable.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the non-cached string content retrieval via the Insider SDK and prints the result.
    public func execute() {
        let result = Insider.getContentStringWithoutCache(
            input,
            defaultString: "Default String Value",
            dataType: .content
        )
        print(String(describing: result))
    }
}
