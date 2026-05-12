//
//  EnableIPCollectionAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that enables or disables IP address collection via the Insider SDK.
public struct EnableIPCollectionAction: Action {

    /// The display title reflecting the current enabled state.
    public let title: String

    /// Whether IP collection should be enabled.
    private let enabled: Bool

    /// Initializes the action with the desired IP collection state.
    /// - Parameter enabled: `true` to enable IP collection, `false` to disable it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "Enable IP Collection (\(enabled))"
    }

    /// Executes the action by toggling IP collection on the Insider SDK.
    public func execute() {
        Insider.enableIpCollection(enabled)
    }
}
