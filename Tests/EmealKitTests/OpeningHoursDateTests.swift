import XCTest
@testable import EmealKit

final class OpeningHoursDateTests: XCTestCase {

    private var berlinCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Berlin")!
        return calendar
    }
    
    func testIsOpenWithDate() {
        // Create opening hours: Mo-Fr 11:00-14:00
        let hours = OpeningHours.WeekdayHours(
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
        )
        
        // Create a date: Monday at 12:00
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 27  // Tuesday
        components.hour = 12
        components.minute = 0
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let calendar = berlinCalendar
        let testDate = calendar.date(from: components)!
        
        // Should be open
        XCTAssertTrue(hours.isOpen(at: testDate))
        
        // Test before opening (10:00)
        components.hour = 10
        let beforeDate = calendar.date(from: components)!
        XCTAssertFalse(hours.isOpen(at: beforeDate))
        
        // Test after closing (15:00)
        components.hour = 15
        let afterDate = calendar.date(from: components)!
        XCTAssertFalse(hours.isOpen(at: afterDate))
        
        // Test on Saturday (closed)
        components.day = 1  // Saturday, Feb 1
        components.month = 2
        components.hour = 12
        let saturdayDate = calendar.date(from: components)!
        XCTAssertFalse(hours.isOpen(at: saturdayDate))
    }
    
    func testClosingTime() {
        let hours = OpeningHours.WeekdayHours(
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 30)
        )
        
        // Test during opening hours
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 27  // Tuesday
        components.hour = 12
        components.minute = 0
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let calendar = berlinCalendar
        let testDate = calendar.date(from: components)!
        
        let closingTime = hours.closingTime(from: testDate)
        XCTAssertNotNil(closingTime)
        
        // Should be 14:30 same day
        let closingComponents = calendar.dateComponents([.hour, .minute], from: closingTime!)
        XCTAssertEqual(closingComponents.hour, 14)
        XCTAssertEqual(closingComponents.minute, 30)
    }
    
    func testOpeningTime() {
        let hours = OpeningHours.WeekdayHours(
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
        )
        
        // Test before opening hours (10:00 Tuesday)
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 27  // Tuesday
        components.hour = 10
        components.minute = 0
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let calendar = berlinCalendar
        let testDate = calendar.date(from: components)!
        
        let openingTime = hours.openingTime(from: testDate)
        XCTAssertNotNil(openingTime)
        
        // Should be 11:00 same day
        let openingComponents = calendar.dateComponents([.hour, .minute, .day], from: openingTime!)
        XCTAssertEqual(openingComponents.hour, 11)
        XCTAssertEqual(openingComponents.minute, 0)
        XCTAssertEqual(openingComponents.day, 27)
    }
    
    func testOpeningTimeNextDay() {
        let hours = OpeningHours.WeekdayHours(
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
        )
        
        // Test on Saturday afternoon (closed)
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 31  // Saturday
        components.hour = 15
        components.minute = 0
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let calendar = berlinCalendar
        let testDate = calendar.date(from: components)!
        
        let openingTime = hours.openingTime(from: testDate)
        XCTAssertNotNil(openingTime)
        
        // Should be Monday 11:00
        let openingComponents = calendar.dateComponents([.weekday, .hour, .minute], from: openingTime!)
        XCTAssertEqual(openingComponents.weekday, 2)  // Monday
        XCTAssertEqual(openingComponents.hour, 11)
        XCTAssertEqual(openingComponents.minute, 0)
    }
    
    func testWeekdayFromDate() {
        let calendar = berlinCalendar
        
        // Tuesday, January 27, 2026
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 27
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let testDate = calendar.date(from: components)!
        let weekday = OpeningHours.Weekday.from(date: testDate, calendar: calendar)
        
        XCTAssertEqual(weekday, .tuesday)
    }

    func testIsOpenUsesBerlinTimezone() {
        let hours = OpeningHours.WeekdayHours(
            days: [.monday, .tuesday, .wednesday, .thursday, .friday],
            openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
            closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
        )

        // 10:30 UTC is 11:30 in Berlin (CET) on this date.
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formatter.date(from: "2026-01-26T10:30:00Z")!

        XCTAssertTrue(hours.isOpen(at: date))
    }
    
    func testTimeOfDayFromDate() {
        let calendar = berlinCalendar
        
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 27
        components.hour = 14
        components.minute = 35
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        
        let testDate = calendar.date(from: components)!
        let timeOfDay = OpeningHours.TimeOfDay.from(date: testDate, calendar: calendar)
        
        XCTAssertEqual(timeOfDay.hour, 14)
        XCTAssertEqual(timeOfDay.minute, 35)
    }
}
