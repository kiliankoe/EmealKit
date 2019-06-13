//
//  MensaTests.swift
//  StuWeDDTests
//
//  Created by Kilian Költzsch on 01.11.17.
//

import XCTest
import StuWeDD

class MensaTests: XCTestCase {
    func testFeedParsing() {
        let e = expectation(description: "get some data")

        Meal.fetch(forMensa: .alteMensa) { result in
            guard let meals = result.success else {
                XCTFail()
                e.fulfill()
                return
            }

            for meal in meals {
                print("\(meal.name) -> \(meal.price?.student.euroString ?? "n/a")")
            }

            e.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
