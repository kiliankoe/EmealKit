import Foundation

enum OpeningHoursDateContext {
    static let berlinTimeZone = TimeZone(identifier: "Europe/Berlin") ?? .current

    static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = berlinTimeZone
        return calendar
    }
}
