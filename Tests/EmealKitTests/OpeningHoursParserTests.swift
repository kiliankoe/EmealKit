import XCTest
@testable import EmealKit

final class OpeningHoursParserTests: XCTestCase {
    
    // MARK: - Weekday Parsing Tests
    
    func testParseWeekdayRange() throws {
        // Test "Mo-Fr"
        let days1 = OpeningHoursParser.parseWeekdays("Mo-Fr")
        XCTAssertEqual(days1.count, 5)
        XCTAssertTrue(days1.contains(.monday))
        XCTAssertTrue(days1.contains(.friday))
        XCTAssertFalse(days1.contains(.saturday))
        
        // Test "Mo - Do" (with spaces)
        let days2 = OpeningHoursParser.parseWeekdays("Mo - Do")
        XCTAssertEqual(days2.count, 4)
        XCTAssertTrue(days2.contains(.monday))
        XCTAssertTrue(days2.contains(.thursday))
        XCTAssertFalse(days2.contains(.friday))
        
        // Test "Montag - Freitag" (full German names)
        let days3 = OpeningHoursParser.parseWeekdays("Montag - Freitag")
        XCTAssertEqual(days3.count, 5)
        XCTAssertTrue(days3.contains(.monday))
        XCTAssertTrue(days3.contains(.friday))
    }
    
    func testParseSingleWeekday() throws {
        let days1 = OpeningHoursParser.parseWeekdays("Mo")
        XCTAssertEqual(days1, [.monday])
        
        let days2 = OpeningHoursParser.parseWeekdays("Freitag")
        XCTAssertEqual(days2, [.friday])
    }
    
    func testParseCommaSeparatedWeekdays() throws {
        let days = OpeningHoursParser.parseWeekdays("Mo, Mi, Fr")
        XCTAssertEqual(days.count, 3)
        XCTAssertTrue(days.contains(.monday))
        XCTAssertTrue(days.contains(.wednesday))
        XCTAssertTrue(days.contains(.friday))
        XCTAssertFalse(days.contains(.tuesday))
    }
    
    // MARK: - Time Parsing Tests
    
    func testParseTime() throws {
        // Test "11:00"
        let time1 = OpeningHoursParser.parseTime("11:00")
        XCTAssertEqual(time1?.hour, 11)
        XCTAssertEqual(time1?.minute, 0)
        
        // Test "11:00 Uhr"
        let time2 = OpeningHoursParser.parseTime("11:00 Uhr")
        XCTAssertEqual(time2?.hour, 11)
        XCTAssertEqual(time2?.minute, 0)
        
        // Test "8:00"
        let time3 = OpeningHoursParser.parseTime("8:00")
        XCTAssertEqual(time3?.hour, 8)
        XCTAssertEqual(time3?.minute, 0)
        
        // Test "14:30"
        let time4 = OpeningHoursParser.parseTime("14:30")
        XCTAssertEqual(time4?.hour, 14)
        XCTAssertEqual(time4?.minute, 30)
    }
    
    func testParseTimeRange() throws {
        // Test "11:00 - 14:00"
        let range1 = OpeningHoursParser.parseTimeRange("11:00 - 14:00")
        XCTAssertEqual(range1?.0.hour, 11)
        XCTAssertEqual(range1?.1.hour, 14)
        
        // Test "von 8:00 bis 17:00 Uhr"
        let range2 = OpeningHoursParser.parseTimeRange("von 8:00 bis 17:00 Uhr")
        XCTAssertEqual(range2?.0.hour, 8)
        XCTAssertEqual(range2?.1.hour, 17)
        
        // Test "10:45-14:45" (no spaces)
        let range3 = OpeningHoursParser.parseTimeRange("10:45-14:45")
        XCTAssertEqual(range3?.0.hour, 10)
        XCTAssertEqual(range3?.0.minute, 45)
        XCTAssertEqual(range3?.1.hour, 14)
        XCTAssertEqual(range3?.1.minute, 45)
    }
    
    // MARK: - Complete Hours Text Parsing Tests
    
    func testParseSimpleHours() throws {
        // Test "Mo - Fr 11:00 - 14:00 Uhr"
        let hours1 = OpeningHoursParser.parseHoursText("Mo - Fr 11:00 - 14:00 Uhr", label: "Mittagstisch")
        XCTAssertEqual(hours1.count, 1)
        XCTAssertEqual(hours1[0].label, "Mittagstisch")
        XCTAssertEqual(hours1[0].days.count, 5)
        XCTAssertTrue(hours1[0].days.contains(.monday))
        XCTAssertTrue(hours1[0].days.contains(.friday))
        XCTAssertEqual(hours1[0].openTime.hour, 11)
        XCTAssertEqual(hours1[0].closeTime.hour, 14)
        
        // Test "Montag - Freitag 08:00 - 15:00 Uhr"
        let hours2 = OpeningHoursParser.parseHoursText("Montag - Freitag 08:00 - 15:00 Uhr")
        XCTAssertEqual(hours2.count, 1)
        XCTAssertEqual(hours2[0].days.count, 5)
        XCTAssertEqual(hours2[0].openTime.hour, 8)
    }
    
    func testParseComplexHours() throws {
        // Test "Mo - Do von 10:45-14:45 Uhr und Fr von 10:45-14:15 Uhr"
        let hours = OpeningHoursParser.parseHoursText(
            "Mo - Do von 10:45-14:45 Uhr und Fr von 10:45-14:15 Uhr",
            label: "Mittagstisch im Brat²"
        )
        
        XCTAssertEqual(hours.count, 2)
        
        // First segment: Mo - Do
        XCTAssertEqual(hours[0].label, "Mittagstisch im Brat²")
        XCTAssertEqual(hours[0].days.count, 4)
        XCTAssertTrue(hours[0].days.contains(.monday))
        XCTAssertTrue(hours[0].days.contains(.thursday))
        XCTAssertFalse(hours[0].days.contains(.friday))
        XCTAssertEqual(hours[0].openTime.hour, 10)
        XCTAssertEqual(hours[0].openTime.minute, 45)
        XCTAssertEqual(hours[0].closeTime.hour, 14)
        XCTAssertEqual(hours[0].closeTime.minute, 45)
        
        // Second segment: Fr
        XCTAssertEqual(hours[1].label, "Mittagstisch im Brat²")
        XCTAssertEqual(hours[1].days, [.friday])
        XCTAssertEqual(hours[1].openTime.hour, 10)
        XCTAssertEqual(hours[1].openTime.minute, 45)
        XCTAssertEqual(hours[1].closeTime.hour, 14)
        XCTAssertEqual(hours[1].closeTime.minute, 15)
    }
    
    func testParseSplitHoursSameDay() throws {
        // Test "Montag - Donnerstag 09:00 - 15:00 Uhr und 15:30 - 18:30 Uhr"
        let hours = OpeningHoursParser.parseHoursText(
            "Montag - Donnerstag 09:00 - 15:00 Uhr und 15:30 - 18:30 Uhr"
        )
        
        XCTAssertEqual(hours.count, 2, "Should parse two time ranges")
        
        // First time range: 09:00 - 15:00
        XCTAssertEqual(hours[0].days.count, 4)
        XCTAssertTrue(hours[0].days.contains(.monday))
        XCTAssertTrue(hours[0].days.contains(.thursday))
        XCTAssertEqual(hours[0].openTime.hour, 9)
        XCTAssertEqual(hours[0].closeTime.hour, 15)
        
        // Second time range: 15:30 - 18:30 (same days)
        XCTAssertEqual(hours[1].days.count, 4)
        XCTAssertTrue(hours[1].days.contains(.monday))
        XCTAssertTrue(hours[1].days.contains(.thursday))
        XCTAssertEqual(hours[1].openTime.hour, 15)
        XCTAssertEqual(hours[1].openTime.minute, 30)
        XCTAssertEqual(hours[1].closeTime.hour, 18)
        XCTAssertEqual(hours[1].closeTime.minute, 30)
    }
    
    func testParseClosedHours() throws {
        let hours1 = OpeningHoursParser.parseHoursText("geschlossen")
        XCTAssertEqual(hours1.count, 0)
        
        let hours2 = OpeningHoursParser.parseHoursText("Die Mensa ist geschlossen.")
        XCTAssertEqual(hours2.count, 0)
    }
    
    // MARK: - Date Range Parsing Tests
    
    func testParseDateRange() throws {
        // Test "09.02.26 - 20.02.26"
        let range1 = OpeningHoursParser.parseDateRange("09.02.26 - 20.02.26")
        XCTAssertNotNil(range1)
        XCTAssertEqual(range1?.text, "09.02.26 - 20.02.26")
        XCTAssertNotNil(range1?.from)
        XCTAssertNotNil(range1?.to)
        
        let calendar = Calendar.current
        if let from = range1?.from {
            XCTAssertEqual(calendar.component(.day, from: from), 9)
            XCTAssertEqual(calendar.component(.month, from: from), 2)
            XCTAssertEqual(calendar.component(.year, from: from), 2026)
        }
        
        if let to = range1?.to {
            XCTAssertEqual(calendar.component(.day, from: to), 20)
            XCTAssertEqual(calendar.component(.month, from: to), 2)
            XCTAssertEqual(calendar.component(.year, from: to), 2026)
        }
        
        let range2 = OpeningHoursParser.parseDateRange("06.01. - 05.01.2027")
        XCTAssertNotNil(range2)
        XCTAssertEqual(range2?.text, "06.01. - 05.01.2027")
        XCTAssertNotNil(range2?.from)
        XCTAssertNotNil(range2?.to)
        
        if let from = range2?.from {
            XCTAssertEqual(calendar.component(.day, from: from), 6)
            XCTAssertEqual(calendar.component(.month, from: from), 1)
            XCTAssertEqual(calendar.component(.year, from: from), 2026)
        }
        
        if let to = range2?.to {
            XCTAssertEqual(calendar.component(.day, from: to), 5)
            XCTAssertEqual(calendar.component(.month, from: to), 1)
            XCTAssertEqual(calendar.component(.year, from: to), 2027)
        }
        
        // Test "bis 03.02.26"
        let range3 = OpeningHoursParser.parseDateRange("bis 03.02.26")
        XCTAssertNotNil(range3)
        XCTAssertNil(range3?.from)
        XCTAssertNotNil(range3?.to)
        
        // Test "ab 06.06.25"
        let range4 = OpeningHoursParser.parseDateRange("ab 06.06.25")
        XCTAssertNotNil(range4)
        XCTAssertNotNil(range4?.from)
        XCTAssertNil(range4?.to)
    }
    
    func testDateRangeIsActive() throws {
        let calendar = Calendar.current
        let today = Date()
        
        // Create a range that includes today
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let activeRange = OpeningHours.DateRange(from: yesterday, to: tomorrow, text: "test")
        XCTAssertTrue(activeRange.isActive(on: today))
        
        // Create a range in the past
        let pastRange = OpeningHours.DateRange(
            from: calendar.date(byAdding: .day, value: -10, to: today),
            to: calendar.date(byAdding: .day, value: -5, to: today),
            text: "test"
        )
        XCTAssertFalse(pastRange.isActive(on: today))
        
        // Create a range in the future
        let futureRange = OpeningHours.DateRange(
            from: calendar.date(byAdding: .day, value: 5, to: today),
            to: calendar.date(byAdding: .day, value: 10, to: today),
            text: "test"
        )
        XCTAssertFalse(futureRange.isActive(on: today))
    }
    
    // MARK: - TimeOfDay Tests
    
    func testTimeOfDayComparison() throws {
        let morning = OpeningHours.TimeOfDay(hour: 8, minute: 0)
        let noon = OpeningHours.TimeOfDay(hour: 12, minute: 0)
        let afternoon = OpeningHours.TimeOfDay(hour: 14, minute: 30)
        
        XCTAssertTrue(morning < noon)
        XCTAssertTrue(noon < afternoon)
        XCTAssertTrue(morning < afternoon)
        XCTAssertFalse(afternoon < morning)
    }
    
    func testTimeOfDayFormatted() throws {
        let time1 = OpeningHours.TimeOfDay(hour: 8, minute: 0)
        XCTAssertEqual(time1.formatted, "08:00")
        
        let time2 = OpeningHours.TimeOfDay(hour: 14, minute: 45)
        XCTAssertEqual(time2.formatted, "14:45")
    }
    
    // MARK: - WeekdayHours isOpen Tests
    
    func testIsOpen() throws {
        let hours = OpeningHours.WeekdayHours(
            label: "Mittagstisch",
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
        )
        
        // Test during opening hours
        XCTAssertTrue(hours.isOpen(on: .monday, at: OpeningHours.TimeOfDay(hour: 12, minute: 0)))
        XCTAssertTrue(hours.isOpen(on: .friday, at: OpeningHours.TimeOfDay(hour: 13, minute: 30)))
        
        // Test at exact opening time
        XCTAssertTrue(hours.isOpen(on: .monday, at: OpeningHours.TimeOfDay(hour: 11, minute: 0)))
        
        // Test at exact closing time
        XCTAssertTrue(hours.isOpen(on: .monday, at: OpeningHours.TimeOfDay(hour: 14, minute: 0)))
        
        // Test before opening
        XCTAssertFalse(hours.isOpen(on: .monday, at: OpeningHours.TimeOfDay(hour: 10, minute: 0)))
        
        // Test after closing
        XCTAssertFalse(hours.isOpen(on: .monday, at: OpeningHours.TimeOfDay(hour: 15, minute: 0)))
        
        // Test on closed day
        XCTAssertFalse(hours.isOpen(on: .saturday, at: OpeningHours.TimeOfDay(hour: 12, minute: 0)))
    }
    
    // MARK: - Real-World Example Tests
    
    func testRealWorldExamples() throws {
        // Mensa Matrix
        let matrix = OpeningHoursParser.parseHoursText(
            "Mo - Fr 10:45 - 14:00 Uhr (Hausschließung 14:30 Uhr)"
        )
        XCTAssertEqual(matrix.count, 1)
        XCTAssertEqual(matrix[0].days.count, 5)
        
        // Alte Mensa - Cafeteria Zebradiele
        let zebradiele = OpeningHoursParser.parseHoursText(
            "Mo - Fr von 8:00 bis 17:00 Uhr",
            label: "Öffnungszeiten Cafeteria Zebradiele"
        )
        XCTAssertGreaterThanOrEqual(zebradiele.count, 1, "Should parse at least one time slot")
        if zebradiele.count >= 1 {
            XCTAssertEqual(zebradiele[0].label, "Öffnungszeiten Cafeteria Zebradiele")
            XCTAssertEqual(zebradiele[0].openTime.hour, 8)
            XCTAssertEqual(zebradiele[0].closeTime.hour, 17)
        }
        
        // Mensa Siedepunkt - Abendangebot (multi-line)
        let abend = OpeningHoursParser.parseHoursText(
            "Montag - Freitag 17:30 Uhr - 20:00 Uhr\nEssenausgabe      17:30 Uhr - 19:45 Uhr"
        )
        // Should parse at least the first time range
        XCTAssertGreaterThanOrEqual(abend.count, 1)
        if abend.count >= 1 {
            XCTAssertEqual(abend[0].openTime.hour, 17)
            XCTAssertEqual(abend[0].openTime.minute, 30)
        }
    }
}
