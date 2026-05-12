//
//  VisitListingPageAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderMobile

/// An action that tracks a listing page visit with a given taxonomy via the Insider SDK.
public struct VisitListingPageAction: Action {

    /// The display title for this action.
    public let title: String = "Visit Listing Page"
    /// The taxonomy hierarchy used to categorize the listing page.
    private let taxonomy: [String]

    /// Creates a new listing page visit action.
    /// - Parameter taxonomy: An array of taxonomy strings representing the category hierarchy.
    public init(taxonomy: [String]) {
        self.taxonomy = taxonomy
    }

    /// Reports a listing page visit event with the configured taxonomy to the Insider SDK.
    public func execute() {
        Insider.visitListingPage(withTaxonomy: taxonomy)
    }
}
