import XCTest
@testable import Askar

final class StoreTests: XCTestCase {
    var store: Store!
    let TEST_ENTRY = [
        "category": "test category",
        "name": "test name",
        "value": "test_value",
        "tags": "{\"~plaintag\": \"a\", \"enctag\": [\"b\", \"c\"]}"
    ]

    override func setUp() async throws {
        try await super.setUp()

        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let storeURL = temporaryDirectoryURL.appendingPathComponent("test.db")
        let key = try Store.generateRawKey()
        store = try await Store.provision(path: storeURL.path, keyMethod: "raw", passKey: key, recreate: true)
        try await store.doOpenSession()
    }

    override func tearDown() async throws {
        try await Store.remove(path: store.path)
        try await super.tearDown()
    }

    func testInsertUpdate() async throws {
        let session = store.openSession!
        try await session.update(
            operation: EntryOperation.INSERT,
            category: TEST_ENTRY["category"]!,
            name: TEST_ENTRY["name"]!,
            value: TEST_ENTRY["value"]!,
            tags: TEST_ENTRY["tags"]!)
            
        let count = try await session.count(category: TEST_ENTRY["category"]!,
                                            tagFilter: "{\"~plaintag\": \"a\", \"enctag\": \"b\"}")
        XCTAssertEqual(count, 1)
    }
}
