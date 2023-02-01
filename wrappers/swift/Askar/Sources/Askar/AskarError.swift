import Foundation

public enum AskarError: LocalizedError {
    case nativeError(code: UInt32)
    case wrapperError(message: String)

    public var errorDescription: String? {
        switch self {
        case .nativeError(let code):
            return "Askar error code: \(code)"
        case .wrapperError(let message):
            return message
        }
    }
}
