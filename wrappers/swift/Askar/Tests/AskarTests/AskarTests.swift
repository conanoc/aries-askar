import XCTest
@testable import Askar
import AskarFramework

final class AskarTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(Askar().text, "Hello, World!")
        XCTAssertEqual(ErrorCode(rawValue: 0), Success)
    }

    func testStore() async throws {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let storeURL = temporaryDirectoryURL.appendingPathComponent("test.db")
        let key = try Store.generateRawKey()
        let store = try await Store.provision(path: "sqlite://" + storeURL.path, keyMethod: "raw", passKey: key, recreate: true)

        XCTAssertNotNil(store)
        XCTAssertTrue(FileManager.default.fileExists(atPath: storeURL.path))
    }
}
