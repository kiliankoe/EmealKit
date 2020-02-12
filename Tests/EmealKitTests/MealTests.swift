#if !os(watchOS)
import XCTest
import EmealKit

class MealTests: XCTestCase {
    func testFetch() {
        let e = expectation(description: "fetch meal data")
        Meal.for(canteen: .alteMensa, on: Date(), session: MockURLSession(mockData: .meals)) { result in
            defer { e.fulfill() }
            XCTAssertNotNil(try? result.get(), "Expected meal data")
        }

        waitForExpectations(timeout: 1)
    }

    func testPlaceholderImage() {
        let meal = Meal(id: 0, name: "", notes: [], prices: nil, category: "",
                        image: URL(string: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg")!,
                        url: URL(string: "q")!)
        XCTAssert(meal.imageIsPlaceholder)
    }

    func testDiet() {
        let both = Meal(id: 0, name: "", notes: ["menü ist vegan", "vegetarisch"],
                        prices: nil, category: "", image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssertEqual(both.diet, [.vegan, .vegetarian])

        let nomeat = Meal(id: 0, name: "", notes: ["nomeat"], prices: nil, category: "",
                          image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssertEqual(nomeat.diet, [.vegetarian])
    }

    func testIngredients() {
        let all = Meal(id: 0, name: "", notes: [
            "enthält Schweinefleisch",
            "enthält Rindfleisch",
            "enthält Alkohol",
            "enthält Knoblauch",
        ], prices: nil, category: "", image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssertEqual(all.ingredients, [.pork, .beef, .alcohol, .garlic])
    }

    func testAllergens() {
        let meal = Meal(id: 0, name: "", notes: [
            "Glutenhaltiges Getreide (A)",
            "Weizen (A1)",
            "Eier (C)",
            #"Milch\/Milchzucker (Laktose) (G)"#,
            "Sellerie (I)",
            #"Sulfit\/Schwefeldioxid (L)"#
        ], prices: nil, category: "", image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssertEqual(meal.allergens, [.gluten, .eggs, .lactose, .celery, .sulfite])
    }

    func testIsDinner() {
        let lunch = Meal(id: 0, name: "", notes: [], prices: nil, category: "",
                         image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssertFalse(lunch.isDinner)

        let dinner = Meal(id: 0, name: "", notes: [], prices: nil, category: "Abendangebot",
                          image: URL(string: "q")!, url: URL(string: "q")!)
        XCTAssert(dinner.isDinner)
    }
}
#endif
