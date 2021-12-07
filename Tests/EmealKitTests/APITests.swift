import XCTest
import EmealKit

class APITests: XCTestCase {
    static let expectedCanteenCount = 21

    /// Tests expect one of the following canteens to have meals for the current day, otherwise they fail.
    static let expectedOpenCanteens: [CanteenId] = [.alteMensa, .mensaSiedepunkt, .mensaReichenbachstraße]

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

            XCTAssertEqual(canteens.count, Self.expectedCanteenCount)
        }

        waitForExpectations(timeout: 10)
    }

    func testMealData() {
        let e = expectation(description: "get current meal data")

        let date = Date()

        var foundMeals = false

        for canteen in Self.expectedOpenCanteens {
            let semaphore = DispatchSemaphore(value: 0)

            Meal.for(canteen: canteen, on: date) { result in
                defer { semaphore.signal() }

                guard let meals = try? result.get() else {
                    XCTFail("Invalid response: \(result)")
                    return
                }

                if !meals.isEmpty {
                    foundMeals = true
                    print("Found \(meals.count) meals at \(canteen) on \(date).")
                }
            }

            semaphore.wait()

            if foundMeals {
                break
            }
        }

        XCTAssert(foundMeals, "No meals found at these canteens: \(Self.expectedOpenCanteens)")
        e.fulfill()

        waitForExpectations(timeout: 20)
    }
}
