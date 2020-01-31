import XCTest
import EmealKit

class APITests: XCTestCase {
    func testMealData() {
        let e = expectation(description: "get current meal data")

        var date = Date()
        if Calendar(identifier: .gregorian).isDateInWeekend(date) {
            print("Moving meal validation date into the next week to skip the weekend.")
            date.addTimeInterval(3 * 24 * 3600)
        }

        Meal.for(canteen: .alteMensa, on: date) { result in
            defer { e.fulfill() }

            guard let meals = try? result.get() else {
                XCTFail("Invalid response")
                return
            }

            if meals.isEmpty {
                XCTFail("No meals found at Alte Mensa (4).")
            } else {
                print("Found \(meals.count) meals at Alte Mensa (4) on \(date).")
            }
        }

        waitForExpectations(timeout: 10)
    }

    func testCanteenData() {
        let e = expectation(description: "get current canteen data")

        Canteen.all { result in
            defer { e.fulfill() }

            guard let canteens = try? result.get() else {
                XCTFail("Invalid response.")
                return
            }

            if canteens.isEmpty {
                XCTFail("No canteens found in response.")
            }

            let canteensList = canteens
                .sorted { $0.id < $1.id }
                .map { "\($0.id) \($0.name)" }
                .joined(separator: "\n- ")
            print("Found the following \(canteens.count) canteens: \n- \(canteensList)")
        }

        waitForExpectations(timeout: 10)
    }
}
