//
//  Transaction.swift
//  StuWeDD
//
//  Created by Kilian Költzsch on 15.07.17.
//  Copyright © 2017 StuWeDD. All rights reserved.
//

import Foundation

public struct Transaction: Codable {
    public let clientID: Int
    public let id: Int
    public let fullID: String
    public let positionID: Int
    public let name: String
    public let amount: Int
    public let ePrice: Double // ?
    public let gPrice: Double // ?
    public let rating: Int // ?

    private enum CodingKeys: String, CodingKey {
        case clientID = "mandantId"
        case id
        case fullID = "transFullId"
        case positionID = "posId"
        case name
        case amount = "menge"
        case ePrice = "epreis"
        case gPrice = "gpreis"
        case rating = "bewertung"
    }
}
