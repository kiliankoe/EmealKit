import XCTest
import EmealKit

class MealTests: XCTestCase {
    @available(macOS 12.0, iOS 15.0, *)
    func testMockFetchAndDecode() async throws {
        let meals = try await Meal.for(canteen: .alteMensa, on: Date(), session: MockURLSession(data: .meals))
        XCTAssertEqual(meals.count, 4)
    }

    func testPlaceholderImage() {
        let meal = Meal(
            id: 0,
            name: "",
            notes: [],
            prices: nil,
            category: "",
            image: URL(string: "https://static.studentenwerk-dresden.de/bilder/mensen/studentenwerk-dresden-lieber-mensen-gehen.jpg")!,
            url: URL(string: "q")!
        )
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

    func testDecodePrices() throws {
        let expectedPricesJson = """
        {
            "Studierende": 1.0,
            "Bedienstete": 1.0
        }
        """.data(using: .utf8)!
        let prices1 = try JSONDecoder().decode(Meal.Prices.self, from: expectedPricesJson)
        XCTAssertEqual(prices1.students, 1.0)
        XCTAssertEqual(prices1.employees, 1.0)

        let extraColonPrices = """
        {
            "Studierende:": 1.0,
            "Bedienstete:": 1.0
        }
        """.data(using: .utf8)!
        let prices2 = try JSONDecoder().decode(Meal.Prices.self, from: extraColonPrices)
        XCTAssertEqual(prices2.students, 1.0)
        XCTAssertEqual(prices2.employees, 1.0)
    }

    @available(macOS 12.0, iOS 15.0, *)
    func testSoldOut() async throws {
        let meals = try await Meal.for(canteen: .alteMensa, on: Date(), session: MockURLSession(data: .meals))
        XCTAssertEqual(meals[0].isSoldOut, true)
        XCTAssertEqual(meals[1].isSoldOut, false)
    }
}

