import XCTest
@testable import EmealKit

final class OpeningHoursComplexTests: XCTestCase {
    
    // Scenario:
    // Slot 1: 08:00 - 16:00
    // Slot 2: 10:00 - 13:00
    
    var complexHours: OpeningHours!
    var calendar: Calendar!
    
    override func setUp() {
        super.setUp()
        calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Berlin")!
        
        let slot1 = OpeningHours.TimeSlot(
            area: "Slot 1",
            dateRange: nil,
            hoursText: "08:00-16:00",
            isRegular: true,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    days: [.monday],
                    openTime: OpeningHours.TimeOfDay(hour: 8, minute: 0),
                    closeTime: OpeningHours.TimeOfDay(hour: 16, minute: 0)
                )
            ]
        )
        
        let slot2 = OpeningHours.TimeSlot(
            area: "Slot 2",
            dateRange: nil,
            hoursText: "10:00-13:00",
            isRegular: true,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    days: [.monday],
                    openTime: OpeningHours.TimeOfDay(hour: 10, minute: 0),
                    closeTime: OpeningHours.TimeOfDay(hour: 13, minute: 0)
                )
            ]
        )
        
        let slot3 = OpeningHours.TimeSlot(
            area: "Slot 3",
            dateRange: nil,
            hoursText: "11:00-13:00",
            isRegular: false,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    days: [.monday],
                    openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
                    closeTime: OpeningHours.TimeOfDay(hour: 13, minute: 0)
                )
            ]
        )
        
        complexHours = OpeningHours(
            canteenName: "Test Canteen",
            regularHours: [slot1, slot2],
            changedHours: [slot3]
        )
    }
    
    // Helper to create date for Monday at specific hour
    func monday(hour: Int, minute: Int = 0) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = 26  // A Monday
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        return calendar.date(from: components)!
    }
    
    func testScenarioAt0900() {
        // At 09:00:
        // Slot 1 (08-16) is OPEN
        // Slot 2 (10-13) is CLOSED
        // Slot 3 (10-13) is CLOSED and the only relevant one (changedHours)
        // Next event: Slot 3 opens at 10:00
        
        let now = monday(hour: 9)
        
        let openingTime = complexHours.openingTime(from: now)
        XCTAssertNotNil(openingTime)
        
        // Should be 10:00
        let components = calendar.dateComponents([.hour, .minute], from: openingTime.0!)
        XCTAssertEqual(components.hour, 10)
        XCTAssertEqual(components.minute, 0)
        
        // Tendency should be increasing (because 10:00 open is sooner than 16:00 close)
        let open = complexHours.isOpen(at: now)
        XCTAssertEqual(open, false)
    }
    
    func testScenarioAt1100() {
        // At 11:00:
        // Slot 1 (08-16) is OPEN
        // Slot 2 (10-13) is OPEN
        // Slot 3 (10-13) is OPEN and the only relevant one (changedHours)
        // Next event: Slot 3 closes at 13:00
        
        let now = monday(hour: 11)
        
        // Closing time should be 13:00 (first thing to close)
        let closingTime = complexHours.closingTime(from: now)
        XCTAssertNotNil(closingTime)
        
        let components = calendar.dateComponents([.hour, .minute], from: closingTime.0!)
        XCTAssertEqual(components.hour, 13)
        XCTAssertEqual(components.minute, 0)
        
        // Tendency should be decreasing
        let open = complexHours.isOpen(at: now)
        XCTAssertEqual(open, true)
    }
    
    func testScenarioAt1400() {
        // At 14:00:
        // Slot 1 (08-16) is OPEN
        // Slot 2 (10-13) is CLOSED
        // Slot 3 (10-13) is CLOSED and the only relevant one (changedHours)
        // Next event: Slot 1 normally closes at 16:00 but the canteen is already closed
        
        let now = monday(hour: 14)
        
        let closingTime = complexHours.closingTime(from: now)
        XCTAssertNotNil(closingTime)
        
        let components = calendar.dateComponents([.hour, .minute], from: closingTime.0!)
        XCTAssertEqual(components.hour, 16)
        XCTAssertEqual(components.minute, 0)
        
        // Tendency should be decreasing (next event is 16:00 close)
        let open = complexHours.isOpen(at: now)
        XCTAssertEqual(open, false)
    }
}
