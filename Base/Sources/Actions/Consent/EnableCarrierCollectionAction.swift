//
//  EnableCarrierCollectionAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that enables or disables carrier information collection via the Insider SDK.
public struct EnableCarrierCollectionAction: Action {

    /// The display title reflecting the current enabled state.
    public let title: String

    /// Whether carrier collection should be enabled.
    private let enabled: Bool

    /// Initializes the action with the desired carrier collection state.
    /// - Parameter enabled: `true` to enable carrier collection, `false` to disable it.
    public init(enabled: Bool) {
        self.enabled = enabled
        self.title = "Enable Carrier Collection (\(enabled))"
    }

    /// Executes the action by toggling carrier collection on the Insider SDK.
    public func execute() {
        Insider.enableCarrierCollection(enabled)
    }
}
