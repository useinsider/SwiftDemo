//
//  WorkoutActivityAttributes.swift
//  Example
//

import ActivityKit
import InsiderLiveActivities

@available(iOS 16.1, *)
public enum WorkoutPhase: String, Codable, Hashable, CaseIterable, Sendable {
    case warmup
    case active
    case paused
    case cooldown
    case finished

    public var displayName: String {
        switch self {
        case .warmup:   return "Warm-up"
        case .active:   return "Active"
        case .paused:   return "Paused"
        case .cooldown: return "Cool-down"
        case .finished: return "Finished"
        }
    }

    public var symbolName: String {
        switch self {
        case .warmup:   return "flame"
        case .active:   return "figure.run"
        case .paused:   return "pause.circle"
        case .cooldown: return "wind"
        case .finished: return "checkmark.seal.fill"
        }
    }
}

@available(iOS 16.1, *)
public struct WorkoutActivityAttributes: InsiderLiveActivitiesAttributes {

    public let insiderLiveActivityId: InsiderLiveActivityIdentifier
    public let workoutType: String

    public init(insiderLiveActivityId: InsiderLiveActivityIdentifier, workoutType: String) {
        self.insiderLiveActivityId = insiderLiveActivityId
        self.workoutType = workoutType
    }

    public struct ContentState: Codable, Hashable, Sendable {
        public var phase: WorkoutPhase
        public var elapsedSeconds: Int
        public var calories: Int

        public init(phase: WorkoutPhase, elapsedSeconds: Int, calories: Int) {
            self.phase = phase
            self.elapsedSeconds = elapsedSeconds
            self.calories = calories
        }
    }
}
