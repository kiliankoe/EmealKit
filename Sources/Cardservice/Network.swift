//
//  Network.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

enum Network {
    static func dataTask<T: Decodable>(request: URLRequest, session: URLSession = .shared, completion: @escaping (Result<T>) -> Void) {
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic S0FTVkM6ekt2NXlFMUxaVW12VzI5SQ==", forHTTPHeaderField: "Authorization") // this is hardcoded in dataprovider.js
        request.setValue("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(Result(failure: error!))
                return
            }

            guard
                let response = response as? HTTPURLResponse,
                let data = data
            else {
                completion(Result(failure: Error.network))
                return
            }

            guard response.statusCode / 100 == 2 else {
                completion(Result(failure: Error.server(statusCode: response.statusCode)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(Result(success: decoded))
            } catch {
                completion(Result(failure: error))
                return
            }

            }.resume()
    }
}
