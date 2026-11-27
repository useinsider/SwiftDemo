//
//  PartnerContextFilter.swift
//  Example
//
//  Created by Insider on 26.11.2026.
//

import Foundation
import InsiderMobile

/// A sample of how a partner writes its own App Smart Recommender filter:
/// it adds one products request field the SDK has no filter class for.
public final class PartnerContextFilter: NSObject, InsiderAppSmartRecommenderFilterProtocol {

    /// The products request field the filter writes.
    public let key: String

    /// The value written under `key`.
    public let value: String

    /// Creates the filter.
    /// - Parameters:
    ///   - key: The products request field the filter writes.
    ///   - value: The value written under `key`.
    public init(key: String, value: String) {
        self.key = key
        self.value = value
        super.init()
    }

    /// Returns `[key: value]`; an empty key rejects the call, which the SDK reports as an invalid `filter` parameter.
    public func serialize() throws -> [String: Any] {
        guard !key.isEmpty else {
            throw NSError(
                domain: "PartnerContextFilter",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Partner filter key is empty."]
            )
        }
        return [key: value]
    }
}
