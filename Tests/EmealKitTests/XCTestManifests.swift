#if !canImport(ObjectiveC)
import XCTest

extension APITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__APITests = [
        ("testCanteenData", testCanteenData),
        ("testMealData", testMealData),
    ]
}

extension CanteenTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CanteenTests = [
        ("testFetch", testFetch),
        ("testLocation", testLocation),
    ]
}

extension CardserviceTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CardserviceTests = [
        ("testLogin", testLogin),
    ]
}

extension MealTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MealTests = [
        ("testAllergens", testAllergens),
        ("testDiet", testDiet),
        ("testFetch", testFetch),
        ("testIngredients", testIngredients),
        ("testIsDinner", testIsDinner),
        ("testPlaceholderImage", testPlaceholderImage),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests__APITests),
        testCase(CanteenTests.__allTests__CanteenTests),
        testCase(CardserviceTests.__allTests__CardserviceTests),
        testCase(MealTests.__allTests__MealTests),
    ]
}
#endif
