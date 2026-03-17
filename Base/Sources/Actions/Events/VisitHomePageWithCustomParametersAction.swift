//
//  VisitHomePageWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a home page visit with custom parameters via the Insider SDK.
public struct VisitHomePageWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Homepage (Custom)"

    /// Assembles custom parameters and reports a home page visit to the Insider SDK.
    public func execute() {
        let customParameters: [String: Any] = [
            "source": "demo",
            "campaign_id": "campaign_123",
            "page_number": 1
        ]
        Insider.visitHomepage(withCustomParameters: customParameters)
    }
}
