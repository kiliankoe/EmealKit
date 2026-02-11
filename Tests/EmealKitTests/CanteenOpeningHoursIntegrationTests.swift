import XCTest
@testable import EmealKit

/// Integration test to verify opening hours are matched to canteens
final class CanteenOpeningHoursIntegrationTests: XCTestCase {

    func testCanteensWithOpeningHours() async throws {
        let canteens = try await Canteen.all()
        let canteensWithHours = canteens.filter { $0.openingHours != nil }

        XCTAssertGreaterThanOrEqual(canteensWithHours.count, 10, "Should match at least 10 canteens with opening hours")

        let names = canteensWithHours.sorted(by: { $0.name < $1.name }).map { "\($0.id) \($0.name)" }.joined(separator: ", ")
        print("Matched \(canteensWithHours.count)/\(canteens.count) canteens: \(names)")
    }
}
