
import Foundation

public enum AskarError: LocalizedError {
    case nativeError(code: Int64)

    public var errorDescription: String? {
        switch self {
        case .nativeError(let code):
            return "Askar error code: \(code)"
        }
    }
}
