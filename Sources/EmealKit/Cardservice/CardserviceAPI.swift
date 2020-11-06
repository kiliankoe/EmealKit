import Foundation

internal extension URL {
    enum Cardservice {
        static let baseUrl = URL(string: "https://kartenservicedaten.studentenwerk-dresden.de:8080/")!
        static let apiBase = URL(string: "TL1/TLM/KASVC/", relativeTo: Self.baseUrl)!
        static let login = URL(string: "LOGIN", relativeTo: Self.apiBase)!
        static let carddata = URL(string: "KARTE", relativeTo: Self.apiBase)!
        static let transactions = URL(string: "TRANS", relativeTo: Self.apiBase)!
        static let transactionPositions = URL(string: "TRANSPOS", relativeTo: Self.apiBase)!
    }
}

internal extension URLSession {
    func cardserviceDataTask<T: Decodable>(with request: URLRequest,
                                           session: URLSession,
                                           completion: @escaping (Result<T, CardserviceError>) -> Void) {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic S0FTVkM6ekt2NXlFMUxaVW12VzI5SQ==", forHTTPHeaderField: "Authorization") // this is hardcoded in dataprovider.js
        request.setValue("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.network(error)))
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                let data = data
            else {
                completion(.failure(.network(nil)))
                return
            }

            guard response.statusCode / 100 == 2 else {
                completion(.failure(.server(statusCode: response.statusCode)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(.other(error)))) // LOL
                return
            }

        }

        task.resume()
    }
}
