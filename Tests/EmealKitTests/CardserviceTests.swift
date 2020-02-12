#if !os(watchOS)
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
                e.fulfill()
            case .failure(let error):
                guard
                    case .server(statusCode: let status) = error,
                    status == 599
                else {
                    XCTFail("Failed with unknown error: \(error)")
                    e.fulfill()
                    return
                }
                print(error.localizedDescription)
                e.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    static var allTests = [
        ("testLogin", testLogin)
    ]
}
#endif
