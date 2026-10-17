import XCTest
@testable import EmealKit

class CardserviceLoginTests: XCTestCase {
    private func body(of request: URLRequest) throws -> [String: String] {
        let data = try XCTUnwrap(request.httpBody)
        return try JSONDecoder().decode([String: String].self, from: data)
    }

    func testBodyContainsCredentials() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12345", password: "secret"))
        XCTAssertEqual(try body(of: request), ["BenutzerID": "12345", "Passwort": "secret"])
    }

    func testBodyEscapesSpecialCharactersInPassword() throws {
        let password = #"a"b\c{d}"#
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12345", password: password))
        XCTAssertEqual(try body(of: request)["Passwort"], password)
    }

    func testQueryContainsTrimmedCardnumber() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: " 12345 ", password: "secret"))
        let url = try XCTUnwrap(request.url)
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true))
        XCTAssertEqual(components.queryItems?.first { $0.name == "karteNr" }?.value, "12345")
    }

    func testQueryEncodesCardnumber() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12 3&4", password: "secret"))
        let url = try XCTUnwrap(request.url)
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: true))
        XCTAssertEqual(components.queryItems?.first { $0.name == "karteNr" }?.value, "12 3&4")
    }

    func testBodyKeepsSlashesUnescaped() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12345", password: "a/b"))
        let body = try XCTUnwrap(request.httpBody.flatMap { String(data: $0, encoding: .utf8) })
        XCTAssertTrue(body.contains(#""a/b""#))
    }

    func testIsJSONPost() throws {
        let request = try XCTUnwrap(Cardservice.loginRequest(username: "12345", password: "secret"))
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
    }
}
