
import Foundation
import AskarFramework

public class Store {
    public static let URI_SCHEMA = "sqlite://"
    private let handle: StoreHandle
    private let path: String
    private static var continuation: CheckedContinuation<StoreHandle, Error>?

    private init(handle: StoreHandle, path: String) {
        self.handle = handle
        self.path = path
    }

    public static func provision(path: String, keyMethod: String? = nil, passKey: String? = nil, profile: String? = nil, recreate: Bool = false) async throws -> Store {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StoreHandle, Error>) in
            Store.continuation = continuation
            askar_store_provision(URI_SCHEMA + path, keyMethod, passKey, profile, recreate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Store.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Store.continuation?.resume(returning: handle)
                }
            }, 0)
        }

        return Store(handle: handle, path: path)
    }

    public static func generateRawKey() throws -> String {
        var out: UnsafePointer<CChar>?
        let error = askar_store_generate_raw_key(ByteBuffer(), &out)
        if error != Success {
            throw AskarError.nativeError(code: error.rawValue)
        }
        guard let out = out else {
            throw AskarError.wrapperError(message: "Failed to generate raw key")
        }

        let key = String(cString: out)
        return key
    }

    public static func open(path: String, keyMethod: String? = nil, passKey: String? = nil, profile: String? = nil) async throws -> Store {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StoreHandle, Error>) in
            Store.continuation = continuation
            askar_store_open(URI_SCHEMA + path, keyMethod, passKey, profile, { (_, err, handle) in
                if err != Success {
                    Store.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Store.continuation?.resume(returning: handle)
                }
            }, 0)
        }

        return Store(handle: handle, path: path)
    }

    public func close() async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StoreHandle, Error>) in
            Store.continuation = continuation
            askar_store_close(handle, { (_, err) in
                if err != Success {
                    Store.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Store.continuation?.resume(returning: StoreHandle(_0: 0))
                }
            }, 0)
        }
    }

    public static func remove(path: String) async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StoreHandle, Error>) in
            Store.continuation = continuation
            askar_store_remove(URI_SCHEMA + path, { (_, err, removed) in
                if err != Success {
                    Store.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else if removed == 0 {
                    Store.continuation?.resume(throwing: AskarError.wrapperError(message: "Failed to remove store"))
                } else {
                    Store.continuation?.resume(returning: StoreHandle(_0: 0))
                }
            }, 0)
        }
    }

}
