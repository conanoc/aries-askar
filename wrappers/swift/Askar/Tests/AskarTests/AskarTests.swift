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

    func testStore() async throws {
        var out: UnsafePointer<CChar>?
        let error = askar_store_generate_raw_key(ByteBuffer(), &out)
        XCTAssertEqual(error, Success)
        let key = String(cString: out!)
        print("key: \(key)")
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let storeURL = temporaryDirectoryURL.appendingPathComponent("test.db")
        print("storeURL: \(storeURL.path)")
        let store = try await Store.provision(path: "sqlite://" + storeURL.path, keyMethod: "raw", passKey: key, recreate: true)

        XCTAssertNotNil(store)
        //test if file exist at storeURL
        
    }
}
