import Foundation
import Regex

/// Parses German opening hours text into structured data
struct OpeningHoursParser {
    
    // MARK: - Weekday Parsing
    
    /// Parses weekday ranges like "Mo-Fr", "Mo - Do", "Montag - Freitag"
    static func parseWeekdays(_ text: String) -> Set<OpeningHours.Weekday> {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var result = Set<OpeningHours.Weekday>()
        
        // Try range patterns: "Mo-Fr", "Mo - Fr", "Montag - Freitag"
        if let days = parseWeekdayRange(normalized) {
            return days
        }
        
        // Try comma-separated: "Mo, Mi, Fr"
        if normalized.contains(",") {
            let parts = normalized.components(separatedBy: ",")
            for part in parts {
                if let day = parseSingleWeekday(part.trimmingCharacters(in: .whitespaces)) {
                    result.insert(day)
                }
            }
            if !result.isEmpty {
                return result
            }
        }
        
        // Try single weekday
        if let day = parseSingleWeekday(normalized) {
            result.insert(day)
        }
        
        return result
    }
    
    private static func parseWeekdayRange(_ text: String) -> Set<OpeningHours.Weekday>? {
        // Pattern: "Mo-Fr" or "Mo - Fr" or "Montag - Freitag"
        let rangeRegex = Regex(#"(\w+)\s*-\s*(\w+)"#)
        guard let match = rangeRegex.firstMatch(in: text),
              let startText = match.captures[0],
              let endText = match.captures[1],
              let start = parseSingleWeekday(startText),
              let end = parseSingleWeekday(endText) else {
            return nil
        }
        
        // Get all days between start and end
        let allDays = OpeningHours.Weekday.allCases
        guard let startIdx = allDays.firstIndex(of: start),
              let endIdx = allDays.firstIndex(of: end) else {
            return nil
        }
        
        if startIdx <= endIdx {
            return Set(allDays[startIdx...endIdx])
        } else {
            // Wrap around (e.g., Fr-Mo would be Fr, Sa, So, Mo)
            return Set(allDays[startIdx...] + allDays[...endIdx])
        }
    }
    
    private static func parseSingleWeekday(_ text: String) -> OpeningHours.Weekday? {
        let normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try short form (Mo, Di, etc.)
        if let day = OpeningHours.Weekday(rawValue: normalized) {
            return day
        }
        
        // Try full German name
        return OpeningHours.Weekday.from(germanName: normalized)
    }
    
    // MARK: - Time Parsing
    
    /// Parses time strings like "11:00", "11.00", "11:00 Uhr"
    static func parseTime(_ text: String) -> OpeningHours.TimeOfDay? {
        let normalized = text.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "Uhr", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // Pattern: "11:00" or "11.00"
        let timeRegex = Regex(#"(\d{1,2})[:.](\d{2})"#)
        guard let match = timeRegex.firstMatch(in: normalized),
              let hourStr = match.captures[0],
              let minuteStr = match.captures[1],
              let hour = Int(hourStr),
              let minute = Int(minuteStr),
              hour >= 0 && hour < 24,
              minute >= 0 && minute < 60 else {
            return nil
        }
        
        return OpeningHours.TimeOfDay(hour: hour, minute: minute)
    }
    
    /// Parses time ranges like "11:00 - 14:00", "von 8:00 bis 17:00 Uhr"
    static func parseTimeRange(_ text: String) -> (OpeningHours.TimeOfDay, OpeningHours.TimeOfDay)? {
        var normalized = text.trimmingCharacters(in: .whitespaces)
        
        // Handle "von X bis Y" format by converting to "X - Y"
        if normalized.lowercased().contains("von") && normalized.lowercased().contains("bis") {
            // Pattern: "von 8:00 bis 17:00"
            let vonBisPattern = Regex(#"von\s+(\d{1,2}[:\.]\d{2})\s+bis\s+(\d{1,2}[:\.]\d{2})"#)
            if let match = vonBisPattern.firstMatch(in: normalized),
               let openStr = match.captures[0],
               let closeStr = match.captures[1],
               let openTime = parseTime(openStr),
               let closeTime = parseTime(closeStr) {
                return (openTime, closeTime)
            }
        }
        
        // Remove German prepositions for standard format
        normalized = normalized.replacingOccurrences(of: "von ", with: "")
        normalized = normalized.replacingOccurrences(of: "bis ", with: "")
        
        // Pattern: "11:00 - 14:00" or "11:00-14:00"
        let components = normalized.components(separatedBy: "-")
        guard components.count == 2,
              let openTime = parseTime(components[0]),
              let closeTime = parseTime(components[1]) else {
            return nil
        }
        
        return (openTime, closeTime)
    }
    
    // MARK: - Complex Hours Parsing
    
    /// Parses complete hours text like "Mo - Fr 11:00 - 14:00 Uhr" or complex cases with multiple time ranges
    /// The label parameter is the area/service name from the table (e.g., "Mittagstisch im Brat²")
    static func parseHoursText(_ text: String, label: String? = nil) -> [OpeningHours.WeekdayHours] {
        var result: [OpeningHours.WeekdayHours] = []
        
        // Handle "closed" / "geschlossen"
        let lowerText = text.lowercased()
        if lowerText.contains("geschlossen") || lowerText.contains("closed") {
            return []
        }
        
        // First, try to find all time ranges in the text
        // Allow optional "Uhr" inside the range, e.g. "17:30 Uhr - 20:00 Uhr"
        let timeRangePattern = Regex(#"(\d{1,2}[:\.]\d{2})(?:\s+Uhr)?\s*-\s*(\d{1,2}[:\.]\d{2})"#)
        let vonBisPattern = Regex(#"von\s+(\d{1,2}[:\.]\d{2})\s+bis\s+(\d{1,2}[:\.]\d{2})"#)
        
        let timeMatches = timeRangePattern.allMatches(in: text)
        let vonBisMatches = vonBisPattern.allMatches(in: text)
        
        if timeMatches.count == 0 && vonBisMatches.count == 0 {
            return []
        }
        
        // Strategy: Find weekday ranges, then associate following time ranges with them
        
        // Split by newlines first (handles multi-line entries)
        let lines = text.components(separatedBy: "\n")
        var currentContextDays: Set<OpeningHours.Weekday>? = nil
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            if trimmedLine.isEmpty { continue }
            
            // Try to parse this line
            let (lineResults, lastDays) = parseLine(trimmedLine, label: label, initialContextDays: currentContextDays)
            result.append(contentsOf: lineResults)
            
            // Update context for next line if we found days
            if let days = lastDays {
                currentContextDays = days
            }
        }
        
        // If nothing was parsed from lines (and we had newlines?), try the whole text as fallback if result is empty
        // But parseLine logic already handles single line correctly.
        // If result is empty but we had matches, maybe newline split broke it?
        // But typically lines work better.
        
        return result
    }
    
    /// Parses a single line which may contain multiple time ranges
    /// Returns the parsed hours and the last active weekdays found (for context propagation)
    private static func parseLine(_ line: String, label: String?, initialContextDays: Set<OpeningHours.Weekday>? = nil) -> ([OpeningHours.WeekdayHours], Set<OpeningHours.Weekday>?) {
        var result: [OpeningHours.WeekdayHours] = []
        
        // Find all time ranges to check if line is relevant
        let timeRangePattern = Regex(#"(\d{1,2}[:\.]\d{2})(?:\s+Uhr)?\s*-\s*(\d{1,2}[:\.]\d{2})"#)
        let vonBisPattern = Regex(#"von\s+(\d{1,2}[:\.]\d{2})\s+bis\s+(\d{1,2}[:\.]\d{2})"#)
        
        let timeMatches = timeRangePattern.allMatches(in: line)
        let vonBisMatches = vonBisPattern.allMatches(in: line)
        
        if timeMatches.isEmpty && vonBisMatches.isEmpty {
            return ([], initialContextDays)
        }
        
        // Strategy: Look for pattern changes
        // If we see "... und Fr von ..." it means new weekdays
        // If we see "... und 15:30 - 18:30" (just time, no weekdays), same weekdays
        
        // Split by " und " to find segments
        let segments = line.components(separatedBy: " und ")
        
        // Track current days for this line
        var currentDays: Set<OpeningHours.Weekday>? = initialContextDays
        
        for segment in segments {
            let trimmed = segment.trimmingCharacters(in: .whitespaces)
            
            // Try to find weekdays in this segment
            let segmentDays = extractWeekdaysFromSegment(trimmed)
            
            if !segmentDays.isEmpty {
                // New weekdays found - use them
                currentDays = segmentDays
            } 
            // else: no weekdays found, reuse currentDays
            
            // Now parse time range from this segment
            if let hours = parseSingleHoursSegment(trimmed, label: label, forceDays: currentDays) {
                result.append(hours)
                // Remember the days for next segment
                currentDays = hours.days
            }
        }
        
        return (result, currentDays)
    }
    
    /// Extracts weekdays from a text segment without parsing times
    private static func extractWeekdaysFromSegment(_ text: String) -> Set<OpeningHours.Weekday> {
        // Remove time patterns to avoid confusion
        var cleaned = text
        
        // Remove "von X bis Y" patterns first
        let vonBisPattern = Regex(#"von\s+\d{1,2}[:\.]\d{2}\s+bis\s+\d{1,2}[:\.]\d{2}"#)
        for match in vonBisPattern.allMatches(in: cleaned).reversed() {
            let range = match.range
            cleaned.removeSubrange(range)
        }
        
        // Remove all standard time patterns like "10:45 - 14:00" or "17:30 Uhr - 20:00"
        let timePattern = Regex(#"\d{1,2}[:\.]\d{2}(?:\s+Uhr)?\s*-\s*\d{1,2}[:\.]\d{2}"#)
        for match in timePattern.allMatches(in: cleaned).reversed() {
            let range = match.range
            cleaned.removeSubrange(range)
        }
        
        // Remove common words
        cleaned = cleaned.replacingOccurrences(of: "von ", with: "")
        cleaned = cleaned.replacingOccurrences(of: "bis ", with: "")
        cleaned = cleaned.replacingOccurrences(of: "Uhr", with: "")
        
        return parseWeekdays(cleaned)
    }
    
    /// Parses a single segment like "Mo - Fr 11:00 - 14:00 Uhr"
    /// If forceDays is provided, use those days instead of parsing
    private static func parseSingleHoursSegment(_ text: String, label: String?, forceDays: Set<OpeningHours.Weekday>? = nil) -> OpeningHours.WeekdayHours? {
        // Try to find time range - handle both "X - Y" and "von X bis Y" patterns
        var openTime: OpeningHours.TimeOfDay?
        var closeTime: OpeningHours.TimeOfDay?
        
        // First try "von X bis Y" pattern
        let vonBisPattern = Regex(#"von\s+(\d{1,2}[:\.]\d{2})\s+bis\s+(\d{1,2}[:\.]\d{2})"#)
        if let vonBisMatch = vonBisPattern.firstMatch(in: text),
           let openStr = vonBisMatch.captures[0],
           let closeStr = vonBisMatch.captures[1] {
            openTime = parseTime(openStr)
            closeTime = parseTime(closeStr)
        }
        
        // If not found, try standard "X - Y" pattern
        if openTime == nil || closeTime == nil {
            let timeRangePattern = Regex(#"(\d{1,2}[:\.]\d{2})(?:\s+Uhr)?\s*-\s*(\d{1,2}[:\.]\d{2})"#)
            if let timeMatch = timeRangePattern.firstMatch(in: text),
               let openTimeStr = timeMatch.captures[0],
               let closeTimeStr = timeMatch.captures[1] {
                openTime = parseTime(openTimeStr)
                closeTime = parseTime(closeTimeStr)
            }
        }
        
        guard let open = openTime, let close = closeTime else {
            return nil
        }
        
        // Use forced days if provided, otherwise extract from text
        let days: Set<OpeningHours.Weekday>
        if let forceDays = forceDays {
            days = forceDays
        } else {
            // Extract weekdays from the text
            days = extractWeekdaysFromSegment(text)
        }
        
        guard !days.isEmpty else {
            return nil
        }
        
        return OpeningHours.WeekdayHours(label: label, days: days, openTime: open, closeTime: close)
    }
    
    // MARK: - Date Range Parsing
    
    /// Infers year for start date based on end date if they differ
    static func inferYear(start: Date?, end: Date?) -> (Date?, Date?) {
        guard let start = start, let end = end else { return (start, end) }
        
        let calendar = Calendar.current
        let startYear = calendar.component(.year, from: start)
        let endYear = calendar.component(.year, from: end)
        
        /*if start > end && startYear == endYear {
            var components = calendar.dateComponents([.day, .month], from: start)
            components.year = endYear + 1
            components.timeZone = TimeZone(identifier: "Europe/Berlin")
            if let newStart = calendar.date(from: components) {
                return (newStart, end)
            }
        }*/
        
        // If explicit end year provided (e.g. 2026) and start inferred current year (e.g. 2025),
        // update start to match end year.
        if endYear != startYear || (endYear == startYear && start > end) {
            var components = calendar.dateComponents([.day, .month], from: start)
            components.year = endYear - 1
            components.timeZone = TimeZone(identifier: "Europe/Berlin")
            if let newStart = calendar.date(from: components) {
                return (newStart, end)
            }
        }
        
        return (start, end)
    }
    
    /// Parses date ranges like "09.02.26 - 20.02.26", "bis 03.02.26", "ab 06.06.25"
    /// Also handles: "vom 02.02. bis 03.02.2026" (mixed formats with/without year)
    static func parseDateRange(_ text: String) -> OpeningHours.DateRange? {
        let normalized = text.trimmingCharacters(in: .whitespaces)
        
        // Empty string
        if normalized.isEmpty {
            return nil
        }
        
        // Pattern: "vom DD.MM. bis DD.MM.YYYY" or "vom DD.MM.YY bis DD.MM.YYYY"
        let vonBisPattern = Regex(#"vom\s+(\d{2}\.\d{2}\.(?:\d{2,4})?)\s+bis\s+(\d{2}\.\d{2}\.(?:\d{2,4})?)"#)
        if let match = vonBisPattern.firstMatch(in: normalized),
           let startStr = match.captures[0],
           let endStr = match.captures[1] {
            var startDate = parseGermanDate(startStr)
            var endDate = parseGermanDate(endStr)
            
            // Fix year inference if mixed precision
            (startDate, endDate) = inferYear(start: startDate, end: endDate)
            
            return OpeningHours.DateRange(from: startDate, to: endDate, text: normalized)
        }
        
        // Pattern: "DD.MM.YY - DD.MM.YY" or "DD.MM.YYYY - DD.MM.YYYY"
        // Also: "DD.MM. - DD.MM.YYYY"
        let rangeRegex = Regex(#"(\d{2}\.\d{2}\.(?:\d{2,4})?)\s*-\s*(\d{2}\.\d{2}\.(?:\d{2,4})?)"#)
        if let match = rangeRegex.firstMatch(in: normalized),
           let startStr = match.captures[0],
           let endStr = match.captures[1] {
            var startDate = parseGermanDate(startStr)
            var endDate = parseGermanDate(endStr)
            
            // Fix year inference
            (startDate, endDate) = inferYear(start: startDate, end: endDate)
            
            return OpeningHours.DateRange(from: startDate, to: endDate, text: normalized)
        }
        
        // Pattern: "bis DD.MM.YY" or "bis DD.MM.YYYY" or "bis DD.MM."
        let untilRegex = Regex(#"bis\s+(\d{2}\.\d{2}\.(?:\d{2,4})?)"#)
        if let match = untilRegex.firstMatch(in: normalized),
           let dateStr = match.captures[0] {
            let date = parseGermanDate(dateStr)
            return OpeningHours.DateRange(from: nil, to: date, text: normalized)
        }
        
        // Pattern: "ab DD.MM.YY" or "ab DD.MM.YYYY" or "ab DD.MM."
        let fromRegex = Regex(#"ab\s+(\d{2}\.\d{2}\.(?:\d{2,4})?)"#)
        if let match = fromRegex.firstMatch(in: normalized),
           let dateStr = match.captures[0] {
            let date = parseGermanDate(dateStr)
            return OpeningHours.DateRange(from: date, to: nil, text: normalized)
        }
        
        // Single date: "DD.MM.YY" or "DD.MM.YYYY" or "DD.MM."
        let dateRegex = Regex(#"(\d{2}\.\d{2}\.(?:\d{2,4})?)"#)
        if let match = dateRegex.firstMatch(in: normalized),
           let dateStr = match.captures[0] {
            let date = parseGermanDate(dateStr)
            return OpeningHours.DateRange(from: date, to: date, text: normalized)
        }
        
        // Couldn't parse, but has text - return as-is for display
        return OpeningHours.DateRange(from: nil, to: nil, text: normalized)
    }
    
    /// Parses German date format into Date
    /// Supports: "DD.MM.YY", "DD.MM.YYYY", "DD.MM." (no year - assumes current/next year)
    private static func parseGermanDate(_ text: String) -> Date? {
        let components = text.components(separatedBy: ".")
        guard components.count >= 2,
              let day = Int(components[0]),
              let month = Int(components[1]) else {
            return nil
        }
        
        let year: Int
        if components.count >= 3 && !components[2].isEmpty {
            guard let yearValue = Int(components[2]) else {
                return nil
            }
            
            // Convert year based on length
            if yearValue < 100 {
                // 2-digit year (e.g., "26" -> 2026)
                year = 2000 + yearValue
            } else {
                // 4-digit year (e.g., "2026")
                year = yearValue
            }
        } else {
            // No year provided - assume current or next year based on month
            let now = Date()
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: now)
            let currentMonth = calendar.component(.month, from: now)
            
            // If the month is in the past, assume next year
            if month < currentMonth {
                year = currentYear + 1
            } else {
                year = currentYear
            }
        }
        
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        dateComponents.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        return Calendar.current.date(from: dateComponents)
    }
}
