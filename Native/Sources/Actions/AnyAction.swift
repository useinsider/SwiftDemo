//
//  AnyAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import Foundation

/// A type-erased wrapper around any `Action` conforming type, allowing heterogeneous actions to be stored and used uniformly.
public struct AnyAction: Hashable, Sendable {

    /// The underlying concrete action being wrapped.
    private var action: any Action

    /// Initializes a new type-erased action by wrapping the given concrete action.
    /// - Parameter action: The concrete action to wrap.
    public init<T: Action>(_ action: T) {
        self.action = action
    }

    /// Executes the wrapped action's primary behavior.
    @MainActor public func execute() {
        action.execute()
    }

    /// Sets additional input on the wrapped action.
    /// - Parameter input: The input string to pass to the underlying action.
    /// - Returns: The modified `AnyAction` instance with the input applied.
    @MainActor public mutating func setInput(_ input: String) -> Self {
        action.setInput(input)
        return self
    }

    /// The human-readable title of the wrapped action.
    public var title: String {
        return action.title
    }

    /// The accessibility identifier of the wrapped action.
    public var accessibilityIdentifier: String {
        return action.accessibilityIdentifier
    }

    /// Compares two type-erased actions for equality based on their titles.
    /// - Parameters:
    ///   - lhs: The left-hand side action.
    ///   - rhs: The right-hand side action.
    /// - Returns: `true` if both actions have the same title; otherwise, `false`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title
    }

    /// Hashes the type-erased action by delegating to the wrapped action's hash implementation.
    /// - Parameter hasher: The hasher to use when combining the components of this action.
    public func hash(into hasher: inout Hasher) {
        action.hash(into: &hasher)
    }
}

