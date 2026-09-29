
import XCTest
@testable import ExampleSPM

@MainActor
final class MainViewControllerActionsTests: XCTestCase {

    private var sections: [(name: String, actions: [AnyAction])] {
        let controller = MainViewController()
        return [
            ("Custom", [AnyAction(CustomAction())]),
            ("Core", controller.coreActions),
            ("Live Activities", controller.liveActivitiesActions),
            ("Reinit", [AnyAction(ReinitAction())]),
            ("Consent", controller.consentActions),
            ("User", controller.userActions),
            ("User Attributes", controller.userAttributesActions),
            ("Inapp", controller.inappActions),
            ("Event", controller.eventActions),
            ("Product", controller.productActions),
            ("Wishlist", controller.wishlistActions),
            ("Content Optimizer", controller.contentOptimizerActions)
        ]
    }

    func testEverySectionHasActions() {
        for section in sections {
            XCTAssertFalse(section.actions.isEmpty, "section \(section.name) is empty")
        }
    }

    func testActionTitlesAreUniqueWithinEachSection() {
        for section in sections {
            let duplicates = duplicated(section.actions.map(\.title))
            XCTAssertTrue(duplicates.isEmpty, "section \(section.name) has duplicate titles: \(duplicates)")
        }
    }

    // One diffable snapshot holds every section and AnyAction equality is title-based, so a
    // duplicate anywhere crashes the snapshot apply.
    func testActionTitlesAreUniqueAcrossSections() {
        let duplicates = duplicated(sections.flatMap(\.actions).map(\.title))
        XCTAssertTrue(duplicates.isEmpty, "duplicate titles across sections: \(duplicates)")
    }

    func testAccessibilityIdentifiersAreNonEmptyAndUnique() {
        let identifiers = sections.flatMap(\.actions).map(\.accessibilityIdentifier)
        XCTAssertFalse(identifiers.contains(""), "an action has an empty accessibility identifier")
        let duplicates = duplicated(identifiers)
        XCTAssertTrue(duplicates.isEmpty, "duplicate accessibility identifiers: \(duplicates)")
    }

    private func duplicated(_ values: [String]) -> [String] {
        Dictionary(grouping: values, by: { $0 }).filter { $0.value.count > 1 }.keys.sorted()
    }
}
