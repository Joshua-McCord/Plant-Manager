import XCTest
@testable import PlantManager

final class PlantManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(PlantManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
