import Foundation

public extension Double {
    var euroString: String {
        return String(format: "%.2f€", self)
    }
}
