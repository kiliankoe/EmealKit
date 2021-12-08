import Foundation
import XCTest
import EmealKit

@available(macOS 12.0, iOS 15.0, *)
class CardserviceTests: XCTestCase {
    lazy var username: String = ProcessInfo.processInfo.environment["EMEAL_USERNAME"]!
    lazy var password: String = ProcessInfo.processInfo.environment["EMEAL_PASSWORD"]!

    // The API is quick to throw 429 status codes on too many consecutive requests, that's why we're sleeping half a
    // second between them.

    func testLoginFailure() async {
        Thread.sleep(forTimeInterval: 0.5)
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

    func testLoginSuccess() async throws {
        Thread.sleep(forTimeInterval: 0.5)
        _ = try await Cardservice.login(username: username, password: password)
    }

    func testFetchCarddata() async throws {
        Thread.sleep(forTimeInterval: 0.5)
        let cardservice = try await Cardservice.login(username: username, password: password)
        let carddata = try await cardservice.carddata()
        XCTAssert(!carddata.isEmpty)
    }

    func testFetchTransactions() async throws {
        Thread.sleep(forTimeInterval: 0.5)
        let cardservice = try await Cardservice.login(username: username, password: password)
        let oneWeekAgo = Date().addingTimeInterval(-1 * 60 * 60 * 24 * 7)
        _ = try await cardservice.transactions(begin: oneWeekAgo)
        // Can't really assert anything here, the list of transactions is likely empty, but at least it didn't fail.
    }
}
