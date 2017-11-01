//
//  MensaTests.swift
//  StuWeDDTests
//
//  Created by Kilian Költzsch on 01.11.17.
//

import XCTest
@testable import StuWeDD

class MensaTests: XCTestCase {
    func testFeedParsing() {
        let e = expectation(description: "parse data")

        let data = try! Data(contentsOf: URL.mensaPlan)
        FeedParser(data: data) { result in
            dump(result)
            e.fulfill()
        }

        waitForExpectations(timeout: 5)
    }
}
