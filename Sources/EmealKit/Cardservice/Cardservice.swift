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

    /// Authenticate against the Cardservice.
    ///
    /// - Parameters:
    ///   - username: Your username, probably your Emeal card number
    ///   - password: Your password
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public static func login(
        username: String,
        password: String,
        session: URLSession = .shared,
        completion: @escaping (Result<Cardservice, CardserviceError>) -> Void
    ) {
        guard let url = URL(string: "?karteNr=\(username)&format=JSON&datenformat=JSON",
                            relativeTo: URL.Cardservice.login) else {
            completion(.failure(.invalidURL))
            return
        }
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

        session.cardserviceDataTask(with: request, session: session) {
            (result: Result<[LoginResponse], CardserviceError>) in
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

    /// Authenticate against the Cardservice.
    /// - Parameters:
    ///   - username: Your username, probably your Emeal card number
    ///   - password: Your password
    ///   - session: URLSession, defaults to .shared
    /// - Returns: An authenticated `Cardservice`.
    @available(macOS 12.0, iOS 15.0, *)
    public static func login(
        username: String,
        password: String,
        session: URLSession = .shared
    ) async throws -> Cardservice {
        try await withCheckedThrowingContinuation { continuation in
            self.login(username: username, password: password, session: session) { result in
                continuation.resume(with: result)
            }
        }
    }

    /// Fetch card data associated with an account.
    ///
    /// - Parameters:
    ///   - session: URLSession, defaults to .shared
    ///   - completion: handler
    public func carddata(
        session: URLSession = .shared,
        completion: @escaping (Result<[CardData], CardserviceError>) -> Void
    ) {
        guard let url = URL(string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)",
                            relativeTo: URL.Cardservice.carddata) else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        session.cardserviceDataTask(with: request, session: session) {
            (result: Result<[CardDataService], CardserviceError>) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let servicedata):
                let carddata = servicedata.map { CardData(from: $0) }
                completion(.success(carddata))
            }
        }
    }

    /// Fetch card data associated with an account.
    /// - Parameter session: URLSession, default to .shared
    /// - Returns: An list of associated card data objects.
    @available(macOS 12.0, iOS 15.0, *)
    public func carddata(session: URLSession = .shared) async throws -> [CardData] {
        try await withCheckedThrowingContinuation { continuation in
            self.carddata(session: session) { result in
                continuation.resume(with: result)
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
    public func transactions(
        begin: Date,
        end: Date = Date(),
        session: URLSession = .shared,
        completion: @escaping (Result<[Transaction], CardserviceError>) -> Void
    ) {
        guard
            let transactionURL = URL(
                string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.dayMonthYear)&datumBis=\(end.dayMonthYear)",
                relativeTo: URL.Cardservice.transactions
            ),
            let positionsURL = URL(
                string: "?format=JSON&authToken=\(self.authToken)&karteNr=\(self.cardnumber)&datumVon=\(begin.dayMonthYear)&datumBis=\(end.dayMonthYear)",
                relativeTo: URL.Cardservice.transactionPositions
            )
        else {
            completion(.failure(.invalidURL))
            return
        }

        let transactionRequest = URLRequest(url: transactionURL)
        let positionsRequest = URLRequest(url: positionsURL)

        // TODO: Both requests here should fire simultaneously and be synchronized afterwards. They don't depend on each
        // other.
        session.cardserviceDataTask(with: transactionRequest, session: session) {
            (transactionsResult: Result<[TransactionService], CardserviceError>) in
            session.cardserviceDataTask(with: positionsRequest, session: session) {
                (positionsResult: Result<[Transaction.Position], CardserviceError>) in
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

    /// Fetch all transactions that occurred in a specific time interval.
    /// - Parameters:
    ///   - begin: start of time interval
    ///   - end: end of time interval, defaults to now
    ///   - session: URLSession, defaults to .shared
    /// - Returns: A list of transactions
    @available(macOS 12.0, iOS 15.0, *)
    public func transactions(
        begin: Date,
        end: Date = Date(),
        session: URLSession = .shared
    ) async throws -> [Transaction] {
        try await withCheckedThrowingContinuation { continuation in
            self.transactions(begin: begin, end: end, session: session) { result in
                continuation.resume(with: result)
            }
        }
    }
}
