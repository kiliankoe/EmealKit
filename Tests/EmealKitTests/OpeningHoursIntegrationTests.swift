import XCTest
@testable import EmealKit

/// Integration test for opening hours scraping
/// Validates against https://www.studentenwerk-dresden.de/mensen/oeffnungszeiten.html
final class OpeningHoursIntegrationTests: XCTestCase {

    func testFetchAndParseRealOpeningHours() async throws {
        let openingHoursList = try await OpeningHoursScraper.fetchOpeningHours()

        XCTAssertFalse(openingHoursList.isEmpty, "Should find at least one canteen")

        let withRegular = openingHoursList.filter { !$0.regularHours.isEmpty }.count
        let withChanged = openingHoursList.filter { !$0.changedHours.isEmpty }.count
        let names = openingHoursList.map(\.canteenName).sorted().joined(separator: ", ")

        print("Parsed \(openingHoursList.count) canteens (\(withRegular) with regular hours, \(withChanged) with changed hours): \(names)")
    }
}
