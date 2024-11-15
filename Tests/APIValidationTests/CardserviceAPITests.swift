import Foundation
import XCTest
import EmealKit

@available(macOS 12.0, iOS 15.0, *)
class CardserviceAPITests: XCTestCase {
    lazy var username: String = ProcessInfo.processInfo.environment["EMEAL_USERNAME"] ?? ""
    lazy var password: String = ProcessInfo.processInfo.environment["EMEAL_PASSWORD"] ?? ""

    override func setUp() {
        // The API is quick to rate limit on too many consecutive requests, let's throttle it a bit.
        Thread.sleep(forTimeInterval: 1)
        super.setUp()
    }

    func testLoginFailure() async {
        do {
            _ = try await Cardservice.login(username: "", password: "")
            XCTFail("Shouldn't succeed with no login details")
        } catch {
            guard case CardserviceError.invalidLoginCredentials = error else {
                XCTFail("Unexpected error: \(error)")
                return
            }
        }
    }

    func testLoginWithIllegalCardnumber() async {
        do {
            _ = try await Cardservice.login(username: "foobar", password: "foobar")
            XCTFail("Shouldn't succeed with illegal login details")
        } catch {
            guard case CardserviceError.invalidLoginCredentials = error else {
                XCTFail("Unexpected error: \(error)")
                return
            }
        }
    }

    func testLoginWithEmptyPassword() async {
        do {
            _ = try await Cardservice.login(username: "foobar", password: "")
            XCTFail("Shouldn't succeed with illegal login details")
        } catch {
            guard case CardserviceError.invalidLoginCredentials = error else {
                XCTFail("Unexpected error: \(error)")
                return
            }
        }
    }

    func testLoginSuccess() async throws {
        if ProcessInfo.processInfo.environment["CI"] != nil {
            print("Skipping test in CI.")
            return
        }
        _ = try await Cardservice.login(username: username, password: password)
    }

    func testFetchCarddata() async throws {
        if ProcessInfo.processInfo.environment["CI"] != nil {
            print("Skipping test in CI.")
            return
        }
        let cardservice = try await Cardservice.login(username: username, password: password)
        let carddata = try await cardservice.carddata()
        XCTAssert(!carddata.isEmpty)
    }

    func testFetchTransactions() async throws {
        if ProcessInfo.processInfo.environment["CI"] != nil {
            print("Skipping test in CI.")
            return
        }
        let cardservice = try await Cardservice.login(username: username, password: password)
        let oneWeekAgo = Date().addingTimeInterval(-1 * 60 * 60 * 24 * 7)
        _ = try await cardservice.transactions(begin: oneWeekAgo)
        // Can't really assert anything here, the list of transactions is likely empty, but at least it didn't fail.
    }
}
