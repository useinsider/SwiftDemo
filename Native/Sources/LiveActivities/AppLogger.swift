//
//  AppLogger.swift
//  Example
//

import Foundation

@MainActor
public final class AppLogger {

    public static let shared = AppLogger()

    public static let didLogNotification = Notification.Name("Example.AppLogger.didLog")

    public enum Level: String {
        case info = "INFO"
        case warn = "WARN"
        case error = "ERROR"
    }

    public struct Entry {
        public let timestamp: Date
        public let level: Level
        public let message: String
    }

    private(set) public var entries: [Entry] = []

    private init() {}

    public func log(_ message: String, level: Level = .info) {
        let entry = Entry(timestamp: Date(), level: level, message: message)
        entries.append(entry)
        Swift.print("[\(level.rawValue)] \(message)")
        NotificationCenter.default.post(name: AppLogger.didLogNotification, object: entry)
    }

    public func clear() {
        entries.removeAll()
        NotificationCenter.default.post(name: AppLogger.didLogNotification, object: nil)
    }
}
