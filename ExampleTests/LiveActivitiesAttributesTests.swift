
import UIKit
import XCTest
@testable import ExampleSPM

final class LiveActivitiesAttributesTests: XCTestCase {

    func testDeliveryStatus() throws {
        try assertCodableRoundTrip(DeliveryStatus.self)
        assertPresentation(DeliveryStatus.self, displayName: \.displayName, symbolName: \.symbolName)
        XCTAssertEqual(DeliveryStatus.inTransit.rawValue, "in_transit")
        XCTAssertEqual(DeliveryStatus.outForDelivery.rawValue, "out_for_delivery")
    }

    func testMatchPeriod() throws {
        try assertCodableRoundTrip(MatchPeriod.self)
        assertPresentation(MatchPeriod.self, displayName: \.displayName, symbolName: \.symbolName)
        XCTAssertEqual(MatchPeriod.firstHalf.rawValue, "first_half")
        XCTAssertEqual(MatchPeriod.fullTime.rawValue, "full_time")
    }

    func testWorkoutPhase() throws {
        try assertCodableRoundTrip(WorkoutPhase.self)
        assertPresentation(WorkoutPhase.self, displayName: \.displayName, symbolName: \.symbolName)
    }

    func testContentStatesRoundTrip() throws {
        try assertRoundTrip(DeliveryActivityAttributes.ContentState(status: .outForDelivery, etaMinutes: 12))
        try assertRoundTrip(MatchActivityAttributes.ContentState(homeScore: 2, awayScore: 1, period: .secondHalf, minute: 67))
        try assertRoundTrip(WorkoutActivityAttributes.ContentState(phase: .cooldown, elapsedSeconds: 1800, calories: 320))
    }

    func testContentStateDecodesFromRawValueWireFormat() throws {
        let json = Data(#"{"homeScore":0,"awayScore":3,"period":"half_time","minute":45}"#.utf8)
        let state = try JSONDecoder().decode(MatchActivityAttributes.ContentState.self, from: json)
        XCTAssertEqual(state, .init(homeScore: 0, awayScore: 3, period: .halfTime, minute: 45))
    }

    private func assertCodableRoundTrip<T: Codable & Equatable & CaseIterable & RawRepresentable>(
        _ type: T.Type,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws where T.RawValue == String {
        for value in T.allCases {
            let data = try JSONEncoder().encode(value)
            XCTAssertEqual(String(decoding: data, as: UTF8.self), "\"\(value.rawValue)\"", file: file, line: line)
            XCTAssertEqual(try JSONDecoder().decode(T.self, from: data), value, file: file, line: line)
        }
    }

    private func assertRoundTrip<T: Codable & Equatable>(_ value: T, file: StaticString = #filePath, line: UInt = #line) throws {
        let data = try JSONEncoder().encode(value)
        XCTAssertEqual(try JSONDecoder().decode(T.self, from: data), value, file: file, line: line)
    }

    private func assertPresentation<T: CaseIterable>(
        _ type: T.Type,
        displayName: KeyPath<T, String>,
        symbolName: KeyPath<T, String>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let displayNames = T.allCases.map { $0[keyPath: displayName] }
        XCTAssertFalse(displayNames.contains(""), "\(T.self) has an empty displayName", file: file, line: line)
        XCTAssertEqual(Set(displayNames).count, displayNames.count, "\(T.self) displayNames collide", file: file, line: line)
        for value in T.allCases {
            let symbol = value[keyPath: symbolName]
            XCTAssertNotNil(UIImage(systemName: symbol), "\(T.self).\(value) symbol \(symbol) does not exist", file: file, line: line)
        }
    }
}
