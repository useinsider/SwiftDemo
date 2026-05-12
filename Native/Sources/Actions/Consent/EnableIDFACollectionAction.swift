//
//  EnableIDFACollectionAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that enables or disables IDFA (Identifier for Advertisers) collection via the Insider SDK.
public struct EnableIDFACollectionAction: Action {

    /// The display title reflecting the current enabled state.
    public let title: String

    /// Whether IDFA collection should be enabled.
    private let enabled: Bool

    /// Initializes the action with the desired IDFA collection state.
    /// - Parameter enabled: `true` to enable IDFA collection, `false` to disable it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "Enable IDFA Collection (\(enabled))"
    }

    /// Executes the action by toggling IDFA collection on the Insider SDK.
    public func execute() {
        Insider.enableIDFACollection(enabled)
    }
}
