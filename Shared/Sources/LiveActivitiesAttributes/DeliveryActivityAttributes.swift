//
//  DeliveryActivityAttributes.swift
//  Example
//

import ActivityKit
import InsiderLiveActivities

@available(iOS 16.1, *)
public enum DeliveryStatus: String, Codable, Hashable, CaseIterable, Sendable {
    case pickup
    case inTransit = "in_transit"
    case outForDelivery = "out_for_delivery"
    case delivered

    public var displayName: String {
        switch self {
        case .pickup:         return "Pickup"
        case .inTransit:      return "In transit"
        case .outForDelivery: return "Out for delivery"
        case .delivered:      return "Delivered"
        }
    }

    public var symbolName: String {
        switch self {
        case .pickup:         return "shippingbox"
        case .inTransit:      return "truck.box"
        case .outForDelivery: return "mappin.and.ellipse"
        case .delivered:      return "checkmark.seal.fill"
        }
    }
}

@available(iOS 16.1, *)
public struct DeliveryActivityAttributes: InsiderLiveActivitiesAttributes {

    public let insiderLiveActivityId: InsiderLiveActivityIdentifier
    public let courierName: String

    public init(insiderLiveActivityId: InsiderLiveActivityIdentifier, courierName: String) {
        self.insiderLiveActivityId = insiderLiveActivityId
        self.courierName = courierName
    }

    public struct ContentState: Codable, Hashable, Sendable {
        public var status: DeliveryStatus
        public var etaMinutes: Int

        public init(status: DeliveryStatus, etaMinutes: Int) {
            self.status = status
            self.etaMinutes = etaMinutes
        }
    }
}
