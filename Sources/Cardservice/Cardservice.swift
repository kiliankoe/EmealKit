//
//  Cardservice.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public struct Cardservice {
    let username: String
    let authToken: String

    public static func login(username: String, password: String, session: URLSession = .shared, completion: @escaping (Result<Cardservice>) -> Void) {
        let url = URL(string: "?karteNr=\(username)&format=JSON&datenformat=JSON", relativeTo: .cardserviceLogin)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = """
        {
          "BenutzerID": "\(username)",
          "Passwort": "\(password)"
        }
        """.data(using: .utf8)
        request.httpBody = data

        let explicitCompletion: (Result<[LoginResponse]>) -> Void = { result in
            switch result {
            case .failure(let error):
                completion(Result(failure: error))
            case .success(let loginResponses):
                guard let first = loginResponses.first else {
                    completion(Result(failure: Error.authentication))
                    return
                }
                let service = Cardservice(username: username, authToken: first.authToken)
                completion(Result(success: service))
            }
        }
        Network.dataTask(request: request, session: session, completion: explicitCompletion)
    }
}
