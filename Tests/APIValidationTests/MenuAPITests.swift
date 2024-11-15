import XCTest
import EmealKit

@available(macOS 12.0, iOS 15.0, *)
class MenuAPITests: XCTestCase {
    static let expectedCanteenCount = 16

    /// Tests expect one of the following canteens to have meals for the current day, otherwise they fail.
    static let expectedOpenCanteens: [CanteenId] = [.alteMensa, .mensaSiedepunkt, .mensaReichenbachstraße]

    func testCanteenData() async throws {
        let canteens = try await Canteen.all()
        XCTAssert(!canteens.isEmpty, "No canteens found in response.")
        XCTAssertEqual(canteens.count, Self.expectedCanteenCount)

        let canteenList = canteens
            .sorted { $0.id < $1.id }
            .map { "\($0.id) \($0.name)" }
            .joined(separator: "\n- ")
        print("Found the following \(canteens.count) canteens: \n- \(canteenList)")
    }

    func testMealData() async throws {
        let date = Date()
        var foundMeals = false

        for canteenId in Self.expectedOpenCanteens {
            let meals = try await Meal.for(canteen: canteenId, on: date)
            if !meals.isEmpty {
                foundMeals = true
                break
            }
        }

        XCTAssert(foundMeals, "No meals found at these canteens: \(Self.expectedOpenCanteens)")
    }
}
