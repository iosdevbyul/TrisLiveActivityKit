import ActivityKit
import XCTest
@testable import TrisLiveActivityKit

@available(iOS 17.0, *)
final class LiveActivityServiceTests: XCTestCase {
    func testErrorDescriptions() {
        XCTAssertEqual(
            LiveActivityError.activitiesDisabled.errorDescription,
            "Live Activities are disabled for this app or device."
        )
        XCTAssertEqual(
            LiveActivityError.activityNotFound("missing").errorDescription,
            "Live Activity not found: missing"
        )
    }

    func testLookupForUnknownActivityReturnsEmpty() {
        let service = LiveActivityService()
        XCTAssertTrue(service.activeIDs(for: ExampleAttributes.self).isEmpty)
    }

    func testUpdatingUnknownActivityThrows() async {
        let service = LiveActivityService()
        do {
            try await service.update(
                id: "non-existent-activity",
                as: ExampleAttributes.self,
                state: .init(value: 1)
            )
            XCTFail("Expected a missing-activity error")
        } catch {
            XCTAssertEqual(error as? LiveActivityError, .activityNotFound("non-existent-activity"))
        }
    }
}

private struct ExampleAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var value: Int
    }

    var title: String = "Example"
}
