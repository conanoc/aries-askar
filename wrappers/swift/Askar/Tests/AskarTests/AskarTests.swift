import XCTest
@testable import Askar
import AskarFramework

final class AskarTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Askar().text, "Hello, World!")
        
        XCTAssertEqual(ErrorCode(rawValue: 0), Success)
    }

    func testStore() throws {
    }
}
