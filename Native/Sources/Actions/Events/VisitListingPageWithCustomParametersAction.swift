//
//  VisitListingPageWithCustomParametersAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a listing page visit with custom parameters via the Insider SDK.
public struct VisitListingPageWithCustomParametersAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Listing Page (Custom)"

    /// Builds a taxonomy and custom parameters, then reports a listing page visit to the Insider SDK.
    public func execute() {
        let taxonomy = ["Electronics", "Smartphones", "iPhone"]
        let customParameters: [String: Any] = [
            "page_number": 1,
            "sort_by": "price",
            "filter_applied": true
        ]
        Insider.visitListingPage(withTaxonomy: taxonomy, customParameters: customParameters)
    }
}
