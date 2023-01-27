
import Foundation
import AskarFramework

public class Store {
    private let handle: StoreHandle
    private let path: String
    
    private init(handle: StoreHandle, path: String) {
        self.handle = handle
        self.path = path
    }
    
    public static func provision(path: String, keyMethod: String? = nil, passKey: String? = nil, profile: String? = nil, recreate: Bool = false) async throws -> Store {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<OpaquePointer, Error>) in
            askar_store_provision(path, keyMethod, passKey, profile, recreate ? 1:0, { (_, err, handle) in
                if let err = err {
                    // TODO: define error
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(returning: handle!)
                }
            }, 0)
        }

        return Store(handle: handle, path: path)
    }
}
