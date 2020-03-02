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
    let cardnumber: String
    let authToken: String

    /// Authenticate against the webservice.
    ///
    /// - Parameters:
    ///   - username: Your username, probably your card number
    ///   - password: Your password
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public static func login(username: String, password: String, session: URLSession = .shared, completion: @escaping (Result<Cardservice, CardserviceError>) -> Void) {
        let url = URL(string: "?karteNr=\(username)&format=JSON&datenformat=JSON", relativeTo: URL.Cardervice.login)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = """
        {
          "BenutzerID": "\(username)",
          "Passwort": "\(password)"
        }
        """.data(using: .utf8)
        request.httpBody = data

        session.cardserviceDataTask(with: request, session: session) { (result: Result<[LoginResponse], CardserviceError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let loginResponses):
                guard let first = loginResponses.first else {
                    completion(.failure(.authentication))
                    return
                }
                let service = Cardservice(username: username, cardnumber: first.karteNr, authToken: first.authToken)
                completion(.success(service))
            }
        }
    }

    /// Fetch card data associated with an account.
    ///
    /// - Parameters:
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public func carddata(session: URLSession = .shared, completion: @escaping (Result<[CardData], CardserviceError>) -> Void) {
        let url = URL(string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)", relativeTo: URL.Cardervice.carddata)!
        let request = URLRequest(url: url)
        session.cardserviceDataTask(with: request, session: session) { (result: Result<[CardDataService], CardserviceError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let servicedata):
                let carddata = servicedata.map { CardData(from: $0) }
                completion(.success(carddata))
            }
        }
    }


    /// Fetch all transactions that occurred in a specific time interval.
    ///
    /// - Parameters:
    ///   - begin: start of time interval
    ///   - end: end of time interval
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public func transactions(begin: Date, end: Date, session: URLSession = .shared, completion: @escaping (Result<[Transaction], CardserviceError>) -> Void) {
        // TODO: Both requests here should fire simultaneously and be synchronized afterwards. They don't depend on each other.

        let transactionURL = URL(
            string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.shortGerman)&datumBis=\(end.shortGerman)",
            relativeTo: URL.Cardervice.transactions)!
        let transactionRequest = URLRequest(url: transactionURL)
        let positionsURL = URL(
            string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.shortGerman)&datumBis=\(end.shortGerman)",
            relativeTo: URL.Cardervice.transactionPositions)!
        let positionsRequest = URLRequest(url: positionsURL)

        session.cardserviceDataTask(with: transactionRequest, session: session) { (transactionsResult: Result<[TransactionService], CardserviceError>) in
            session.cardserviceDataTask(with: positionsRequest, session: session) { (positionsResult: Result<[Transaction.Position], CardserviceError>) in
                switch (transactionsResult, positionsResult) {
                case (.failure(let error), _):
                    completion(.failure(error))
                case (_, .failure(let error)):
                    completion(.failure(error))
                case (.success(let services), .success(let positions)):
                    do {
                        var transactions = try Transaction.create(from: services, filtering: positions)
                        transactions.sort { lhs, rhs in
                            return lhs.date < rhs.date
                        }
                        completion(.success(transactions))
                    } catch let error {
                        completion(.failure(.decoding(.other(error))))
                    }
                }
            }
        }
    }
}
