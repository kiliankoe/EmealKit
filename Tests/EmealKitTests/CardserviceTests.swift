//
//  CardserviceTests.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation
import XCTest
import EmealKit

class CardserviceTests: XCTestCase {
    func testLogin() {
        let e = expectation(description: "Authenticate unsuccessfully with weird status code")
        Cardservice.login(username: "", password: "") { result in
            switch result {
            case .success(_):
                XCTFail("Shouldn't succeed with no login details")
            case .failure(let error):
                guard
                    let err = error as? EmealKit.Error,
                    case .server(statusCode: let status) = err,
                    status == 599
                else {
                    XCTFail("Failed with unknown error: \(error)")
                    return
                }
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    static var allTests = [
        ("testLogin", testLogin)
    ]
}
