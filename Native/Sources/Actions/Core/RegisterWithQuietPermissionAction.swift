//
//  RegisterWithQuietPermissionAction.swift
//  Example
//
//  Created by Insider on 6.11.2025.
//

import InsiderMobile

/// An action that registers the device for Apple Push Notification service (APNs) via the Insider SDK.
public struct RegisterWithQuietPermissionAction: Action {

    /// The display title for this action.
    public let title: String = "Register for APNS"

    /// Registers the device for push notifications without quiet permission.
    public func execute() {
        Insider.register(withQuietPermission: false)
    }
}
