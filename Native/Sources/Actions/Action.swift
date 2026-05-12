//
//  Action.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import Foundation

/// A protocol that defines a user-triggered action with a displayable title and executable behavior.
public protocol Action: Hashable, Sendable {

    /// The human-readable title describing this action.
    var title: String { get }

    /// Sets additional input needed before executing the action.
    /// - Parameter input: The input string to configure the action with.
    @MainActor mutating func setInput(_ input: String)

    /// Executes the action's primary behavior.
    @MainActor func execute()
}

extension Action {

    /// Default no-op implementation for actions that do not require input.
    /// - Parameter input: The input string (ignored in the default implementation).
    public mutating func setInput(_ input: String) { /* no-op */ }

    /// Hashes the action by its title.
    /// - Parameter hasher: The hasher to use when combining the components of this action.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }

    /// Compares two actions for equality based on their titles.
    /// - Parameters:
    ///   - lhs: The left-hand side action.
    ///   - rhs: The right-hand side action.
    /// - Returns: `true` if both actions have the same title; otherwise, `false`.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title
    }

    /// A sanitized, underscore-separated identifier derived from the title, suitable for accessibility testing.
    public var accessibilityIdentifier: String {
        return title.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
            .components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_")).inverted)
            .lazy
            .filter { !$0.isEmpty }
            .joined(separator: "_")
    }
}
