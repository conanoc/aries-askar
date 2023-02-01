import Foundation
import AskarFramework

public struct KeyEntry {
    let list: KeyEntryListHandle
    let pos: Int32

    public init(list: KeyEntryListHandle, pos: Int32) {
        self.list = list
        self.pos = pos
    }

    public var algorithm: String {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_key_entry_list_get_algorithm(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get key entry algorithm")
            }

            let algorithm = String(cString: out)
            return algorithm
        }
    }

    public var name: String {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_key_entry_list_get_name(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get key entry name")
            }

            let name = String(cString: out)
            return name
        }
    }

    public var metadata: String {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_key_entry_list_get_metadata(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get key entry metadata")
            }

            let metadata = String(cString: out)
            return metadata
        }
    }

    public var tags: [String: String] {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_key_entry_list_get_tags(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get key entry tags")
            }

            let tagsJson = String(cString: out)
            return try JSONDecoder().decode([String: String].self, from: tagsJson.data(using: .utf8)!)
        }
    }
}

public class KeyEntryList: IteratorProtocol {
    let handle: KeyEntryListHandle
    let length: Int32
    private var pos: Int32 = 0

    public init(handle: KeyEntryListHandle) throws {
        self.handle = handle
        var len: Int32 = 0
        let error = askar_key_entry_list_count(handle, &len)
        if error != Success {
            throw AskarError.nativeError(code: error.rawValue)
        }
        self.length = len
    }

    public func next() -> KeyEntry? {
        if pos >= length {
            return nil
        }
        let entry = KeyEntry(list: handle, pos: pos)
        pos += 1
        return entry
    }

    deinit {
        askar_key_entry_list_free(handle)
    }
}
