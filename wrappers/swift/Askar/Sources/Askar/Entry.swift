import Foundation
import AskarFramework

public struct Entry {
    let list: EntryListHandle
    let pos: Int32

    public init(list: EntryListHandle, pos: Int32) {
        self.list = list
        self.pos = pos
    }

    var name: String {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_entry_list_get_name(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get entry name")
            }

            let name = String(cString: out)
            return name
        }
    }
    var category: String {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_entry_list_get_category(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get entry category")
            }

            let category = String(cString: out)
            return category
        }
    }
    var value: Data {
        get throws {
            var buf = SecretBuffer()
            let error = askar_entry_list_get_value(list, pos, &buf)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }

            return buf.toData()
        }
    }
    var tags: [String: String] {
        get throws {
            var out: UnsafePointer<CChar>?
            let error = askar_entry_list_get_tags(list, pos, &out)
            if error != Success {
                throw AskarError.nativeError(code: error.rawValue)
            }
            guard let out = out else {
                throw AskarError.wrapperError(message: "Failed to get entry tags")
            }

            let tagsJson = String(cString: out)
            return try JSONDecoder().decode([String: String].self, from: tagsJson.data(using: .utf8)!)
        }
    }
}

public class EntryList: IteratorProtocol {
    let handle: EntryListHandle
    let length: Int32
    private var pos: Int32 = 0

    public init(handle: EntryListHandle) throws {
        self.handle = handle
        var len: Int32 = 0
        let error = askar_entry_list_count(handle, &len)
        if error != Success {
            throw AskarError.nativeError(code: error.rawValue)
        }
        self.length = len
    }

    public func next() -> Entry? {
        if pos >= length {
            return nil
        }

        let entry = Entry(list: handle, pos: pos)
        pos += 1
        return entry
    }

    deinit {
        askar_entry_list_free(handle)
    }
}
