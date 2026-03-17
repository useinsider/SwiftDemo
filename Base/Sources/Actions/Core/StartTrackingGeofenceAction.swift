//
//  StartTrackingGeofenceAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderGeofence

/// An action that enables background location updates and starts geofence tracking via the Insider Geofence SDK.
public struct StartTrackingGeofenceAction: Action {

    /// The display title for this action.
    public let title: String = "Start Tracking Geofence"

    /// Enables background location updates and starts geofence tracking.
    public func execute() {
        InsiderGeofence.setAllowsBackgroundLocationUpdates(true)
        InsiderGeofence.startTracking()
    }
}
