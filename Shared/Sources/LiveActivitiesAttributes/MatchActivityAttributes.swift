//
//  MatchActivityAttributes.swift
//  Example
//

import ActivityKit
import InsiderLiveActivities

@available(iOS 16.1, *)
public enum MatchPeriod: String, Codable, Hashable, CaseIterable, Sendable {
    case firstHalf = "first_half"
    case halfTime = "half_time"
    case secondHalf = "second_half"
    case fullTime = "full_time"

    public var displayName: String {
        switch self {
        case .firstHalf:  return "1st Half"
        case .halfTime:   return "Half Time"
        case .secondHalf: return "2nd Half"
        case .fullTime:   return "Full Time"
        }
    }

    public var symbolName: String {
        switch self {
        case .firstHalf:  return "1.circle.fill"
        case .halfTime:   return "pause.circle.fill"
        case .secondHalf: return "2.circle.fill"
        case .fullTime:   return "flag.checkered"
        }
    }
}

@available(iOS 16.1, *)
public struct MatchActivityAttributes: InsiderLiveActivitiesAttributes {

    public let insiderLiveActivityId: InsiderLiveActivityIdentifier
    public let homeTeam: String
    public let awayTeam: String

    public init(insiderLiveActivityId: InsiderLiveActivityIdentifier, homeTeam: String, awayTeam: String) {
        self.insiderLiveActivityId = insiderLiveActivityId
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }

    public struct ContentState: Codable, Hashable, Sendable {
        public var homeScore: Int
        public var awayScore: Int
        public var period: MatchPeriod
        public var minute: Int

        public init(homeScore: Int, awayScore: Int, period: MatchPeriod, minute: Int) {
            self.homeScore = homeScore
            self.awayScore = awayScore
            self.period = period
            self.minute = minute
        }
    }
}
