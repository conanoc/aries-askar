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
        var store = try await Store.provision(path: storeURL.path, keyMethod: "raw", passKey: key, recreate: true)

        XCTAssertNotNil(store)
        XCTAssertTrue(FileManager.default.fileExists(atPath: storeURL.path))

        try await store.close()

        store = try await Store.open(path: storeURL.path, keyMethod: "raw", passKey: key)
        try await store.close()

        try await Store.remove(path: storeURL.path)
        XCTAssertFalse(FileManager.default.fileExists(atPath: storeURL.path))
    }

    func testByteBuffer() throws {
        let str = "hello"
        var buf = FfiByteBuffer(fromString: str)
        let data2 = buf.buffer.toData()
        let str2 = String(data: data2, encoding: .utf8)
        XCTAssertEqual(str, str2)
    }
}
