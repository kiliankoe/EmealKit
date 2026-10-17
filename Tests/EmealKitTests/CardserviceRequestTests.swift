import XCTest
@testable import EmealKit

class CardserviceRequestTests: XCTestCase {
    private let token = "a+b/c=d&e f"
    private var service: Cardservice { Cardservice(username: "user", cardnumber: "12+34", authToken: token) }

    /// Decodes the query like a form-decoding server does, which reads an unencoded `+` as a space.
    private func query(of url: URL) throws -> [String: String] {
        let query = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true)?.percentEncodedQuery)
        var result: [String: String] = [:]
        for pair in query.split(separator: "&") {
            let parts = pair.split(separator: "=", maxSplits: 1).map {
                $0.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
            }
            result[parts[0]] = parts.count > 1 ? parts[1] : ""
        }
        return result
    }

    func testCarddataURLEncodesCredentials() throws {
        let url = try XCTUnwrap(service.carddataURL())
        let query = try query(of: url)
        XCTAssertEqual(query["authToken"], token)
        XCTAssertEqual(query["karteNr"], "12+34")
        XCTAssertEqual(query["format"], "JSON")
    }

    func testTransactionsURLsEncodeCredentialsAndDates() throws {
        let calendar = Calendar.current
        let begin = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 2)))
        let end = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 3, day: 4)))
        let urls = try XCTUnwrap(service.transactionsURLs(begin: begin, end: end))

        for url in [urls.transactions, urls.positions] {
            let query = try query(of: url)
            XCTAssertEqual(query["authToken"], token)
            XCTAssertEqual(query["karteNr"], "12+34")
            XCTAssertEqual(query["datumVon"], "02.01.2026")
            // The end date is exclusive on the server.
            XCTAssertEqual(query["datumBis"], "05.03.2026")
        }
        XCTAssertTrue(urls.transactions.absoluteString.contains("/TRANS?"))
        XCTAssertTrue(urls.positions.absoluteString.contains("/TRANSPOS?"))
    }

    func testLoginURLEncodesPlus() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12+34", password: "secret"))
        let query = try query(of: XCTUnwrap(request.url))
        XCTAssertEqual(query["karteNr"], "12+34")
    }
}
