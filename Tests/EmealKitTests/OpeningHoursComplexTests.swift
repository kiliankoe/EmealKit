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
        // Changed hours (Slot 3, 11-13) override regular hours
        // Slot 3 is closed → canteen is closed
        // Next opening: Slot 3 at 11:00

        let now = monday(hour: 9)

        XCTAssertFalse(complexHours.isOpen(at: now))

        let openingTime = complexHours.openingTime(from: now)
        XCTAssertNotNil(openingTime.0)

        let components = calendar.dateComponents([.hour, .minute], from: openingTime.0!)
        XCTAssertEqual(components.hour, 11)
        XCTAssertEqual(components.minute, 0)
    }
    
    func testScenarioAt1100() {
        // At 11:00:
        // Changed hours (Slot 3, 11-13) override regular hours
        // Slot 3 is open → canteen is open, closes at 13:00

        let now = monday(hour: 11)

        XCTAssertTrue(complexHours.isOpen(at: now))

        let closingTime = complexHours.closingTime(from: now)
        XCTAssertNotNil(closingTime.0)

        let components = calendar.dateComponents([.hour, .minute], from: closingTime.0!)
        XCTAssertEqual(components.hour, 13)
        XCTAssertEqual(components.minute, 0)
    }
    
    func testScenarioAt1400() {
        // At 14:00:
        // Changed hours (Slot 3, 11-13) override regular hours
        // Slot 3 is closed → canteen is closed
        // No closing time (nothing is open)

        let now = monday(hour: 14)

        XCTAssertFalse(complexHours.isOpen(at: now))

        let closingTime = complexHours.closingTime(from: now)
        XCTAssertNil(closingTime.0)
    }

    func testUnparseableChangedHoursFallBackToRegularHours() {
        let regularSlot = OpeningHours.TimeSlot(
            area: "Regular",
            dateRange: nil,
            hoursText: "Mo 11:00-14:00",
            isRegular: true,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    days: [.monday],
                    openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
                    closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
                )
            ]
        )

        let informationalChangedSlot = OpeningHours.TimeSlot(
            area: "Prufungszeit",
            dateRange: nil,
            hoursText: "Sehr geehrte Gaste, nur bis 15:00 Uhr geoffnet, Mittagstisch bis 14:00 Uhr.",
            isRegular: false,
            parsedHours: []
        )

        let openingHours = OpeningHours(
            canteenName: "Fallback Test",
            regularHours: [regularSlot],
            changedHours: [informationalChangedSlot]
        )

        XCTAssertTrue(openingHours.hasChangedHours(at: monday(hour: 12)))
        XCTAssertTrue(openingHours.isOpen(at: monday(hour: 12)))

        let opening = openingHours.openingTime(from: monday(hour: 9))
        let components = calendar.dateComponents([.hour, .minute], from: opening.0!)
        XCTAssertEqual(components.hour, 11)
        XCTAssertEqual(components.minute, 0)
    }

    func testExplicitClosureChangedHoursOverrideRegularHours() {
        let regularSlot = OpeningHours.TimeSlot(
            area: "Regular",
            dateRange: nil,
            hoursText: "Mo 11:00-14:00",
            isRegular: true,
            parsedHours: [
                OpeningHours.WeekdayHours(
                    days: [.monday],
                    openTime: OpeningHours.TimeOfDay(hour: 11, minute: 0),
                    closeTime: OpeningHours.TimeOfDay(hour: 14, minute: 0)
                )
            ]
        )

        let closedChangedSlot = OpeningHours.TimeSlot(
            area: "Ferien",
            dateRange: nil,
            hoursText: "Die Mensa ist geschlossen.",
            isRegular: false,
            parsedHours: []
        )

        let openingHours = OpeningHours(
            canteenName: "Closure Test",
            regularHours: [regularSlot],
            changedHours: [closedChangedSlot]
        )

        XCTAssertTrue(openingHours.hasChangedHours(at: monday(hour: 12)))
        XCTAssertFalse(openingHours.isOpen(at: monday(hour: 12)))
        XCTAssertNil(openingHours.openingTime(from: monday(hour: 12)).0)
        XCTAssertNil(openingHours.closingTime(from: monday(hour: 12)).0)
    }
}
