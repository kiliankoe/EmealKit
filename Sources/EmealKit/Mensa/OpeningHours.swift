import Foundation

// MARK: - Data Models

public struct OpeningHours: Equatable, Codable {
    public let canteenName: String
    public let regularHours: [TimeSlot]
    public let changedHours: [TimeSlot]
    
    public init(canteenName: String, regularHours: [TimeSlot], changedHours: [TimeSlot]) {
        self.canteenName = canteenName
        self.regularHours = regularHours
        self.changedHours = changedHours
    }
    
    /// Returns the applicable time slots for a given date.
    /// If active changed hours provide parseable timing information or explicit closure notices,
    /// they override regular hours. Otherwise, regular hours are used as fallback.
    private func activeSlots(on date: Date) -> [TimeSlot] {
        let activeChangedHours = changedHours.filter { slot in
            guard let range = slot.dateRange else { return true }
            return range.isActive(on: date)
        }

        guard !activeChangedHours.isEmpty else { return regularHours }

        let hasActionableChangedHours = activeChangedHours.contains { slot in
            !slot.parsedHours.isEmpty || slot.isExplicitClosureNotice
        }

        return hasActionableChangedHours ? activeChangedHours : regularHours
    }

    /// Check if the canteen is open at a specific date/time
    public func isOpen(at date: Date = Date()) -> Bool {
        activeSlots(on: date).contains { $0.isOpen(at: date) }
    }

    /// Check if there are changed opening hours active at a specific date
    public func hasChangedHours(at date: Date = Date()) -> Bool {
        changedHours.contains { slot in
            guard let range = slot.dateRange else { return true }
            return range.isActive(on: date)
        }
    }
    
    /// Get the time when the canteen closes next (if currently open)
    /// Returns the EARLIEST closing time of any open service.
    public func closingTime(from date: Date = Date()) -> (Date?, String?) {
        let slots = activeSlots(on: date)

        let openSlots = slots.filter { $0.isOpen(at: date) }
        let sortedSlots = openSlots.sorted { slot1, slot2 in
            guard let close1 = slot1.closingTime(from: date), let close2 = slot2.closingTime(from: date) else { return false }
            return close1 < close2
        }

        if let bestSlot = sortedSlots.first {
            return (bestSlot.closingTime(from: date), bestSlot.area)
        }

        return (nil, nil)
    }
    
    /// Get the time when the canteen opens next (if currently closed)
    /// Returns the EARLIEST opening time of any service.
    public func openingTime(from date: Date = Date()) -> (Date?, String?) {
        let slots = activeSlots(on: date)

        var candidates: [(date: Date, slot: TimeSlot)] = []
        for slot in slots {
            if let range = slot.dateRange, !range.isActive(on: date) { continue }
            if let openTime = slot.openingTime(from: date) {
                candidates.append((openTime, slot))
            }
        }

        candidates.sort { $0.date < $1.date }

        if let best = candidates.first {
            return (best.date, best.slot.area)
        }

        return (nil, nil)
    }
    
    public struct TimeSlot: Equatable, Codable {
        public let area: String
        public let dateRange: DateRange?
        public let hoursText: String
        public let isRegular: Bool
        public let parsedHours: [WeekdayHours]
        
        public init(area: String, dateRange: DateRange?, hoursText: String, isRegular: Bool, parsedHours: [WeekdayHours]) {
            self.area = area
            self.dateRange = dateRange
            self.hoursText = hoursText
            self.isRegular = isRegular
            self.parsedHours = parsedHours
        }

        var isExplicitClosureNotice: Bool {
            let lowerText = hoursText.lowercased()
            return lowerText.contains("geschlossen") || lowerText.contains("closed")
        }
        
        /// Check if this time slot is active and open at a specific date/time
        public func isOpen(at date: Date = Date()) -> Bool {
            // Check if date range is active
            if let dateRange = dateRange, !dateRange.isActive(on: date) {
                return false
            }
            
            // Check if any parsed hours match
            for hours in parsedHours {
                if hours.isOpen(at: date) {
                    return true
                }
            }
            
            return false
        }
        
        /// Get closing time if currently open
        public func closingTime(from date: Date = Date()) -> Date? {
            // Check if date range is active (if present)
            if let dateRange = dateRange, !dateRange.isActive(on: date) {
                return nil
            }
            
            for hours in parsedHours {
                if hours.isOpen(at: date) {
                    return hours.closingTime(from: date)
                }
            }
            
            return nil
        }
        
        /// Get next opening time if currently closed
        public func openingTime(from date: Date = Date()) -> Date? {
            // Check if date range is active (if present)
            if let dateRange = dateRange, !dateRange.isActive(on: date) {
                return nil
            }
            
            // Find the earliest opening time
            var earliest: Date?
            for hours in parsedHours {
                if let openTime = hours.openingTime(from: date) {
                    if let current = earliest {
                        if openTime < current {
                            earliest = openTime
                        }
                    } else {
                        earliest = openTime
                    }
                }
            }
            
            return earliest
        }
    }
    
    public struct DateRange: Equatable, Codable {
        public let from: Date?
        public let to: Date?
        public let text: String
        
        public init(from: Date?, to: Date?, text: String) {
            self.from = from
            self.to = to
            self.text = text
        }
        
        public func isActive(on date: Date = Date()) -> Bool {
            let calendar = OpeningHoursDateContext.calendar
            let day = calendar.startOfDay(for: date)
            if let from = from, day < calendar.startOfDay(for: from) { return false }
            if let to = to, day > calendar.startOfDay(for: to) { return false }
            return true
        }
    }
    
    public struct WeekdayHours: Equatable, Codable {
        public let label: String?  // e.g. "Mittagstisch im Brat²", "Cafeteria Zebradiele"
        public let days: Set<Weekday>
        public let openTime: TimeOfDay
        public let closeTime: TimeOfDay
        
        public init(label: String? = nil, days: Set<Weekday>, openTime: TimeOfDay, closeTime: TimeOfDay) {
            self.label = label
            self.days = days
            self.openTime = openTime
            self.closeTime = closeTime
        }
        
        public func isOpen(on weekday: Weekday, at time: TimeOfDay) -> Bool {
            guard days.contains(weekday) else { return false }
            return time >= openTime && time <= closeTime
        }
        
        /// Check if open at a specific date/time
        public func isOpen(at date: Date = Date()) -> Bool {
            let calendar = OpeningHoursDateContext.calendar
            guard let weekday = Weekday.from(date: date, calendar: calendar) else { return false }
            let time = TimeOfDay.from(date: date, calendar: calendar)
            return isOpen(on: weekday, at: time)
        }
        
        /// Get closing time if currently open, nil otherwise
        public func closingTime(from date: Date = Date()) -> Date? {
            guard isOpen(at: date) else { return nil }
            
            let calendar = OpeningHoursDateContext.calendar
            var components = calendar.dateComponents([.year, .month, .day], from: date)
            components.hour = closeTime.hour
            components.minute = closeTime.minute
            components.timeZone = OpeningHoursDateContext.berlinTimeZone
            
            return calendar.date(from: components)
        }
        
        /// Get next opening time from given date
        public func openingTime(from date: Date = Date()) -> Date? {
            let calendar = OpeningHoursDateContext.calendar
            let currentWeekday = Weekday.from(date: date, calendar: calendar)
            let currentTime = TimeOfDay.from(date: date, calendar: calendar)
            
            // Check if we can open today
            if let weekday = currentWeekday, days.contains(weekday), currentTime < openTime {
                var components = calendar.dateComponents([.year, .month, .day], from: date)
                components.hour = openTime.hour
                components.minute = openTime.minute
                components.timeZone = OpeningHoursDateContext.berlinTimeZone
                return calendar.date(from: components)
            }
            
            // Find next day we're open
            for daysAhead in 1...7 {
                guard let futureDate = calendar.date(byAdding: .day, value: daysAhead, to: date),
                      let weekday = Weekday.from(date: futureDate, calendar: calendar),
                      days.contains(weekday) else {
                    continue
                }
                
                var components = calendar.dateComponents([.year, .month, .day], from: futureDate)
                components.hour = openTime.hour
                components.minute = openTime.minute
                components.timeZone = OpeningHoursDateContext.berlinTimeZone
                
                return calendar.date(from: components)
            }
            
            return nil
        }
    }
    
    public struct TimeOfDay: Equatable, Codable, Comparable {
        public let hour: Int
        public let minute: Int
        
        public init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
        
        public var totalMinutes: Int {
            hour * 60 + minute
        }
        
        public static func < (lhs: TimeOfDay, rhs: TimeOfDay) -> Bool {
            lhs.totalMinutes < rhs.totalMinutes
        }
        
        public var formatted: String {
            String(format: "%02d:%02d", hour, minute)
        }
        
        /// Create TimeOfDay from a Date
        public static func from(date: Date, calendar: Calendar = Calendar.current) -> TimeOfDay {
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            return TimeOfDay(hour: hour, minute: minute)
        }
    }
    
    /// Get statuses for all active services at a specific date
    public func serviceStatuses(at date: Date = Date()) -> [ServiceStatus] {
        var statuses: [ServiceStatus] = []

        for slot in activeSlots(on: date) {
            if let range = slot.dateRange, !range.isActive(on: date) { continue }

            if slot.isOpen(at: date) {
                if let closeDate = slot.closingTime(from: date) {
                    statuses.append(ServiceStatus(
                        area: slot.area,
                        isOpen: true,
                        timeUntilChange: closeDate.timeIntervalSince(date),
                        changeTime: closeDate,
                        totalDuration: slot.parsedHours.first(where: { $0.isOpen(at: date) })
                            .map { $0.closeTime.totalMinutes - $0.openTime.totalMinutes }
                            .map { TimeInterval($0 * 60) } ?? 3600
                    ))
                }
            } else {
                if let openDate = slot.openingTime(from: date) {
                    statuses.append(ServiceStatus(
                        area: slot.area,
                        isOpen: false,
                        timeUntilChange: openDate.timeIntervalSince(date),
                        changeTime: openDate,
                        totalDuration: 0
                    ))
                }
            }
        }

        return statuses.sorted {
            if $0.isOpen != $1.isOpen { return $0.isOpen }
            return $0.timeUntilChange < $1.timeUntilChange
        }
    }
    
    public struct ServiceStatus: Identifiable {
        public let id = UUID()
        public let area: String
        public let isOpen: Bool
        public let timeUntilChange: TimeInterval
        public let changeTime: Date
        public let totalDuration: TimeInterval
    }
    
    public enum Weekday: String, Codable, CaseIterable, Hashable {
        case monday = "Mo"
        case tuesday = "Di"
        case wednesday = "Mi"
        case thursday = "Do"
        case friday = "Fr"
        case saturday = "Sa"
        case sunday = "So"
        
        public var fullName: String {
            switch self {
            case .monday: return "Montag"
            case .tuesday: return "Dienstag"
            case .wednesday: return "Mittwoch"
            case .thursday: return "Donnerstag"
            case .friday: return "Freitag"
            case .saturday: return "Samstag"
            case .sunday: return "Sonntag"
            }
        }
        
        public static func from(germanName: String) -> Weekday? {
            let normalized = germanName.lowercased().trimmingCharacters(in: .whitespaces)
            for day in Weekday.allCases {
                if day.fullName.lowercased() == normalized {
                    return day
                }
            }
            return nil
        }
        
        /// Create Weekday from a Date
        public static func from(date: Date, calendar: Calendar = Calendar.current) -> Weekday? {
            let weekdayNum = calendar.component(.weekday, from: date)
            // Calendar.component(.weekday) returns 1 for Sunday, 2 for Monday, etc.
            switch weekdayNum {
            case 1: return .sunday
            case 2: return .monday
            case 3: return .tuesday
            case 4: return .wednesday
            case 5: return .thursday
            case 6: return .friday
            case 7: return .saturday
            default: return nil
            }
        }
    }
}
