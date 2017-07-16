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
    public static func login(username: String, password: String, session: URLSession = .shared, completion: @escaping (Result<Cardservice>) -> Void) {
        let url = URL(string: "?karteNr=\(username)&format=JSON&datenformat=JSON", relativeTo: .cardserviceLogin)!
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

        Network.dataTask(request: request, session: session) { (result: Result<[LoginResponse]>) in
            switch result {
            case .failure(let error):
                completion(Result(failure: error))
            case .success(let loginResponses):
                guard let first = loginResponses.first else {
                    completion(Result(failure: Error.authentication))
                    return
                }
                let service = Cardservice(username: username, cardnumber: first.karteNr, authToken: first.authToken)
                completion(Result(success: service))
            }
        }
    }

    /// Fetch card data associated with an account.
    ///
    /// - Parameters:
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public func carddata(session: URLSession = .shared, completion: @escaping (Result<[CardData]>) -> Void) {
        let url = URL(string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)", relativeTo: .cardserviceCarddata)!
        let request = URLRequest(url: url)
        Network.dataTask(request: request, session: session) { (result: Result<[CardDataService]>) in
            switch result {
            case .failure(let error):
                completion(Result(failure: error))
            case .success(let servicedata):
                let carddata = servicedata.map { CardData(from: $0) }
                completion(Result(success: carddata))
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
    public func transactions(begin: Date, end: Date, session: URLSession = .shared, completion: @escaping (Result<[Transaction]>) -> Void) {
        // TODO: Both requests here should fire simultaneously and be synchronized afterwards. They don't depend on each other.

        let transactionURL = URL(string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.shortGerman)&datumBis=\(end.shortGerman)", relativeTo: .cardserviceTransactions)!
        let transactionRequest = URLRequest(url: transactionURL)
        let positionsURL = URL(string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.shortGerman)&datumBis=\(end.shortGerman)", relativeTo: .cardserviceTransactionPositions)!
        let positionsRequest = URLRequest(url: positionsURL)

        Network.dataTask(request: transactionRequest, session: session) { (transactionsResult: Result<[TransactionService]>) in
            Network.dataTask(request: positionsRequest, session: session) { (positionsResult: Result<[Transaction.Position]>) in
                switch (transactionsResult, positionsResult) {
                case (.failure(let error), _):
                    completion(Result(failure: error))
                case (_, .failure(let error)):
                    completion(Result(failure: error))
                case (.success(let services), .success(let positions)):
                    do {
                        var transactions = try Transaction.create(from: services, filtering: positions)
                        transactions.sort { lhs, rhs in
                            return lhs.date < rhs.date
                        }
                        completion(Result(success: transactions))
                    } catch let error {
                        completion(Result(failure: error))
                    }
                }
            }
        }
    }
}
