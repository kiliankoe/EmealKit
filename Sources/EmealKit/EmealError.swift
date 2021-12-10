import Foundation

public enum EmealError: Error {
    case other(Error)
    case unknown
}

extension EmealError: LocalizedError {
    public var errorDescription: String? {
        if case .other(let error) = self {
            return error.localizedDescription
        }
        return String(describing: self)
    }
}
