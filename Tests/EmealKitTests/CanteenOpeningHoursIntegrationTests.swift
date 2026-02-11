import XCTest
@testable import EmealKit

/// Integration test to verify opening hours are matched to canteens
final class CanteenOpeningHoursIntegrationTests: XCTestCase {
    
    func testCanteensWithOpeningHours() async throws {
        print("\n=== Canteen Opening Hours Integration Test ===\n")
        
        let canteens = try await Canteen.all()
        
        let canteensWithHours = canteens.filter { $0.openingHours != nil }
        
        print("Total canteens: \(canteens.count)")
        print("Canteens with opening hours: \(canteensWithHours.count)\n")
        
        for canteen in canteensWithHours.sorted(by: { $0.name < $1.name }) {
            print("\n📍 \(canteen.name) (ID: \(canteen.id))")
            guard let hours = canteen.openingHours else { continue }
            
            if !hours.regularHours.isEmpty {
                print("   Regular Hours:")
                for slot in hours.regularHours.prefix(3) {
                    print("      • \(slot.area): \(slot.hoursText)")
                }
                if hours.regularHours.count > 3 {
                    print("      ... (\(hours.regularHours.count - 3) more)")
                }
            }
            
            if !hours.changedHours.isEmpty {
                print("   Changed Hours: \(hours.changedHours.count) entries")
            }
        }
        
        print("\n✅ Matched \(canteensWithHours.count) out of \(canteens.count) canteens")
        
        // Assert we matched most canteens
        XCTAssertGreaterThanOrEqual(canteensWithHours.count, 10, "Should match at least 10 canteens with opening hours")
    }
}
