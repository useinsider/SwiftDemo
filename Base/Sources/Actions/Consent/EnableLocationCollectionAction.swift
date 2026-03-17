//
//  EnableLocationCollectionAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that enables or disables location data collection via the Insider SDK.
public struct EnableLocationCollectionAction: Action {

    /// The display title reflecting the current enabled state.
    public let title: String

    /// Whether location collection should be enabled.
    private let enabled: Bool

    /// Initializes the action with the desired location collection state.
    /// - Parameter enabled: `true` to enable location collection, `false` to disable it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "Enable Location Collection (\(enabled))"
    }

    /// Executes the action by toggling location collection on the Insider SDK.
    public func execute() {
        Insider.enableLocationCollection(enabled)
    }
}
