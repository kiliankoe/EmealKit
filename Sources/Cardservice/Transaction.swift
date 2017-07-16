//
//  Transaction.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 16.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public struct Transaction {
    public let clientID: Int
    public let id: Int
    public let transactionID: String
    public let date: Date
    public let location: String
    public let register: String
    public let kind: Kind
    public let amount: Double
    public let positions: [Position]

    init(from service: TransactionService, with positions: [Position]) throws {
        self.clientID = service.clientID
        self.id = service.id
        self.transactionID = service.transactionID
        guard let date = Date(shortGermanDateTime: service.date) else {
            throw Error.decoding(description: "Could not decode date of format \(service.date)")
        }
        self.date = date
        self.location = service.location
        self.register = service.register
        guard let kind = Kind(from: service.kind) else {
            throw Error.decoding(description: "Found unknown Payment.Kind '\(service.kind)'")
        }
        self.kind = kind
        self.amount = service.amount
        self.positions = positions
    }

    static func create(from services: [TransactionService], filtering positions: [Position]) throws -> [Transaction] {
        var positionCount = 0

        let payments = try services.map { service -> Transaction in
            let associatedPositions = positions.filter { $0.transactionID == service.transactionID }
            positionCount += associatedPositions.count
            return try Transaction(from: service, with: associatedPositions)
        }

        if positionCount != positions.count {
            print("There was a discrepancy in the position matching... Got \(positions.count) positions, but sorted \(positionCount) 🤔")
        }

        return payments
    }
}

struct TransactionService: Codable {
    let clientID: Int
    let id: Int
    let transactionID: String
    let date: String
    let location: String
    let register: String
    let kind: String
    let amount: Double

    private enum CodingKeys: String, CodingKey {
        case clientID = "mandantId"
        case id
        case transactionID = "transFullId"
        case date = "datum"
        case location = "ortName"
        case register = "kaName"
        case kind = "typName"
        case amount = "zahlBetrag"
    }
}

public extension Transaction {
    public struct Position: Codable {
        public let clientID: Int
        public let id: Int
        public let transactionID: String
        public let positionID: Int
        public let name: String
        public let amount: Int
        public let price: Double
        public let totalPrice: Double
        public let rating: Int // ?

        private enum CodingKeys: String, CodingKey {
            case clientID = "mandantId"
            case id
            case transactionID = "transFullId"
            case positionID = "posId"
            case name
            case amount = "menge"
            case price = "epreis"
            case totalPrice = "gpreis"
            case rating = "bewertung"
        }
    }
}

public extension Transaction {
    public enum Kind {
        case sale
        case cardCharge

        init?(from: String) {
            switch from.lowercased() {
            case "verkauf":
                self = .sale
            case "karte":
                self = .cardCharge
            default:
                return nil
            }
        }
    }
}

extension Transaction: Comparable {
    public static func <(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.date < rhs.date
    }

    public static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.transactionID == rhs.transactionID
    }
}

extension Transaction: Hashable {
    public var hashValue: Int {
        return self.transactionID.hashValue
    }
}

extension Transaction: CustomStringConvertible {
    public var description: String {
        return "\(self.date.shortGerman): \(self.location) \(self.amount.priceValue)"
    }
}

extension Transaction.Position: Comparable {
    public static func <(lhs: Transaction.Position, rhs: Transaction.Position) -> Bool {
        return lhs.positionID < rhs.positionID
    }

    public static func ==(lhs: Transaction.Position, rhs: Transaction.Position) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Transaction.Position: Hashable {
    public var hashValue: Int {
        return (self.name + self.transactionID).hashValue + self.positionID.hashValue
    }
}

extension Transaction.Position: CustomStringConvertible {
    public var description: String {
        return "\(self.name) \(self.price.priceValue)"
    }
}

extension Transaction.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sale:
            return "Verkauf"
        case .cardCharge:
            return "Karte"
        }
    }
}
