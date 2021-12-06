import Foundation
import XCTest
import EmealKit

@available(macOS 12.0, iOS 15.0, *)
class CardserviceTests: XCTestCase {
    var cardservice: Cardservice?

    override func setUp() async throws {
        try await super.setUp()

        guard self.cardservice == nil else {
            // Let's skip subsequent login calls so as not to spam the API.
            return
        }

        guard let username = ProcessInfo.processInfo.environment["EMEAL_USERNAME"],
              let password = ProcessInfo.processInfo.environment["EMEAL_PASSWORD"]
        else {
            XCTFail("No authentication details found in environment.")
            return
        }
        do {
            self.cardservice = try await Cardservice.login(username: username, password: password)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testLoginFailure() async {
        Thread.sleep(forTimeInterval: 1)
        do {
            _ = try await Cardservice.login(username: "", password: "")
            XCTFail("Shouldn't succeed with no login details")
        } catch {
            guard case CardserviceError.server(statusCode: 599) = error else {
                XCTFail("Unexpected error: \(error)")
                return
            }
        }
    }

    func _testLoginSuccess() async {
        // No need to test this, since other tests implicitly test successful authentication as well.
    }

    func testFetchCarddata() async {
        Thread.sleep(forTimeInterval: 1)
        do {
            let carddata = try await self.cardservice?.carddata()
            XCTAssertNotNil(carddata)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchTransactions() async {
        Thread.sleep(forTimeInterval: 1)
        do {
            let lastWeek = Date().addingTimeInterval(-1 * 60 * 60 * 24 * 7)
            let today = Date()
            let transactions = try await self.cardservice?.transactions(begin: lastWeek, end: today)
            XCTAssertNotNil(transactions)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
