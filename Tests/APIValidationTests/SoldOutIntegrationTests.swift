import XCTest
@testable import EmealKit

/// Integration test to verify the complete sold out detection flow
final class SoldOutIntegrationTests: XCTestCase {
    
    func testSoldOutDetectionIntegration() async throws {
        // Fetch meals for Alte Mensa (canteen 4)
        let meals = try await Meal.for(canteen: 4, on: Date())
        
        // Verify we got meals
        XCTAssertFalse(meals.isEmpty, "Should fetch some meals")
        
        // Verify that isSoldOut is set (either true or false, not nil)
        let mealsWithStatus = meals.filter { $0.isSoldOut != nil }
        XCTAssertFalse(mealsWithStatus.isEmpty, "At least some meals should have sold out status")
        
        // Print results for manual verification
        let soldOutCount = meals.filter { $0.isSoldOut == true }.count
        let availableCount = meals.filter { $0.isSoldOut == false }.count
        print("\nMeals fetched: \(meals.count)")
        print("Sold out: \(soldOutCount)")
        print("Available: \(availableCount)")
        
        if soldOutCount > 0 {
            print("\nExample sold out meals:")
            for meal in meals.filter({ $0.isSoldOut == true }).prefix(3) {
                print("  - [\(meal.id)] \(meal.name)")
            }
        }
    }
}
