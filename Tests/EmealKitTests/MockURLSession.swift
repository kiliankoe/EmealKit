import Foundation
import EmealKit

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    init(data: MockData? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data?.rawValue.data(using: .utf8)
        self.response = response
        self.error = error
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error {
            throw error
        }
        let response = self.response ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data ?? Data(), response)
    }
}
