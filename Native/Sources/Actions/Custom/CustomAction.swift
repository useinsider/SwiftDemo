//
//  CustomAction.swift
//  Example
//
//  Created by Insider on 17.11.2025.
//

import InsiderGeofence
import InsiderMobile

/// An action that runs a user-defined custom behavior, serving as a placeholder for ad-hoc testing or experimentation.
public struct CustomAction: Action {

    /// The display title for this custom action.
    public let title: String = "Run Custom Action"

    /// Executes the custom action logic.
    public func execute() {
        print("Run your custom action in here: \(#file):\(#line)")
        // e.g, Insider.reinit(withPartnerName: "qaautomation1")
    }
}
