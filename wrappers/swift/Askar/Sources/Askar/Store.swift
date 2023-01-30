
import Foundation
import AskarFramework

public class Store {
    private let handle: StoreHandle
    private let path: String
    private static var provisionContinuation: CheckedContinuation<StoreHandle, Error>?

    private init(handle: StoreHandle, path: String) {
        self.handle = handle
        self.path = path
    }

    public static func provision(path: String, keyMethod: String? = nil, passKey: String? = nil, profile: String? = nil, recreate: Bool = false) async throws -> Store {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<StoreHandle, Error>) in
            provisionContinuation = continuation
            askar_store_provision(path, keyMethod, passKey, profile, recreate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Store.provisionContinuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Store.provisionContinuation?.resume(returning: handle)
                }
            }, 0)
        }

        return Store(handle: handle, path: path)
    }

}
