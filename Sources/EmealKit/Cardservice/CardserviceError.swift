import Foundation

public enum CardserviceError: Error {
    case network(Error?)
    case invalidURL
    case noCardDetails
    case invalidLoginCredentials
    case rateLimited
    case server(statusCode: Int)
    case decoding(CardServiceDecodingError)
}

extension CardserviceError: LocalizedError {
    private var underlyingError: Error? {
        switch self {
        case .network(let error):
            return error
        case .decoding(let error):
            return error
        default:
            return nil
        }
    }

    public var errorDescription: String? {
        if let underlyingError = underlyingError {
            return underlyingError.localizedDescription
        }
        return String(describing: self)
    }
}

public enum CardServiceDecodingError: Error {
    case unknownPaymentType(String)
    case unexpectedDateFormat(String)
    case other(Error)
}

extension CardServiceDecodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknownPaymentType(let paymentType):
            switch Locale.current.languageCode {
            case "de":
                return "Unbekannter Zahlungstyp '\(paymentType)'."
            default:
                return "Unknown payment type '\(paymentType)'."
            }
        case .unexpectedDateFormat(let date):
            switch Locale.current.languageCode {
            case "de":
                return "Unerwartetes Datumsformat '\(date)'."
            default:
                return "Unexpected date format '\(date)'."
            }
        case .other(let error):
            return error.localizedDescription
        }
    }
}

