import XCTest
@testable import EmealKit

final class SpeiseplanScraperTests: XCTestCase {
    
    func testParseSoldOutMeals() throws {
        // Sample HTML with sold out meal
        let html = """
        <html>
        <body>
        <div class="meal">
            <a href="/mensen/speiseplan/details-329627.html">
                <span>Meal Name</span>
            </a>
            <div>
                <span class="btn btn-warning">ausverkauft</span>
            </div>
        </div>
        <div class="meal">
            <a href="/mensen/speiseplan/details-329648.html">
                <span>Another Meal</span>
            </a>
            <div>
                <span class="btn btn-primary">Infos</span>
            </div>
        </div>
        <div class="meal">
            <a href="/mensen/speiseplan/details-329624.html">
                <span>Third Meal</span>
            </a>
            <div>
                <span class="btn btn-warning">ausverkauft</span>
            </div>
        </div>
        </body>
        </html>
        """
        
        let soldOutIds = try SpeiseplanScraper.parseSoldOutMeals(from: html)
        
        XCTAssertEqual(soldOutIds.count, 2)
        XCTAssertTrue(soldOutIds.contains(329627))
        XCTAssertTrue(soldOutIds.contains(329624))
        XCTAssertFalse(soldOutIds.contains(329648))
    }
    
    func testParseEmptyHTML() throws {
        let html = "<html><body></body></html>"
        let soldOutIds = try SpeiseplanScraper.parseSoldOutMeals(from: html)
        XCTAssertEqual(soldOutIds.count, 0)
    }
    
    func testParseNoSoldOutMeals() throws {
        let html = """
        <html>
        <body>
        <div class="meal">
            <a href="/mensen/speiseplan/details-329627.html">
                <span>Meal Name</span>
            </a>
        </div>
        </body>
        </html>
        """
        
        let soldOutIds = try SpeiseplanScraper.parseSoldOutMeals(from: html)
        XCTAssertEqual(soldOutIds.count, 0)
    }
    
    func testFetchRealSpeiseplanPage() async throws {
        // Integration test - fetches the actual Speiseplan page
        let soldOutIds = try await SpeiseplanScraper.fetchSoldOutMealIds()
        
        // We can't assert exact meal IDs since they change daily,
        // but we can verify the method works without errors
        // and returns a valid set (could be empty if nothing is sold out)
        XCTAssertNotNil(soldOutIds)
        
        // Print for manual verification during development
        if !soldOutIds.isEmpty {
            print("Found \(soldOutIds.count) sold out meals: \(soldOutIds)")
        }
    }
}
