//
//  GetContentBoolAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that retrieves a boolean value from the Insider content optimizer using the cache.
public struct GetContentBoolAction: Action {

    /// The display title for this action.
    public let title: String = "Content Bool (Cache)"

    /// The content variable name used to look up the boolean value.
    private var input: String = String()

    /// Sets the content variable name to query.
    /// - Parameter input: The name of the content variable.
    public mutating func setInput(_ input: String) {
        self.input = input
    }

    /// Executes the cached boolean content retrieval via the Insider SDK and prints the result.
    public func execute() {
        let result = Insider.getContentBool(
            withName: input,
            defaultBool: true,
            dataType: .content
        )
        print(result)
    }
}
