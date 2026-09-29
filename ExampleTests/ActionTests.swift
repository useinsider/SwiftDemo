
import XCTest
@testable import ExampleSPM

private struct StubAction: Action {
    let title: String

    @MainActor func execute() {}
}

private struct OtherStubAction: Action {
    let title: String

    @MainActor func execute() {}
}

final class ActionTests: XCTestCase {

    func testAccessibilityIdentifierSanitisesTitle() {
        let cases: [(title: String, expected: String)] = [
            ("Run Custom Action", "run_custom_action"),
            ("E-mail", "e_mail"),
            ("  Warm-up \n", "warm_up"),
            ("Logout (Reset ID)", "logout__reset_id"),
            ("Enable IP Collection (true)", "enable_ip_collection__true"),
            ("A/B Test!", "a_b_test"),
            ("Twitter ID", "twitter_id")
        ]
        for (title, expected) in cases {
            XCTAssertEqual(StubAction(title: title).accessibilityIdentifier, expected, "title: \(title)")
        }
    }

    func testAccessibilityIdentifierContainsOnlyLowercaseAlphanumericsAndUnderscores() {
        let allowed = CharacterSet.lowercaseLetters.union(.decimalDigits).union(CharacterSet(charactersIn: "_"))
        let identifier = StubAction(title: "Content String (Cache) — v2.0 #1").accessibilityIdentifier
        XCTAssertFalse(identifier.isEmpty)
        XCTAssertTrue(identifier.unicodeScalars.allSatisfy(allowed.contains), identifier)
    }

    func testAnyActionForwardsTitleAndAccessibilityIdentifier() {
        let action = AnyAction(StubAction(title: "Visit Cart Page (Custom)"))
        XCTAssertEqual(action.title, "Visit Cart Page (Custom)")
        XCTAssertEqual(action.accessibilityIdentifier, "visit_cart_page__custom")
    }

    func testAnyActionEqualityIsTitleBasedAcrossConcreteTypes() {
        XCTAssertEqual(AnyAction(StubAction(title: "Login")), AnyAction(OtherStubAction(title: "Login")))
        XCTAssertNotEqual(AnyAction(StubAction(title: "Login")), AnyAction(StubAction(title: "Logout")))
    }

    func testAnyActionHashMatchesWrappedActionHash() {
        let lhs = AnyAction(StubAction(title: "Login"))
        let rhs = AnyAction(OtherStubAction(title: "Login"))
        XCTAssertEqual(lhs.hashValue, rhs.hashValue)
        XCTAssertEqual(lhs.hashValue, StubAction(title: "Login").hashValue)
        XCTAssertEqual(Set([lhs, rhs, AnyAction(StubAction(title: "Logout"))]).count, 2)
    }
}
