import Foundation
import AskarFramework

public class Session {
    let _handle: SessionHandle
    private static var continuation: CheckedContinuation<Any, Error>?

    public init(handle: SessionHandle) {
        self._handle = handle
    }

    public func count(category: String, tagFilter: String) async throws -> Int {
        let count = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_count(_handle, category, tagFilter, { (_, err, count) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: count)
                }
            }, 0)
        } as! Int

        return count
    }

    public func fetch(category: String, name: String, forUpdate: Bool) async throws -> Entry? {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_fetch(_handle, category, name, forUpdate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: handle)
                }
            }, 0)
        } as! EntryListHandle

        return try EntryList(handle: handle).next()
    }

    public func fetchAll(category: String, tagFilter: String? = nil, limit: Int = -1, forUpdate: Bool) async throws -> EntryList {
        let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_fetch_all(_handle, category, tagFilter, Int64(limit), forUpdate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: handle)
                }
            }, 0)
        } as! EntryListHandle

        return try EntryList(handle: handle)
    }

    public func update(operation: EntryOperation, category: String, name: String, value: String? = nil, tags: String? = nil, expiryMillis: Int = -1) async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_update(_handle, operation.rawValue, category, name, ByteBuffer(fromString: value), tags, Int64(expiryMillis), { (_, err) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: ())
                }
            }, 0)
        }
    }

    public func insertKey(_ key: Key, name: String, meta: String? = nil, tags: String? = nil, expiryMillis: Int = -1) async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_insert_key(_handle, key.handle, name, meta, tags, Int64(expiryMillis), { (_, err) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: ())
                }
            }, 0)
        }
    }

    public func fetchKey(name: String, forUpdate: Bool = false) async throws -> KeyEntry? {
        if let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_fetch_key(_handle, name, forUpdate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: handle)
                }
            }, 0)
        } as? KeyEntryListHandle {
            return try KeyEntryList(handle: handle).next()
        } else {
            return nil
        }
    }

    public func fetchAllKeys(alg: KeyAlg? = nil, thumbprint: String? = nil, tagFilter: String? = nil, limit: Int = -1, forUpdate: Bool = false) async throws -> KeyEntryList? {
        if let handle = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_fetch_all_keys(_handle, alg?.rawValue, thumbprint, tagFilter, Int64(limit), forUpdate ? 1:0, { (_, err, handle) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: handle)
                }
            }, 0)
        } as? KeyEntryListHandle {
            return try KeyEntryList(handle: handle)
        } else {
            return nil
        }
    }

    public func updateKey(name: String, meta: String? = nil, tags: String? = nil, expiryMillis: Int = -1) async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_update_key(_handle, name, meta, tags, Int64(expiryMillis), { (_, err) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: ())
                }
            }, 0)
        }
    }

    public func removeKey(name: String) async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_remove_key(_handle, name, { (_, err) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: ())
                }
            }, 0)
        }
    }

    public func close() async throws {
        _ = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Any, Error>) in
            Session.continuation = continuation
            askar_session_close(_handle, 0, { (_, err) in
                if err != Success {
                    Session.continuation?.resume(throwing: AskarError.nativeError(code: err.rawValue))
                } else {
                    Session.continuation?.resume(returning: ())
                }
            }, 0)
        }
    }
}
