import XCTest
@testable import bluesky

final class blueskyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(bluesky().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
